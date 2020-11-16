from botocore.exceptions import ClientError
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
    def __init__(self, profile):
        self.session=boto3.Session(profile_name=profile)


@register_provider('local')
class LocalProvider:
    def __init__(self, **kwargs):
        pass
