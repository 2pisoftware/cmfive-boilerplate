"""
todo:
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
import logging
import click
from cmfive import CmfiveDevelopment


def setup_logger(level):
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


@cli.command('test')
def test():
    CmfiveDevelopment().setup()


if __name__ == '__main__':    
    print('asdad')    
    cli()
