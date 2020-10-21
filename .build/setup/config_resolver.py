"""
"""
import json
import yaml
from dirs import Directories
from botocore.exceptions import ClientError

# -----------------
# Resolver Registry
# -----------------
registry = {}


def register_resolver(name):
    """add resolver class to registry"""
    def add_class(clazz):
        registry[name] = clazz
        return clazz
    return add_class


# ---------
# Resolvers
# ---------
class Resolver:
    def __init__(self, context, key):
        self.context = context        
        self.key = key


@register_resolver('local')
class LocalResolver(Resolver):
    _data = None  # cache

    def __init__(self, context, key, value):
        super().__init__(context, key)
        self.value = value

    def resolve(self):
        return self.value


@register_resolver('datastore')
class DatastoreResolver(Resolver):
    _data = None  # cache    

    def resolve(self):        
        configs = self.load()

        assert self.key in configs, f"config {self.key} not present"
        return configs[self.key]

    def load(self):
        clazz = type(self)
        if clazz._data is None:
            # load data from s3 bucket
            response = self.context.s3.get_object(Bucket=self.s3bucket, Key=self.s3key)
            
            # deserialize                        
            clazz._data = json.loads(response['Body'].read().decode('utf-8'))            

        return clazz._data

    @property
    def s3bucket(self):
        normalize = self.context.s3_folder.replace("s3://", "")
        return normalize.split("/", 1)[0]

    @property
    def s3key(self):
        full_path = f"{self.context.s3_folder}/{self.context.cmfive_client}_config.json"
        normalize = full_path.replace("s3://", "")
        return normalize.split("/", 1)[1]


@register_resolver('secret')
class SecretManagerResolver(Resolver):
    def __init__(self, context, key, index):
        super().__init__(context, key)
        self.index = index

    def resolve(self):
        try:
            secret = self.context.ss.get_secret_value(SecretId=self.key)
        except ClientError as e:
            raise Exception(f"Unable to retrieve secretId '{self.key}'") from e
        
        entries = json.loads(secret['SecretString'])
        return entries[self.index]
