import util
from pathlib import Path
import logging


logger = logging.getLogger(__name__)


def setup_php_xdebug_config(context):
    logger.info("PHP xdebug config added to vscode")    

    # logic
    if is_xdebug_enabled(context):
        util.write_to_file(
            Path(context.dirs.vscode, "launch.json"), 
            util.dedent_multiline_string(r"""
                {
                    "version": "0.2.0",            
                    "configurations": [        
                        {            
                            "name": "Docker XDebug",
                            "type": "php",
                            "request": "launch",
                            "port": 9000,
                            "pathMappings": {
                                "/var/www/html": "${workspaceFolder}",
                            },
                            "log": true            
                        }
                    ]
                }
            """, 
            remove_firstline=True)
        )


def is_xdebug_enabled(context):
    return context.manager.config['add_php_xdebug_vscode_config']