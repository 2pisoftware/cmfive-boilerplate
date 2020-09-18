from common import Config, Directories
import util
import logging
import json

logger = logging.getLogger(__name__)


class Container:
    def __init__(self, guid):
        stdout, _, _ = util.run(f"docker container inspect {guid}")
        self.context = json.loads(stdout)

    def run_command(self, command):
        return util.run(command, self.container_name)

    def copy_file_into(self, source, target):
        util.run("docker cp {source} {container_name}:{target}".format(
            source=source,
            container_name=self.container_name,
            target=target
        ), None)

    @property
    def service(self):
        return self.context[0]["Config"]["Labels"]["com.docker.compose.service"]

    @property
    def container_name(self):
        return self.context[0]["Name"].split("/")[1]


class DockerCompose:
    def __init__(self):
        self.dirs = Directories.instance()
        self.config = Config.instance().config

    # Client API
    def up(self):
        logger.info('init docker environment')
        self.init_environment()

        logger.info('docker compose up')
        return util.run('docker-compose up -d')

    def init_environment(self):
        """prepare docker, docker-compose and image configs"""
        self.create_stage_directory()
        self.create_docker_compose_file()
        self.create_docker_file()
        self.add_docker_ignore_file()

    @staticmethod
    def containers_by_service(service):
        for container in DockerCompose.containers():
            if container.service == service:
                yield container

    @staticmethod
    def containers():
        stdout, _, _ = util.run('docker-compose ps -q')
        return (Container(guid) for guid in stdout.split("\n"))

    # Helper Methods
    def create_stage_directory(self):
        """create temp stage dir for image configs"""
        logger.info('create stage directory')
        util.delete_dir(self.dirs.stage)
        util.copy_dirs(self.dirs.common, self.dirs.stage)
        util.copy_dirs(self.dirs.image, self.dirs.stage)
        util.inflate_templates(self.dirs.stage, ".template", self.config, True)

    def create_docker_compose_file(self):
        """inflate docker-compose.yml template into root dir"""
        logger.info('create docker compose file')
        util.inflate_template(
            self.dirs.docker.joinpath("docker-compose.yml.template"),
            self.dirs.root,
            ".template",
            self.config,
            False
        )

    def create_docker_file(self):
        """inflate Dockerfile into environment/<env> dir"""
        logger.info('create docker file')
        util.inflate_template(
            self.dirs.docker.joinpath("Dockerfile.template"),
            self.dirs.env,
            ".template",
            self.config,
            False
        )

    def add_docker_ignore_file(self):
        """copy .dockerignore to root dir if exist"""
        logger.info('add docker ignore file')
        source = self.dirs.docker.joinpath(".dockerignore")

        if source.exists():
            target = self.dirs.root.joinpath(".dockerignore")
            target.write_text(source.read_text())
