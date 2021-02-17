from base64 import b64decode 
import json
import yaml
import requests
import resolver.util
from .provider_manager import ProviderManager
from .fields import Field


class ManifestManager:    
    def __init__(self, dirs):
        print(dirs.dsl)
        self.manifests = [
            Manifest(FilesystemManifestLoader({"filepath": dirs.dsl}))
        ]
        self._schemas = None

    def load(self):
        self.manifests[0].load(self.manifests)    

    def is_schema_defined(self, key):        
        return key in self.schemas       

    def get_schema(self, key):
        return self.schemas[key]        

    @property
    def schemas(self):
        if self._schemas is not None:
            return self._schemas

        # populate schemas
        self._schemas = {}
        for manifest in self.manifests:
            for schema in manifest.schemas:
                self._schemas[schema["name"]] = schema
        
        return self._schemas

    @property
    def providers(self):
        for manifest in self.manifests:
            yield from manifest.providers            

    @property
    def resolvers(self):
        for manifest in self.manifests:
            yield from manifest.resolvers

    @staticmethod
    def create_manifest(name, props):
        assert name in manifest_loader_registry, "logic error"
        clazz = manifest_loader_registry[name]

        return Manifest(clazz(props))
    

class Manifest:
    def __init__(self, loader):        
        self.content = loader.load()

    def load(self, registry):                
        for context in self.content.get("import", []):
            manifest = ManifestManager.create_manifest(
                context["type"],
                context["prop"],
            )
            registry.append(manifest)
            manifest.load(registry)

    @property
    def schemas(self):
        if "data" not in self.content:
            return

        for schema in self.content["data"]:
            yield schema

    @property
    def providers(self):
        if "manifest" not in self.content:
            return
                
        for provider in self.content["manifest"].get("providers", []):
            yield provider

    @property
    def resolvers(self):
        if "manifest" not in self.content:
            return
                
        for resolver in self.content["manifest"].get("resolvers", []):
            yield resolver

# ----------------
# Manifest Loaders
# ----------------
manifest_loader_registry = {}


def register_manifest_loader(name):
    """add resolver class to registry"""
    def add_class(clazz):
        manifest_loader_registry[name] = clazz
        return clazz
    return add_class


@register_manifest_loader("filesystem")
class FilesystemManifestLoader:
    def __init__(self, props):        
        self.filepath = props["filepath"]
    
    def load(self):
        with open(self.filepath, "r") as fp:
            return yaml.load(fp.read(), Loader=yaml.FullLoader)


@register_manifest_loader("github_token")
class GithubTokenManifestLoader:
    def __init__(self, props):
        self.props = props

    def load(self):
        # request file
        response = requests.get(**self.stage_request())        

        # decode response
        document = response.json()               
        content = b64decode(document["content"]).decode('utf-8')       
        
        return yaml.load(content, Loader=yaml.FullLoader) or {}

    def stage_request(self):
        result = {
            url: f"https://api.github.com/repos/{self.owner}/{self.repository}/contents/{self.path}?ref={self.ref}" 
        }
        
        # optional - token can be None for public repositories
        if self.token:
            result["headers"] = {'Authorization': 'token ' + self.token}
        
        return result

    @property
    def token(self):        
        return self.resolve("token")

    @property
    def repository(self):
        return self.resolve("repository")

    @property
    def owner(self):
        return self.resolve("owner")

    @property
    def path(self):
        return self.resolve("path")

    @property
    def ref(self):
        return self.resolve("ref")

    def resolve(self, key):       
        return Field.create(key, self.props[key]).value
