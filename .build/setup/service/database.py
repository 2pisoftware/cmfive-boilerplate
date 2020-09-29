"""
"""
from docker import DockerCompose
from common import Directories, ConfigManager
import util
import time
import logging

logger = logging.getLogger(__name__)


# ----------------
# Database Service
# ----------------
class DatabaseService:
    SERVICE_NAME = "mysqldb"

    def __init__(self):
        self.dirs = Directories.instance()
        self.config = ConfigManager.instance().config
        self._service = None

    # ----------
    # Client API
    # ----------
    def create_database(self):
        self.wait_for_database()
        self.run("""
            CREATE DATABASE {db_database};
            CREATE USER '{db_username}'@'%' IDENTIFIED BY '{db_password}';
            GRANT ALL PRIVILEGES ON {db_database}.* TO '{db_username}'@'%';
            FLUSH PRIVILEGES;
        """.format(**self.config))

    @property
    def hostname(self):
        return self.service.hostname()

    # ---------------
    # Private Methods
    # ---------------
    def run(self, sql):
        return self.service.run(sql)

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

    @property
    def service(self):
        """lazy load service"""
        # assumes docker-compose up has been invoked
        if self._service is None:
            if self.is_database_container_present():
                # database running in container
                self._service = DatabaseServiceContainer()
            else:
                # database running on host
                self._service = DatabaseServiceHost()

        return self._service

    @staticmethod
    def is_database_container_present():
        containers = list(DockerCompose.containers_by_service(
            DatabaseService.SERVICE_NAME)
        )
        assert len(containers) < 2, "must be zero or one database containers"

        return len(containers) == 1


class DatabaseServiceHost:
    """
    This class represents a database running on a host, if used, the
    pre-condition is the 'db_hostname' config is defined.
    """
    def __init__(self):
        self.config = Config.instance().config

    def run(self, sql):
        """run sql against database on host"""

        # pre-condition
        if "db_hostname" not in self.config:
            raise Exception("config 'db_hostname' required")

        # run command
        return util.run(
            command='mysql -h {db_hostname} -u root -proot -e "{sql}"'.format(
                db_hostname=self.config["db_hostname"],
                sql=sql
            ),
            container_name=None
        )

    def hostname(self):
        return self.config["db_hostname"]


class DatabaseServiceContainer:
    """
    This class represents a database running in a container. The container name is
    used as the value for the config 'db_hostname'.
    """
    def run(self, sql):
        """run sql against database in container"""
        # run command
        return util.run(
            command='mysql -h {db_hostname} -u root -proot -e "{sql}"'.format(
                db_hostname="127.0.0.1",
                sql=sql
            ),
            container_name=self.container_name()
        )

    def hostname(self):
        return self.container_name()

    @staticmethod
    def container_name():
        containers = list(DockerCompose.containers_by_service(
            DatabaseService.SERVICE_NAME)
        )
        return containers[0].container_name
