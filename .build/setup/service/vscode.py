from common import Directories, ConfigManager
import util
from pathlib import Path
import logging


logger = logging.getLogger(__name__)


def setup_php_xdebug_config():
        logger.info("PHP xdebug config added to vscode")       

        # variable declarations 
        dirs = Directories.instance()
        config = ConfigManager.instance().config

        # logic
        if config['add_php_xdebug_vscode_config']:
            util.write_to_file(
                Path(dirs.vscode, "launch.json"), 
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