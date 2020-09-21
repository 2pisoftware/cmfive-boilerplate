"""
"""
from docker import DockerCompose
from common import Directories, Config
import util
import time
import logging

logger = logging.getLogger(__name__)


class WebService:
    SERVICE_NAME = "webapp"

    def __init__(self):
        self.dirs = Directories.instance()
        self.config = Config.instance().config

    # ----------
    # Client API
    # ----------
    def create_cmfive_config_file(self, db_hostname):
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
        self.run("sh test/.install/install.sh")

    def setup_cmfive(self):
        self.run("php cmfive.php install core")
        self.run("php cmfive.php seed encryption")
        self.run("php cmfive.php install migration")
        self.run("php cmfive.php seed admin '{}' '{}' '{}' '{}' '{}'".format(
            self.config['admin_username'],
            self.config['admin_password'],
            self.config['admin_email'],
            self.config['admin_login_username'],
            self.config['admin_login_password']
        ))

        # modify folder permissions
        self.run("chmod 777 -R cache storage uploads")

    @staticmethod
    def tag_image(tag):
        util.run(f"docker tag {WebService.image_name()} {tag}")

    @staticmethod
    def image_name():
        """docker-compose names image as <dir>_<service>"""
        dirs = Directories.instance()
        prefix = dirs.root.resolve().name
        name = f"{prefix}_{WebService.SERVICE_NAME}"

        return name

    # ---------------
    # Private Methods
    # ---------------
    def run(self, command):
        """run command against web service container(s)"""
        for container in DockerCompose.containers_by_service(self.SERVICE_NAME):
            container.run_command(command)
