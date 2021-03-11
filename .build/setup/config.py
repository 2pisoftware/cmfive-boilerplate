"""
"""
from resolver.app import get_configs, get_config_resolver_type
from dirs import Directories


class ConfigManager:
    # ----------
    # Client API
    # ----------
    def __init__(self, env, dirs):        
        self.dsl = dirs.env.joinpath("config.yml")
        self.config = get_configs(self.dsl)
        self.config["environment"] = env
    
    def get_config_resolver_type(self, key):
        return get_config_resolver_type(self.dsl, key)        