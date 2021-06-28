from collections import namedtuple
from dirs import Directories
from config import ConfigManager


SharedContext = namedtuple('SharedContext', ['dirs', 'manager'])

def create_shared_context(env):
    dirs = Directories(env)
    return SharedContext(dirs, ConfigManager(env, dirs))