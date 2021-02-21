"""
"""
from resolver.app import get_configs
from dirs import Directories


class ConfigManager:
    # ----------
    # Client API
    # ----------
    def __init__(self, env, dirs):           
        self.config = get_configs(dirs.env.joinpath("config.yml"))                        
        self.config["environment"] = env