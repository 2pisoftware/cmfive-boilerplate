from .factory import init_database, init_action_manager
from .dirs import Dirs
import logging


def setup_logger(level):    
    logging.basicConfig(
        format="time: %(asctime)s, module: %(name)s, line: %(lineno)s, level: %(levelname)s, Msg: %(message)s",
        datefmt="%Y-%m-%d %H:%M:%S",
        level=getattr(logging, level.upper())
    )


def get_config(dsl, key):
    logging.info(f"Get value for key '{key}'")
    database = init_database(Dirs(dsl))
    return database.get(key)


def get_configs(dsl):    
    logging.info(f"Get all key/value pairs")
    database = init_database(Dirs(dsl))
    return database.get_all()


def put_config(dsl, key, value):
    logging.info(f"Store key/value pair where key is '{key}'")
    database = init_database(Dirs(dsl))
    database.put(key, value)


def put_configs(dsl, values):
    logging.info(f"Store key/value pairs")
    database = init_database(Dirs(dsl))
    database.put_all(values)


def run_actions(dsl):
    action_manager = init_action_manager(Dirs(dsl))
    action_manager.execute()
