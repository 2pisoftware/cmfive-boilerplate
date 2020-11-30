"""
Command Line Interface 
"""
import resolver.app as app
import click
import os


@click.group()
@click.option('--verbose', default='info', help='log level')
def cli(verbose):
    app.setup_logger(verbose)


@cli.command('get-config')
@click.argument('dsl', type=click.Path(exists=True))
@click.argument('key')
def cmd_get_config(dsl, key):
    """Get a single value given a key"""
    print(app.get_config(dsl, key))


@cli.command('get-configs')
@click.argument('dsl', type=click.Path(exists=True))
def cmd_get_configs(dsl):
    """Get all key/value pairs"""
    print(app.get_configs(dsl))


@cli.command('get-config-actions')
@click.argument('dsl', type=click.Path(exists=True))
def cmd_get_configs(dsl):
    """Get all key/value action pairs"""    
    print(app.get_config(dsl, "custom.actions"))


@cli.command('put-config')
@click.argument('dsl', type=click.Path(exists=True))
@click.argument('key')
@click.argument('value')
def cmd_put_config(dsl, key, value): 
    """Store a single key/value pair"""    
    app.put_config(dsl, key, value)


@cli.command('run-actions')
@click.argument('dsl', type=click.Path(exists=True))
def cmd_run_actions(dsl):    
    """Run config defined actions"""
    app.run_actions(dsl)


def main():
    cli()


if __name__ == '__main__':
    exit(main())
