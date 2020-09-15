"""
todo:
- logging
- test status codes on cmfive.php for database migrtion failure
- environment variable override
- make command run exceptions less generic
- review file permissions
- jinja2 enforce substituion
- unit tests
- documentation
- review security
- docker-overide
- comments
"""

import click
from docker import DockerCompose
from service import WebService, DatabaseService


class Cmfive:
    def __init__(self, env):
        self.compose = DockerCompose(env)
        self.web = WebService(env)
        self.db = DatabaseService(env)

    def setup(self):
        self.pre_setup()
        self.compose.up()
        self.post_setup()


class CmfiveDevelopment(Cmfive):
    def pre_setup(self):
        """before docker-compose up"""
        self.web.create_cmfive_config_file()

    def post_setup(self):
        """after docker-compose up"""
        self.db.create_database()
        self.web.install_test_packages()
        self.web.setup_cmfive()


# ----------------------
# Command Line Interface
# ----------------------
@click.group()
def cli():
    pass


@cli.command('test')
def test():
    CmfiveDevelopment("dev").setup()

if __name__ == '__main__':
    cli()
