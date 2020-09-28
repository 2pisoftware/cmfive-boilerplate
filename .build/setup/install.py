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
from actions import (
    update_default,
    provision_dev,
    create_production_image,
    update_production_image,
)


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


@cli.command('update-default')
def update_default_cmd():
    """update docker-compose defualt """
    update_default()


@cli.command('provision-dev')
def provision_dev_cmd():
    """provision cmfive devlopment instance"""
    provision_dev()


@cli.command('create-production-image')
@click.argument('tag')
def create_production_image_cmd(tag):
    """create vanila production image"""
    create_production_image(tag)


@cli.command('update-production-image')
@click.argument('tag')
def create_production_image_cmd(tag):
    """update production image"""
    update_production_image(tag)

if __name__ == '__main__':
    cli()
