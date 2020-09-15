"""
<description>
"""
from config import Directories, Config
import util
import time


class Service:
    def __init__(self, env):
        self.dirs = Directories(env)
        self.config = Config.data(env)


class WebService(Service):
    SERVICE_NAME = "webapp"

    def create_cmfive_config_file(self):
        util.inflate_template(
            self.dirs.cmfive.joinpath("config.php.template"),
            self.dirs.root,
            ".template",
            self.config,
            False
        )

    def install_test_packages(self):
        print('install test packages')
        util.run("sh test/.install/install.sh", self.web_container())

    def setup_cmfive(self):
        print('setup_cmfive')
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
        command = 'mysql -u root -proot -e "SHOW STATUS;"'
        elapsed, timeout, increment = 0, 60, 10

        while elapsed < timeout:
            try:
                util.run(command, self.db_container())
            except:
                elapsed += increment
                time.sleep(increment)
            else:
                break
        else:
            raise Exception("mysql wait timeout")

    def create_database(self):
        print("database")
        self.wait_for_database()
        sql = """
            CREATE DATABASE {db_database};
            CREATE USER '{db_username}'@'%' IDENTIFIED BY '{db_password}';
            GRANT ALL PRIVILEGES ON {db_database}.* TO '{db_username}'@'%';
            FLUSH PRIVILEGES;
        """.format(**self.config)

        util.run(f'mysql -u root -proot -e "{sql}"', self.db_container())

    # temp
    def db_container(self):
        return "mysql-5.7"
