import os
import json
from pathlib import Path
from .dirs import Dirs
from .util import deserialize
from botocore.exceptions import ClientError


resolver_registry = {}


def register_resolver(name):
    """add resolver class to registry"""
    def add_class(clazz):
        resolver_registry[name] = clazz
        return clazz
    return add_class


@register_resolver('s3')
class S3Resolver:
    def __init__(self, provider, source, format):
        self.client = provider.session.client("s3")
        self.bucket = os.environ[source["path"]["environment"]["name"]]
        self.key = os.environ[source["file"]["environment"]["name"]]        
        self.content = self.load()            

    def resolve(self, config, **kwargs):
        if "default" in kwargs:
            return kwargs["default"]
        return self.content[config]

    def update(self, config, value, **kwargs):
        self.content[config] = value

    def flush(self):
        self.save()

    @staticmethod
    def allowed_providers():
        return ("aws",)
            
    def load(self):
        response = self.client.get_object(
            Bucket=self.bucket.replace("s3://", ""),
            Key=self.key
        )
        return json.loads(response['Body'].read().decode('utf-8'))

    def save(self):
        self.client.put_object(
            Body=json.dumps(self.content).encode(),
            Bucket=self.bucket.replace("s3://", ""),
            Key=self.key
        )

@register_resolver('secretsmanager')
class SecretsManagerMResolver:
    def __init__(self, provider):
        self.sm = provider.session.client("secretsmanager")
        self.store = []

    @staticmethod
    def allowed_providers():
        return ("aws",)

    def resolve(self, config, **kwargs):
        secret = self.get_secret(config)
        return secret[kwargs["index"]]

    def update(self, config, value, **kwargs):
        self.store.append((config, kwargs["index"], value)) 

    def flush(self):
        for item in self.store:
            self.set_secret(*item)            

    def get_secret(self, key):
        try:
            secret = self.sm.get_secret_value(SecretId=key)
        except ClientError as e:
            raise Exception(f"Unable to retrieve secretId '{key}'") from e

        return json.loads(secret['SecretString'])

    def set_secret(self, key, index, value):        
        secret = self.get_secret(key)
        secret[index] = value
        self.sm.put_secret_value(SecretId=key, SecretString=json.dumps(secret))


@register_resolver('filesystem')
class FileSystemResolver:
    def __init__(self, provider, format, filepath):
        self.content = self.load(format, filepath)

    @staticmethod
    def allowed_providers():
        return ("local",)

    @staticmethod
    def load(format, filepath):
        dirs = Dirs.instance()
        with open(dirs.lookup.joinpath(filepath), "r") as fp:
            data = fp.read()

        return deserialize(data, format)

    def resolve(self, config, **kwargs):
        # config present
        if config in self.content:
            return self.content[config]

        # default value
        if "default" in kwargs:
            return kwargs["default"]

        raise Exception(f"{config} is not present and no default value set")

    def update(self, config, value, **kwargs):
        pass

    def flush(self):
        pass

@register_resolver('local')
class LocalResolver:
    def __init__(self, provider):
        pass

    @staticmethod
    def allowed_providers():
        return ("local",)

    def resolve(self, config, **kwargs):
        # default value
        if "value" in kwargs:
            return kwargs["value"]

        raise Exception(f"No value set for config '{config}'")

    def update(self, config, value, **kwargs):
        pass

    def flush(self):
        pass