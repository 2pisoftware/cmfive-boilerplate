import os
from .provider_manager import ProviderManager
from .resolvers import resolver_registry


field_registry = {}


def register_field(name):
    """add resolver class to registry"""
    def add_class(clazz):
        field_registry[name] = clazz
        return clazz
    return add_class


class Field:
    def __init__(self, key, props):
        self.key = key
        self.props = props

    @staticmethod
    def create(key, context):    
        # normalize
        if isinstance(context, str):
            context = { 
                "lookup": "literal",
                "prop": {                    
                    "value": context
                }                
            }

        field_type = context["lookup"]
        return field_registry[field_type](key, context["prop"])


@register_field("literal")
class LiteralField(Field):
    def __init__(self, key, props):
        super().__init__(key, props)

    @property
    def value(self):
        return self.props["value"]        


@register_field("environment")
class EnvironmentField(Field):
    def __init__(self, key, props):
        super().__init__(key, props)

    @property
    def value(self):
        return os.environ[self.props["variable"]]        


@register_field("secretsmanager")
class SecretsManagerField(Field):
    def __init__(self, key, props):
        super().__init__(key, props)

    @property
    def value(self):        
        return self.resolver.get(
            self.props["value"], 
            self.props.get("index", None)
        )

    @property
    def provider(self):
        provider_manager = ProviderManager.instance()
        return provider_manager.get(self.props["provider"])

    @property
    def resolver(self):
        clazz = resolver_registry["secretsmanager"]
        return clazz(self.provider, None, None)
