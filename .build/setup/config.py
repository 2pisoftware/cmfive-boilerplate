"""
"""
from dirs import Directories
import os
import yaml
import boto3


def bucket(s3path):
    normalize = s3path.replace("s3://", "")
    return normalize.split("/", 1)[0]


def key(s3path):
    normalize = s3path.replace("s3://", "")
    return normalize.split("/", 1)[1]


def remote_config(env):
    # load environment variables
    profile_name = os.environ.get('PROFILE_NAME', None)
    config_path = os.environ.get('S3_CONFIG_PATH')
    client = os.environ.get('CLIENT_CONFIG')

    # pre-condition
    assert config_path is not None, "environment variable 'S3_CONFIG_PATH' is mandatory"
    assert client is not None, "environment variable 'CLIENT_CONFIG' is mandatory"

    # session
    if profile_name:
        session = boto3.Session(profile_name=profile_name)
        s3 = session.client('s3')
    # defaults
    else:
        s3 = boto3.client('s3')

    # load content
    response = s3.get_object(Bucket=bucket(config_path), Key=key(config_path))
    result = yaml.load(
        response['Body'].read().decode('utf-8'),
        Loader=yaml.FullLoader
    )

    # pre-condition
    assert client in result, "client not in config"

    return result[client]


def local_config(env):
    dirs = Directories.instance()

    with open(dirs.env.joinpath("config.yml"), "r") as fp:
        return yaml.load(fp.read(), Loader=yaml.FullLoader)


def load(env, is_local):
    # init loader
    loader = local_config if is_local else remote_config

    config = loader(env)
    config["environment"] = env

    return config


class Config:
    # singleton
    _instance = None

    def __init__(self, env, is_local):
        if type(self)._instance is None:
            type(self)._instance = self

            # init
            self.config = load(env, is_local)

    @classmethod
    def instance(cls):
        assert cls._instance is not None, "singleton is not instantiated"

        return cls._instance
