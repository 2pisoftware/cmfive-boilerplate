import logging
import util
from common import create_shared_context
from config import ConfigManager
from docker import DockerCompose
from service import WebService, DatabaseService, cicd, vscode


logger = logging.getLogger(__name__)


# --------------
# Helper Classes
# --------------
class ActionTemplate:
    def __init__(self, env, context=None):        
        self.context = context if context else create_shared_context(env)        
        self.compose = DockerCompose(self.context)
        self.web = WebService(self.context)
        self.db = DatabaseService(self.context)

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
        util.run_scripts(self.context.dirs.scripts, "main")

    def create_image(self, tag):
        # snapshot web container
        logger.info('\n-- step 3. snapshot web container --')
        WebService.snapshot_container(tag)

    def stop_environment(self):
        # teardown cmfive instance
        logger.info('\n-- step 4. teardown cmfive instance --')
        DockerCompose(self.context).down()


class ProvisionDevelopmentInstance(ActionTemplate):
    def __init__(self, env, reuse_config):
        super().__init__(env)
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
        vscode.setup_php_xdebug_config(self.context)


class ProvisionTestInstance(ActionTemplate):
    def __init__(self, env, context):
        super().__init__(env, context)        

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
        cicd.install_crm_modules(self.context, self.web.SERVICE_NAME)
        self.web.install_migration()
        # ---------------------
        
         # seed admin user once
        if not exists:
            self.web.seed_admin()

        # fix
        self.web.update_permissions()


# -------
# Actions
# -------
def update_default():
    context = create_shared_context("default")
    DockerCompose(context).init_environment()


def provision_dev(reuse_config):
    action = ProvisionDevelopmentInstance('dev', reuse_config)
    action.execute()


def provision_test(config):
    env = 'test'

    # update config with values user provided in CLI
    context = create_shared_context(env)
    context.manager.config.update(config)

    # init and execute action    
    action = ProvisionTestInstance(env, context)
    action.execute()


def create_production_image(tag):
    action = CreateProductionImage('prod')
    action.execute(tag)


def test_config_resolver(environment):
    context = create_shared_context(environment)
    return ConfigManager(environment, context.dirs).config


def prime_environment(environment):
    context = create_shared_context(environment)
    DockerCompose(context).init_environment()
