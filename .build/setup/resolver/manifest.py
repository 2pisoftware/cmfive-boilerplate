from pathlib import Path
from .dirs import Dirs
import yaml


class Meta:
    def __init__(self, manifest):
        self.manifest = manifest

    def providers(self):
        return self.manifest.content["manifest"]["providers"]

    def resolvers(self):
        return self.manifest.content["manifest"]["resolvers"]


class Data:
    def __init__(self, manifest):
        self.manifest = manifest
        self.value = {}

    def configs(self):
        # optional
        if self.data is None:
            return

        for context in self.data:
            yield context["name"]

    def resolver_count(self, config):
        context = self.context(config)
        return len(list(self.resolvers(config)))        

    def resolvers(self, config):
        context = self.context(config)
        for resolver in context.get("resolvers", []):
            yield resolver

    def modifiers(self, config):
        context = self.context(config)
        for modifier in context.get("modifiers", []):
            yield modifier

    def set_value(self, config, value):
        self.value[config] = value
        return value

    def get_value(self, config):
        return self.value[config]

    # --------------
    # Helper Methods
    # --------------
    def context(self, config):
        # add to cache
        context = next((_ for _ in self.data if _["name"] == config), None)
        assert context is not None, "logic error"
        return context

    @property
    def data(self):
        return self.manifest.content.get("data", None)


class Manifest:
    def __init__(self):
        self._content = None
        self.dirs = Dirs.instance()
        self.meta = Meta(self)
        self.data = Data(self)

    @property
    def content(self):
        if self._content is None:
            with open(self.dirs.dsl, "r") as fp:
                self._content = yaml.load(fp.read(), Loader=yaml.FullLoader)
        return self._content
