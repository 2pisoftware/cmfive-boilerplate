import boto3

provider_registry = {}


def register_provider(name):
    """add resolver class to registry"""
    def add_class(clazz):
        provider_registry[name] = clazz
        return clazz
    return add_class


@register_provider('aws')
class AWSProvider:
    def __init__(self, props):        
        self.session=boto3.Session(profile_name=props["profile"])