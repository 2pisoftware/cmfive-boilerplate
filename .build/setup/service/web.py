"""

"""
from docker import DockerCompose
from config import Directories, Config
import util
import time
import logging

logger = logging.getLogger(__name__)


class WebService:
    SERVICE_NAME = "webapp"    

    def __init__(self, env):
        self.dirs = Directories(env)
        self.config = Config.data(env)

    # ----------
    # Client API
    # ----------
    def create_cmfive_config_file(self, db_hostname):      
        """"""          
        # add or override db_hostname config
        tokens = dict(self.config)
        tokens.update({"db_hostname": db_hostname})        

        # render template into stage dir
        util.inflate_template(
            self.dirs.cmfive.joinpath("config.php.template"),
            self.dirs.stage,
            ".template",
            tokens,
            False
        )
        
        # copy file into container(s)
        for container in DockerCompose.containers_by_service(self.SERVICE_NAME):
            container.copy_file_into(
                source=self.dirs.stage.joinpath("config.php"), 
                target="/var/www/html/config.php"
            )

    def install_test_packages(self):        
        util.run("sh test/.install/install.sh", self.web_container())

    def setup_cmfive(self):        
        util.run("php cmfive.php install core", self.web_container())
        util.run("php cmfive.php seed encryption", self.web_container())
        util.run("php cmfive.php install migration", self.web_container())
        util.run("php cmfive.php seed admin '{}' '{}' '{}' '{}' '{}'".format(
            self.config['admin_username'],
            self.config['admin_password'],
            self.config['admin_email'],
            self.config['admin_login_username'],
            self.config['admin_login_password']
        ), self.web_container())

        # modify folder permissions
        util.run(f"chmod 777 -R cache storage uploads", self.web_container())

    # ---------------
    # Private Methods
    # ---------------
    def web_container(self):
        return "nginx-php7.2"

    #def run(self):
    #    """<here>"""
    #    for container in DockerCompose.containers_by_service(self.SERVICE_NAME):
    #        pass
            
