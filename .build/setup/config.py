"""
"""
import os
from config_resolver import registry
from dirs import Directories
import yaml
import boto3


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
            self.config = self.load(env)
        else:
            assert False, "logic error"

    @classmethod
    def instance(cls):
        assert cls._instance is not None, "singleton not initialized"

        return cls._instance

    # ---------------
    # Private Methods
    # ---------------
    def load(self, env):
        # load data
        dirs = Directories.instance()
        with open(dirs.env.joinpath("config.yml"), "r") as fp:
            metadata = yaml.load(fp.read(), Loader=yaml.FullLoader)

        return self.resolve(metadata, env)

    def resolve(self, metadata, env):
        result = {"environment": env}

        context = ConfigContext()
        for key, content in metadata.items():
            config = Config(context, key, content["resolvers"])

            # resolve config and save value
            result[key] = config.value

        return result


class Config:
    def __init__(self, context, key, resolvers):
        self.context = context
        self.key = key
        self.resolvers = resolvers

    @property
    def value(self):
        result = self.key
        for resolver in self.resolvers:
            assert resolver in registry, f"resolver {resolver} unrecognised"

            # resolve key
            instance = registry[resolver](self.context, result)
            result = instance.resolve()

        return result


class ConfigContext:
    def __init__(self):
        # cmfive client - no spaces and url friendly
        self.cmfive_client = os.environ.get('CMFIVE_CLIENT', None)

        # s3 location to config files e.g. s3://<bucket>/<dir>
        self.s3_folder = os.environ.get('S3_FOLDER', None)

        # AWS configure profile
        profile_name = os.environ.get('PROFILE_NAME', None)

        # init boto clients
        if profile_name:
            boto = boto3.Session(profile_name=profile_name)
        else:
            boto = boto3

        self.s3 = boto.client('s3')
        self.ss = boto.client('secretsmanager')
        self.cf = boto.client('cloudformation')
