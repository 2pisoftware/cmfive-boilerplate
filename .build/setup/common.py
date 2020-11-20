from config import Config
from dirs import Directories


def init_singletons(env, is_config_local):
    """initialize singletons"""
    Directories(env)
    Config(env, is_config_local)
