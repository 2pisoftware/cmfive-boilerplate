"""

"""
from .manager import resolve
import click
import os


@click.group()
def cli():
    pass


@cli.command('resolve')
@click.argument('dsl', type=click.Path(exists=True))
def resolve_cmd(dsl):
    """resolve configs"""
    # dsl path is relative to cwd (terminal)
    resolve(dsl)


if __name__ == '__main__':
    cli()
