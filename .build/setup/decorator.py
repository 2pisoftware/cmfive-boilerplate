"""

"""
import functools
import click
from common import create_shared_context


def literal_cmd_options(env):
    def decorator_literal_cmd_options(func):        
        # modify func at compile time                           
        func = add_cmd_options(func, env)

        @functools.wraps(func)
        def wrapper(*args, **kwargs):
            return func(*args, **kwargs)
        return wrapper
    return decorator_literal_cmd_options


def add_cmd_options(func, env):
    manager = create_config_manager(env)
    for key, value in manager.config.items():        
        if manager.get_config_resolver_type(key) == "literal":            
            func = add_cmd_option(func, key, value)            
    
    return func


def add_cmd_option(func, key, value):    
    return click.option(f'--{key}', default=value, show_default=True)(func)


def create_config_manager(env):
    return create_shared_context(env).manager    