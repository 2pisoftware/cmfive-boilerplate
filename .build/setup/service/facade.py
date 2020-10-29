from service import WebService, DatabaseService
import logging

logger = logging.getLogger(__name__)


class Facade:
    def __init__(self):
        self.web = WebService()
        self.db = DatabaseService()

    def create_cmfive_config_file(self):
        logger.info('create cmfive config file')
        self.web.create_cmfive_config_file(self.db.hostname)

    def install_test_packages(self):
        logger.info('install test packages')
        self.web.install_test_packages()

    def setup_cmfive(self):
        logger.info('setup cmfive')
        self.web.setup_cmfive()

    def create_database(self):
        logger.info('create database')
        self.db.create_database()    