from jsonschema import validate
from .resolver_manager import ResolverManager
from .modifiers import modifier_registry
from .database import RequestUnhandled


class SchemaDatabaseProxy:
    """defined schema configs"""
    def __init__(self, manifest, resolver_manager):
        self.manifest = manifest    
        self.resolver_manager = resolver_manager        
        self.database = None

    def get_resolver_type(self, key):        
        _, resolver_adapter  = self.resolve(key)
        return resolver_adapter.resolver.name

    def get(self, key):               
        result, _  = self.resolve(key)   
        result = self.modify(key, result)
        return result

    def get_all(self, result):        
        for key in self.manifest.schemas:            
            if key in result:
                continue
            result[key] = self.get(key)         

    def put(self, key, value):        
        _, adapter  = self.resolve(key)
        adapter.put(value)

    # --------------
    # Helper Methods
    # --------------
    def resolve(self, key):
        # allow another proxy to handle request
        if not self.manifest.is_schema_defined(key):
            raise RequestUnhandled()

        result = key
        schema = self.manifest.get_schema(key)
        for context in schema["resolvers"]:
            # <comment>            
            adapter = self.create_adapter(result, context)
            if not adapter.is_present():
                raise Exception("<exception stub>")

            result = adapter.get()
        
        return result, adapter

    def modify(self, key, value):
        schema = self.manifest.get_schema(key)
        for context in schema.get("modifiers", []):
            modifier = self.create_modifier(context)
            value = modifier.modify(value, context.get("prop"))         

        return value

    def create_adapter(self, key, context):
        resolver = self.resolver_manager.get(context["resolver"])
        return resolver.create_adapter(
            key, 
            context.get("prop", {})
        )

    def create_modifier(self, context):
        # validate
        if context["modifier"] not in modifier_registry:
            raise Exception("<exception stub>")
        elif context["modifier"] not in modifier_registry:
            raise Exception(f"modifier '{context['modifier']}' not supported")
                
        # instantiate modifier
        clazz = modifier_registry[context['modifier']]
        return clazz(self.database)


class IntrinsicDatabaseProxy:
    """intrinsic configs"""
    PREFIX = 'custom.'
    
    def __init__(self, manifest, resolver, registries):
        self.manifest = manifest
        self.resolver = resolver
        self.reserved = registries
        self.database = None

    def get_resolver_type(self, key):
        # allow another proxy to handle request        
        raise RequestUnhandled()

    def get(self, key):
        # allow another proxy to handle request
        if not self.is_reserved(key):
            raise RequestUnhandled()

        # get instrinsic value
        value = []
        if self.resolver.is_present(key):
            value = self.resolver.get(key)

        return value

    def get_all(self, result):        
        result.update({
            self.canonical_key(key): self.get(self.canonical_key(key)) for
            key in self.reserved if key not in result
        })

    def put(self, key, value):            
        # allow another proxy to handle request
        if not self.is_reserved(key):
            raise RequestUnhandled()                

        # normalize
        if not isinstance(value, list):            
            value = [value]  
        
        registry = self.get_registry(key)
        for entry in value:            
            # validate user input
            if "type" not in entry:
                raise Exception("missing 'type' field")
            if entry["type"] not in registry:
                raise Exception("<exception stub>")

            # validate json schema        
            clazz = registry[entry["type"]]            
            validate(instance=entry, schema=clazz.schema())
          
        # store data
        adapter = self.resolver.create_adapter(key, {})                
        adapter.put(value)

    # --------------
    # Helper Methods
    # --------------
    def is_reserved(self, key):        
        if key.startswith(self.PREFIX):
            return key.split(".")[1] in self.reserved
        return False
                    
    def canonical_key(self, key):
        return f"{self.PREFIX}{key}"

    def get_registry(self, key):
        return self.reserved[key.split(".")[1]]


class SchemalessDatabaseProxy:
    """non-defined schema configs"""
    def __init__(self, manifest, resolver):        
        self.manifest = manifest
        self.resolver = resolver        
        self.database = None

    def get_resolver_type(self, key):
        # allow another proxy to handle request        
        raise RequestUnhandled()

    def get(self, key):
        # allow another proxy to handle request
        if self.manifest.is_schema_defined(key):
            raise RequestUnhandled()

        adapter = self.resolver.create_adapter(key, {})
        if not adapter.is_present():
            raise Exception(f"Schemaless get query, key '{key}' is not found")
        
        return adapter.get()

    def get_all(self, result):             
        for key, value in self.resolver.get_all().items():
            if key in result:
                continue

            if not self.manifest.is_schema_defined(key):
                result[key] = value

        return result

    def put(self, key, value):
        adapter = self.resolver.create_adapter(key, {})
        adapter.put(value)
