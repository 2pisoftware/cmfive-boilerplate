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
from decorator import literal_cmd_options
from actions import (
    update_default,
    provision_dev,
    provision_test,
    create_production_image,
    test_config_resolver,
    prime_environment
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
@click.option('-rc', '--reuse_config', default=False)
def provision_dev_cmd(reuse_config):
    """
    provision cmfive devlopment instance.

    The 'reuse_configs' provides a mechanism for the developer to
    reuse the same configs that were staged from a subsequant run 
    of this command. I.e. config.php is not blatted.
    """
    if reuse_config:
        reuse_config = True

    provision_dev(reuse_config)


@cli.command('provision-test')
@literal_cmd_options('test')
def provision_test_cmd(**kwargs):
    """
    provision cmfive test instance.    
    """            
    logger = logging.getLogger(__name__)    
    provision_test(kwargs)


@cli.command('create-production-image')
@click.argument('tag')
def create_production_image_cmd(tag):
    """create vanila production image"""
    create_production_image(tag)


@cli.command('test-config-resolver')
@click.argument('environment')
def test_config_resolver_cmd(environment):
    """test config resolver against environment"""
    print(test_config_resolver(environment))


@cli.command('prime-environment')
@click.argument('environment')
def prime_environment_cmd(environment):
    """setup environment without running docker-compose"""
    prime_environment(environment)


if __name__ == '__main__':
    cli()
