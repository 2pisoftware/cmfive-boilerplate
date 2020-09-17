from service import WebService, DatabaseService
import logging

logger = logging.getLogger(__name__)

class Facade:
    def __init__(self, env):                        
        self._web = None
        self._db = None
        self.env = env
    
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

    @property
    def web(self):        
        if self._web is None:
            self._web = WebService(self.env)
        return self._web

    @property
    def db(self):
        if self._db is None:
            self._db = DatabaseService(self.env)
        return self._db
