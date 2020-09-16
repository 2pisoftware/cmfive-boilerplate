"""
"""
from docker import DockerCompose
from config import Directories, Config
import util
import time
import logging

logger = logging.getLogger(__name__)

class Service:
    def __init__(self, env):
        self.dirs = Directories(env)
        self.config = Config.data(env)


class WebService(Service):
    SERVICE_NAME = "webapp"    

    def create_cmfive_config_file(self):      
        """dynamically """  
        logger.info('create cmfive config file')
        
        # pre-condition
        containers = list(DockerCompose.containers_by_service(
            DatabaseService.SERVICE_NAME)
        )
        assert len(containers) < 2, "must be zero or one database containers"

        # use container name as database hostname
        if containers:
            db_hostname = containers[0].container_name
        # must be supplied by config
        else:
            if "db_hostname" not in self.config:
                raise Exception("config 'db_hostname' required")
            db_hostname = self.config["db_hostname"]

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
        logger.info('install test packages')
        util.run("sh test/.install/install.sh", self.web_container())

    def setup_cmfive(self):
        logger.info('setup cmfive')
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

    # temp
    def web_container(self):
        return "nginx-php7.2"



class DatabaseService(Service):
    SERVICE_NAME = "mysqldb"

    def wait_for_database(self):
        elapsed, timeout, increment = 0, 60, 10

        while elapsed < timeout:
            try:
                self.run("SHOW STATUS;")
            except Exception as exc:
                # other error
                if "Can't connect to MySQL server on" not in str(exc):
                    raise Exception("mysql wait failed") from exc

                elapsed += increment
                time.sleep(increment)
            else:
                # database connection varified
                break
        else:
            raise Exception("mysql wait timeout")

    def create_database(self):
        logger.info('create database')
        self.wait_for_database()
        self.run("""
            CREATE DATABASE {db_database};
            CREATE USER '{db_username}'@'%' IDENTIFIED BY '{db_password}';
            GRANT ALL PRIVILEGES ON {db_database}.* TO '{db_username}'@'%';
            FLUSH PRIVILEGES;
        """.format(**self.config))

    def run(self, sql):
        """run sql against database container or host"""
        # pre-condition
        containers = list(DockerCompose.containers_by_service(self.SERVICE_NAME))
        assert len(containers) < 2, "must be zero or one database containers"

        # stage command to run against database container
        if containers:
            args = {
                "db_hostname": "127.0.0.1",
                "container_name": containers[0].container_name
            }
        # stage command to run on host
        else:
            # mandatory
            if "db_hostname" not in self.config:
                raise Exception("config 'db_hostname' required")

            args = {
                "db_hostname": self.config["db_hostname"],
                "container_name": None
            }

        # run command
        util.run(
            command='mysql -h {db_hostname} -u root -proot -e "{sql}"'.format(
                db_hostname=args['db_hostname'],
                sql=sql
            ),
            container_name=args['container_name']
        )
