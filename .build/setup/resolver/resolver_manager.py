from .provider_manager import ProviderManager
from .resolvers import resolver_registry


class ResolverManager:
    #_instance = None

    def __init__(self, manifest_manager, provider_manager, dirs):                
        self.manifest_manager = manifest_manager
        self.provider_manager =provider_manager
        self.dirs = dirs
        self.resolvers = {}

    # @classmethod
    # def instance(cls, manifest_manager=None, provider_manager=None, dirs=None):
    #     if cls._instance is None:
    #         cls._instance = cls(manifest_manager, provider_manager, dirs)
    #     return cls._instance
       
    
    def is_primary_resolver_defined(self):
        for context in self.manifest_manager.resolvers:
            if context.get("primary", False):
                return True
        return False

    def get_primary_resolver(self):
        for context in self.manifest_manager.resolvers:
            if context.get("primary", False):
                return self.get(context["name"])
        else:
            raise Exception(f"primary resolver does not exist")

    def get(self, name):        
        if name in self.resolvers:
            return self.resolvers[name]

        for context in self.manifest_manager.resolvers:
            if name == context["name"]:
                self.resolvers[name] = self.init_resolver(context)
                break
        else:
            raise Exception(f"resolver {name} does not exist")

        return self.resolvers[name]

    def init_resolver(self, context):        
        assert context["type"] in resolver_registry, "logic error"
        clazz = resolver_registry[context["type"]]
        props = context.get("prop", {})
        
        return clazz(self.get_provider(context), self.dirs, props)

    def get_provider(self, context):
        provider = None
        if context.get("provider") is not None:
            provider = self.provider_manager.get(context["provider"])
        
        return provider