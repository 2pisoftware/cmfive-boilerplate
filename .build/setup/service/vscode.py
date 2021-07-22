import util
from pathlib import Path
import logging


logger = logging.getLogger(__name__)


def setup_php_xdebug_config(context):
    logger.info("Add PHP xdebug config to vscode step")

    if is_xdebug_enabled(context):        
        util.write_to_file(
            launch_json_file_path(context), 
            util.render_template_from_string(
                # template string
                util.dedent_multiline_string(r"""
                    {
                        "version": "0.2.0",            
                        "configurations": [        
                            {            
                                "name": "Docker XDebug",
                                "type": "php",
                                "request": "launch",
                                "port": {{ port }},
                                "pathMappings": {
                                    "/var/www/html": "${workspaceFolder}",
                                },
                                "log": true            
                            }
                        ]
                    }
                """,
                remove_firstline=True),
                # placeholder values
                { 
                    "port": xdebug_port(context)
                }
            )            
        )


def launch_json_file_path(context):
    """
    path to launch.json in visual studio code
    """
    return Path(context.dirs.vscode, "launch.json")


def is_xdebug_enabled(context):
    """
    config is optional, default to False if not specified
    """
    return context.manager.config.get('add_php_xdebug_vscode_config', True)


def xdebug_port(context):
    """
    config is optional, default value is 9003 if not specified
    xdebug 3.0.2 uses port 9003, xdebug 2.x is port 9000
    """    
    return context.manager.config.get('xdebug_vscode_port', 9003)
