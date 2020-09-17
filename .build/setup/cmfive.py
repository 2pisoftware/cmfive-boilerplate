import logging
from docker import DockerCompose
from service import Facade


logger = logging.getLogger(__name__)

class Cmfive:
    def __init__(self, env):        
        self.compose = DockerCompose(env)
        self.facade = Facade(env)        

    def setup(self):        
        logger.info('\n-- step 1. docker compose --')
        self.compose.up()

        logger.info('\n-- step 2. cmfive install --')
        self.install()


class CmfiveDevelopment(Cmfive):
    def __init__(self):
        super().__init__("prod")

    def install(self):
        self.facade.create_database()
        self.facade.create_cmfive_config_file()
        self.facade.install_test_packages()
        self.facade.setup_cmfive()
