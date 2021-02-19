import logging
import util
from common import init_singletons, ConfigManager, Directories
from docker import DockerCompose
from service import WebService, DatabaseService, cicd, vscode


logger = logging.getLogger(__name__)


# --------------
# Helper Classes
# --------------
class ActionTemplate:
    def __init__(self):
        self.compose = DockerCompose()
        self.web = WebService()
        self.db = DatabaseService()               
        self.dirs = Directories.instance()

    # ----------
    # Client API
    # ----------
    def init_environment(self):
        # docker compose up
        logger.info('\n-- step 1. docker compose --')
        self.compose.up()

    def setup(self):
        # subclass defines setup steps
        logger.info('\n-- step 2. setup cmfive --')
        self.setup_hook()

        # post setup - optional
        util.run_scripts(self.dirs.scripts, "main")

    def create_image(self, tag):
        # snapshot web container
        logger.info('\n-- step 3. snapshot web container --')
        WebService.snapshot_container(tag)

    def stop_environment(self):
        # teardown cmfive instance
        logger.info('\n-- step 4. teardown cmfive instance --')
        DockerCompose().down()    


class ProvisionDevelopmentInstance(ActionTemplate):
    def __init__(self, reuse_config):
        super().__init__()
        self.reuse_config = reuse_config

    def execute(self):
        self.init_environment()
        self.setup()

    def setup_hook(self):
        # cmfive setup steps        
        exists = self.db.database_exists()
                
        # create database once
        if not exists:
            self.db.create_database()

        # idempotent operations        
        # ---------------------
        if not self.reuse_config:
            self.web.inject_cmfive_config_file(self.db.hostname)
        
        self.web.install_core()
        self.web.seed_encryption()
        self.web.install_test_packages()
        self.web.install_migration()
        # ----------------------

        # seed admin user once
        if not exists:
            self.web.seed_admin()

        # fix
        self.web.update_permissions()

        # miscellaneous        
        vscode.setup_php_xdebug_config()

    @classmethod
    def create(cls, reuse_config):
        init_singletons("dev")
        return cls(reuse_config)


class ProvisionTestInstance(ActionTemplate):
    def __init__(self, reuse_config):
        super().__init__()
        self.reuse_config = reuse_config

    def execute(self):
        self.init_environment()
        self.setup()
    
    def setup_hook(self):
        # cmfive setup steps        
        exists = self.db.database_exists()
                
        # create database once
        if not exists:
            self.db.create_database()

        # idempotent operations        
        # ---------------------
        if not self.reuse_config:
            self.web.inject_cmfive_config_file(self.db.hostname)
        
        self.web.install_core()
        self.web.seed_encryption()
        self.web.install_test_packages()
        self.web.install_migration()
        # ----------------------

        # seed admin user once
        if not exists:
            self.web.seed_admin()

        # fix
        self.web.update_permissions()

    @classmethod
    def create(cls, reuse_config):
        init_singletons("test")
        return cls(reuse_config)


class CreateProductionImage(ActionTemplate):
    def execute(self, *args):
        self.init_environment()
        self.setup()
        self.create_image(args[0])
        self.stop_environment()

    def setup_hook(self):
        # cmfive setup steps        
        exists = self.db.database_exists()

        # create database once
        if not exists:
            self.db.create_database()

        # idempotent operations
        # ---------------------
        self.web.inject_cmfive_config_file(self.db.hostname)
        self.web.install_core()
        self.web.seed_encryption()
        cicd.install_crm_modules(self.web.SERVICE_NAME)
        self.web.install_migration()
        # ---------------------
        
         # seed admin user once
        if not exists:
            self.web.seed_admin()

        # fix
        self.web.update_permissions()

    @classmethod
    def create(cls):
        init_singletons("prod")
        return cls()


# -------
# Actions
# -------
def update_default():
    init_singletons("default")
    DockerCompose().init_environment()


def provision_dev(reuse_config):
    action = ProvisionDevelopmentInstance.create(reuse_config)
    action.execute()


def provision_test(reuse_config):
    action = ProvisionTestInstance.create(reuse_config)
    action.execute()


def create_production_image(tag):
    action = CreateProductionImage.create()
    action.execute(tag)


def test_config_resolver(environment):
    init_singletons(environment)
    return ConfigManager.instance().config
