from config import Config, Directories
import util


class Container:
    def __init__(self, guid):
        stdout, _, _ = run(f"docker container inspect {guid}")
        self.context = json.loads(stdout)

    def run_command(self, command):
        return util.run(command, self.hostname)

    @property
    def service(self):
        return self.context[0]["Config"]["Labels"]["com.docker.compose.service"]

    @property
    def container_name(self):
        return self.context[0]["Name"]


class DockerCompose:
    def __init__(self, env):
        self.dirs = Directories(env)
        self.config = Config.data(env)

    # Client API
    def up(self):
        self.init_environment()
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
        stdout, _, _ = run('docker-compose ps -q')
        return (Container(guid) for guid in stdout.split("\n"))

    # Helper Methods
    def create_stage_directory(self):
        """create temp stage dir for image configs"""
        util.delete_dir(self.dirs.stage)
        util.copy_dirs(self.dirs.common, self.dirs.stage)
        util.copy_dirs(self.dirs.image, self.dirs.stage)
        util.inflate_templates(self.dirs.stage, ".template", self.config, True)

    def create_docker_compose_file(self):
        """inflate docker-compose.yml template into root dir"""
        util.inflate_template(
            self.dirs.docker.joinpath("docker-compose.yml.template"),
            self.dirs.root,
            ".template",
            self.config,
            False
        )

    def create_docker_file(self):
        """inflate Dockerfile into environment/<env> dir"""
        util.inflate_template(
            self.dirs.docker.joinpath("Dockerfile.template"),
            self.dirs.env,
            ".template",
            self.config,
            False
        )

    def add_docker_ignore_file(self):
        """copy .dockerignore to root dir if exist"""
        source = self.dirs.docker.joinpath(".dockerignore")

        if source.exists():
            target = self.dirs.root.joinpath(".dockerignore")
            target.write_text(source.read_text())
