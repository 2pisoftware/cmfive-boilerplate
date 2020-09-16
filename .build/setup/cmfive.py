import logging
from docker import DockerCompose
from service import WebService, DatabaseService


logger = logging.getLogger(__name__)

class Cmfive:
    def __init__(self, env):
        self.compose = DockerCompose(env)
        self.web = WebService(env)
        self.db = DatabaseService(env)

    def setup(self):
        logger.info('\n-- step 1. cmfive pre-setup --')
        self.pre_setup()
        logger.info('\n-- step 2. docker compose --')
        self.compose.up()
        logger.info('\n-- step 3. cmfive post-setup --')
        self.post_setup()


class CmfiveDevelopment(Cmfive):
    def __init__(self):
        super().__init__("dev")

    def pre_setup(self):
        """before docker-compose up"""                
        #self.web.create_cmfive_config_file()

    def post_setup(self):
        """after docker-compose up"""
        self.web.create_cmfive_config_file()

        #self.db.create_database()
        #self.web.install_test_packages()
        #self.web.setup_cmfive()


class CmfiveProduction(Cmfive):
    def __init__(self):
        super().__init__("prod")

    def pre_setup(self):
        """before docker-compose up"""        
        self.web.create_cmfive_config_file()

    def post_setup(self):
        """after docker-compose up"""
        self.db.create_database()
        self.web.install_test_packages()
        self.web.setup_cmfive()