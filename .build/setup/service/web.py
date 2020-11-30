"""
"""
from docker import DockerCompose
from common import Directories, ConfigManager
import util
import time
import logging

logger = logging.getLogger(__name__)


class WebService:
    SERVICE_NAME = "webapp"

    def __init__(self):
        self.dirs = Directories.instance()
        self.config = ConfigManager.instance().config

    # ----------
    # Client API
    # ----------
    def inject_cmfive_config_file(self, db_hostname):
        logger.info("inject config.php into web container")

        # add or override db_hostname config
        tokens = dict(self.config)
        tokens.update({"db_instance_endpoint": db_hostname})

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
            container.copy_into(
                source=self.dirs.stage.joinpath("config.php"),
                target="/var/www/html/config.php"
            )

    def install_test_packages(self):
        logger.info("install test packages")
        self.run("sh test/.install/install.sh")

    def install_core(self):
        logger.info("install cmfive core")
        self.run(f"php cmfive.php install core {self.config['cmfive_core_ref']}")

    def seed_encryption(self):
        logger.info("seed encryption key")
        self.run("php cmfive.php seed encryption")

    def install_migration(self):
        logger.info("perform module database migrations")
        self.run("php cmfive.php install migration")

    def seed_admin(self):
        logger.info("seed cmfive admin user")
        self.run("php cmfive.php seed admin '{}' '{}' '{}' '{}' '{}'".format(
            self.config['admin_first_name'],
            self.config['admin_last_name'],
            self.config['admin_email'],
            self.config['admin_login_username'],
            self.config['admin_login_password']
        ))

    def update_permissions(self):
        logger.info("update container permissions")
        self.run("chmod 777 -R cache storage uploads")

    @staticmethod
    def snapshot_container(tag):
        container = WebService.container_by_index(0)
        util.run(f"docker commit {container.container_name} {tag}")

    # ---------------
    # Private Methods
    # ---------------
    def run(self, command):
        """run command against web service container(s)"""
        for container in DockerCompose.containers_by_service(self.SERVICE_NAME):
            container.run_command(command)

    @staticmethod
    def container_by_index(index):
        containers = list(DockerCompose.containers_by_service(WebService.SERVICE_NAME))
        return containers[index]
