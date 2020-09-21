import logging
from common import init_singletons
from docker import DockerCompose
from service import Facade


logger = logging.getLogger(__name__)

class Cmfive:
    def __init__(self):
        self.compose = DockerCompose()
        self.facade = Facade()

    def setup(self):
        logger.info('\n-- step 1. docker compose --')
        self.compose.up()

        logger.info('\n-- step 2. cmfive install --')
        self.install()


class CmfiveDevelopment(Cmfive):
    def __init__(self):
        super().__init__()

    def install(self):
        self.facade.create_database()
        self.facade.create_cmfive_config_file()
        self.facade.install_test_packages()
        self.facade.setup_cmfive()

    @classmethod
    def create(cls):
        init_singletons("dev", True)
        return cls()


"""
class CmfiveProduction(Cmfive):
    def __init__(self):
        super().__init__()

    def install(self):
        self.facade.create_database()
        self.facade.create_cmfive_config_file()
        self.facade.setup_cmfive()

    @classmethod
    def create(cls):
        init_singletons("prod", False)
        return cls()
"""