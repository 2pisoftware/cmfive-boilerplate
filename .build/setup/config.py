"""
"""
import os
from jinja2 import Template, StrictUndefined
from config_resolver import registry
from dirs import Directories
import yaml
import json
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

        # resolve config
        context = ConfigContext()
        for key, content in metadata.items():            
            config = Config(context, key, content)            
            result[key] = config.value

        # apply modifier
        for key, content in metadata.items():            
            config = Config(context, key, content)            
            result[key] = config.apply_modifiers(result, result[key])

        return result


class Config:
    def __init__(self, context, key, content):
        self.context = context
        self.key = key
        self.content = content

    @property
    def value(self):
        value = self.key
        for entry in self.content["resolvers"]:
            # parse resolver and data
            resolver, args = next(iter(entry.items()))
            assert resolver in registry, f"resolver {resolver} unrecognised"

            # load aws remote configs
            if resolver != "local":
                self.context.load_remote()

            # resolve key
            instance = registry[resolver](context=self.context, key=value, **args)
            value = instance.resolve()
        
        return value        

    def apply_modifiers(self, resolved_values, value):
        for modifier in self.content.get('modifiers', []):                        
            if "json_serialize" in modifier:
                value = json.dumps(value)   
            if "merge" in modifier:
                self.merge(modifier["merge"]["value"], value)
            if "substitue" in modifier:
                value = self.substitue(value, resolved_values, modifier["substitue"]["key"])                

        return value
    
    def merge(self, source, target):
        # basic merge strategy - improve
        if not isinstance(source, dict):
            return
        
        for key, value in source.items():
            if key in target:
                if isinstance(value, dict):
                    self.merge(source[key], target[key])
                else:
                    target[key] = value
            else:
                target[key] = source[key]
    
    def substitue(self, value, values, key):        
        serialized = json.dumps(value)                
        try:            
            template = Template(serialized, undefined=StrictUndefined)
            result = template.render({key: values[key]})
        except UndefinedError as exc:
            raise Exception(f"template placeholder token is missing - {fpath}") from exc

        return json.loads(result)        

class ConfigContext:
    def __init__(self):
        self.is_remote = False

    def load_remote(self):
        if self.is_remote:
            return

        # cmfive client - no spaces and url friendly
        self.cmfive_client = os.environ.get('CMFIVE_CLIENT', None)

        # s3 location to config files e.g. s3://<bucket>/<dir>
        self.s3_folder = os.environ.get('CONFIG_S3_FOLDER', None)

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
        self.is_remote = True