"""
todo:
- test status codes on cmfive.php for database migrtion failure
- review file permissions
- unit tests
- documentation
- review security
- comments
"""
import logging
import click
from cmfive import CmfiveDevelopment, CmfiveProduction


def setup_logger(level):
    # logger
    logging.basicConfig(
        format="time: %(asctime)s, module: %(name)s, line: %(lineno)s, level: %(levelname)s, Msg: %(message)s",
        datefmt="%Y-%m-%d %H:%M:%S",
        level=getattr(logging, level.upper())
    )


# ----------------------
# Command Line Interface
# ----------------------
@click.group()
@click.option('--verbose', default='info', help='log level')
def cli(verbose):
    setup_logger(verbose)


@cli.command('provision-dev')
def provision_dev():
    cmfive = CmfiveDevelopment.create()
    cmfive.setup()


@cli.command('provision-prod')
def provision_prod():
    cmfive = CmfiveProduction.create()
    cmfive.setup()


if __name__ == '__main__':
    cli()
