from dirs import Directories
from config import ConfigManager


def init_singletons(env):
    """initialize singletons"""
    Directories(env)
    ConfigManager(env)
