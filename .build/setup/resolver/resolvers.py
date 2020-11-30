# todo:
# - mark resolvers as allowed to be primary/non-primary
# - compare props against jsonschema
import json
import botocore


resolver_registry = {}


def register_resolver(name):
    """add resolver class to registry"""
    def add_class(clazz):
        resolver_registry[name] = clazz
        return clazz
    return add_class


@register_resolver('literal')
class LiteralResolver:
    def __init__(self, provider, dirs, props):
        pass    

    def get(self, value):        
        return value    

    # ---------------
    # Utility Methods
    # ---------------    
    def create_adapter(self, key, props):
        return LiteralResolverAdapter(self, key, props)

    @staticmethod
    def allowed_providers():
        return tuple()
    
    @staticmethod
    def schema():        
        return {}


class LiteralResolverAdapter:
    def __init__(self, resolver, key, props):        
        self.resolver = resolver
        self.key = key
        self.props = props        

    def put(self, value):
        pass

    def get(self):        
        return self.resolver.get(self.props["value"])

    def get_all(self):
        raise NotImplemented()

    def is_present(self):
        return True


@register_resolver('secretsmanager')
class SecretsManagerResolver:
    def __init__(self, provider, dirs, props):           
        self.sm = provider.session.client("secretsmanager")        

    def put(self, key, index, value):
        self.set_secret(key, index, value)

    def get(self, key, index):        
        secret = self.get_secret(key)
        if index is None:
            return secret
        return secret[index]

    def get_all(self):
        raise NotImplemented()

    def is_present(self, key, index):
        # secret doesn't exist
        try:
            secret = self.get_secret(key)
        except botocore.exceptions.ClientError as error:
            if error.response['Error']['Code'] == "ResourceNotFoundException":
                return False
            raise error        

        if index is None:
            return True

        return index in secret
                
    # --------------
    # Helper Methods
    # --------------   
    def get_secret(self, key):
        secret = self.sm.get_secret_value(SecretId=key)
        try:
            return json.loads(secret['SecretString'])
        except json.decoder.JSONDecodeError:
            return secret['SecretString']

    def set_secret(self, key, index, value):    
        secret = self.get_secret(key)             

        # plaintext
        if index is None:             
            content = value            
        # key/value pairs
        else:
            secret[index] = value
            content = json.dumps(secret)

        self.sm.put_secret_value(SecretId=key, SecretString=content)

    # ---------------
    # Utility Methods
    # ---------------    
    def create_adapter(self, key, props):
        return SecretsManagerResolverAdapter(self, key, props)

    @staticmethod
    def allowed_providers():
        return ("aws",)
    
    @staticmethod
    def schema():        
        return {}


class SecretsManagerResolverAdapter:
    def __init__(self, resolver, key, props):        
        self.resolver = resolver
        self.key = key
        self.props = props        

    def put(self, value):
        self.resolver.put(self.key, self.props["index"], value)

    def get(self):        
        return self.resolver.get(self.key, self.index)

    def is_present(self):
        return self.resolver.is_present(self.key, self.index)

    @property
    def index(self):
        return self.props.get("index")


@register_resolver('s3')
class S3Resolver:
    def __init__(self, provider, dirs, props):           
        self.s3 = provider.session.client("s3")     
        self.props = props
        self.content = self.load()

    def put(self, key, value):        
        self.content[key] = value
        self.save()

    def get(self, key):
        return self.content.get(key)

    def get_all(self):
        return self.content

    def is_present(self, key):
        return key in self.content    

    # --------------
    # Helper Methods
    # --------------
    @property
    def bucket(self):
        from resolver.fields import Field
        return Field.create("bucket", self.props["source"]["path"]).value

    @property
    def key(self):
        from resolver.fields import Field
        return Field.create("key", self.props["source"]["file"]).value
    
    def load(self):
        response = self.s3.get_object(
            Bucket=self.bucket.replace("s3://", ""),
            Key=self.key
        )
        return json.loads(response['Body'].read().decode('utf-8'))

    def save(self):
        self.s3.put_object(
            Body=json.dumps(self.content).encode(),
            Bucket=self.bucket.replace("s3://", ""),
            Key=self.key
        )
    # ---------------
    # Utility Methods
    # ---------------    
    def create_adapter(self, key, props):
        return S3ResolverAdapter(self, key, props)

    @staticmethod
    def allowed_providers():
        return ("aws",)
    
    @staticmethod
    def schema():        
        return {}


class S3ResolverAdapter:
    def __init__(self, resolver, key, props):        
        self.resolver = resolver
        self.key = key
        self.props = props   

    def get(self):
        return self.resolver.get(self.key) or self.props.get("default", None)

    def put(self, value):
        self.resolver.put(self.key, value)

    def is_present(self):
        return self.resolver.is_present(self.key) or "default" in self.props


@register_resolver('filesystem')
class FilesystemResolver:
    def __init__(self, provider, dirs, props):
        self.dirs = dirs
        self.props = props
        self.content = self.load()

    def put(self, key, value):        
        self.content[key] = value
        self.save()

    def get(self, key):
        return self.content.get(key)

    def get_all(self):
        return self.content

    def is_present(self, key):
        return key in self.content

    # --------------
    # Helper Methods
    # --------------    
    def load(self):
        with open(self.filepath, "r") as fp:
            return json.load(fp)        

    def save(self):
        with open(self.filepath, "w") as fp:
            fp.write(json.dumps(self.content))

    @property
    def filepath(self):
        from .fields import Field
        value = Field.create("key", self.props["filepath"]).value
   
        # file location is relative to schema file
        return self.dirs.lookup.joinpath(value)

    # ---------------
    # Utility Methods
    # ---------------    
    def create_adapter(self, key, props):
        return FilesystemResolverAdapter(self, key, props)

    @staticmethod
    def allowed_providers():
        return tuple()
    
    @staticmethod
    def schema():        
        return {}


class FilesystemResolverAdapter:
    def __init__(self, resolver, key, props):        
        self.resolver = resolver
        self.key = key
        self.props = props   

    def get(self):
        return self.resolver.get(self.key) or self.props.get("default", None)

    def put(self, value):
        self.resolver.put(self.key, value)

    def is_present(self):        
        return self.resolver.is_present(self.key) or "default" in self.props
