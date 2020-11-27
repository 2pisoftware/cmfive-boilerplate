"""
"""
from resolver.manager import resolve
from dirs import Directories


class ConfigManager:
    # singleton
    _instance = None

    # ----------
    # Client API
    # ----------
    def __init__(self, env):
        clazz = type(self)
        if clazz._instance is None:
            clazz._instance = self

            # init
            dirs = Directories.instance()
            self.config = resolve(dirs.env.joinpath("config.yml"))                        
            self.config["environment"] = env
        else:
            assert False, "logic error"    

    @classmethod
    def instance(cls):
        assert cls._instance is not None, "singleton not initialized"

        return cls._instance