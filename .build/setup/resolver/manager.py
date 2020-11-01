import json
from collections import namedtuple
from .resolvers import resolver_registry
from .providers import provider_registry
from .manifest import Manifest
from .dirs import Dirs
from jinja2 import Template, StrictUndefined, UndefinedError


ResolverPair = namedtuple('ResolverPair', ['type', 'instance'])


class ConfigResolver:
    def __init__(self, manifest):
        self.manifest = manifest
        self.providers = {}
        self.resolvers = {}
        self.init_providers()
        self.init_resolvers()

    def resolve(self, config, value):
        result = config
        for context in self.manifest.data.resolvers(config):
            resolver = self.resolvers[context["resolver"]]
            result = resolver.resolve(result, **context.get("prop", {}))

        return self.manifest.data.set_value(config, result)

    def update(self, config, value):
        cnt, prv = config, config
        resolver = None             
        for context in self.manifest.data.resolvers(config):            
            resolver = self.resolvers[context["resolver"]]
            prv = cnt
            cnt = resolver.resolve(prv, **context.get("prop", {}))        

        # no resolver or config resolved to same value
        if resolver is None or cnt == value:
            return

        # update config value        
        resolver.update(prv, value, **context.get("prop", {}))

    def flush(self):
        for resolver in self.resolvers.values():
            resolver.flush()

    # --------------
    # Helper Methods
    # --------------
    def init_providers(self):
        for provider in self.manifest.meta.providers():
            self.providers[provider["name"]] = self.init_provider(provider)

    def init_provider(self, provider):
        typez = provider["type"]
        clazz = provider_registry[typez]
        props = provider.get("prop", {})

        return ResolverPair(typez, clazz(**props))

    def init_resolvers(self):
        for resolver in self.manifest.meta.resolvers():
            self.resolvers[resolver["name"]] = self.init_resolver(resolver)

    def init_resolver(self, resolver):
        clazz = resolver_registry[resolver["type"]]
        props = resolver.get("prop", {})
        provider = self.providers[resolver["provider"]]

        # provider not supported
        if provider.type not in clazz.allowed_providers():
            msg = "Resolver {} is incompatible with provider {}".format(
                resolver['type'],
                provider.type
            )
            raise Exception(msg)

        return clazz(provider.instance, **props)

    def get_resolver(self, name):
        return self.resolvers[name]


class ConfigModifier:
    def __init__(self, manifest):
        self.manifest = manifest

        self.modifiers = {
            "merge": self.merge,
            "substitue": self.substitue,
            "json_serialize": self.json_serialize,
        }

    def resolve(self, config, value):
        result = value
        for context in self.manifest.data.modifiers(config):
            name = context["modifier"]

            #  validate
            if name not in self.modifiers:
                raise Exception(f"modifier {context['modifier']} not recognised")

            # modify value
            result = self.modifiers[name](
                config,
                result,
                context.get("prop", {})
            )

        return result

    # --------------
    # Helper Methpds
    # --------------
    def json_serialize(self, config, value, prop):
        return json.dumps(value)

    def substitue(self, config, value, prop):
        serialized = json.dumps(value)
        try:
            template = Template(serialized, undefined=StrictUndefined)
            result = template.render({
                prop["key"]: self.manifest.data.get_value(prop["key"])
            })
        except UndefinedError as exc:
            raise Exception(f"template placeholder token is missing - {prop['key']}") from exc

        return json.loads(result)

    def merge(self, config, value, prop):
        self.recurse_merge(prop["value"], value)
        return value

    def recurse_merge(self, source, target):
        # basic merge strategy - improve
        if not isinstance(source, dict):
            return

        for key, value in source.items():
            if key in target:
                if isinstance(value, dict):
                    self.merge(source[key], target[key])
                else:
                    target[key] = value
            else:
                target[key] = source[key]


def resolve(dsl):
    # setup
    Dirs.instance(dsl)
    manifest = Manifest()
    actions = (ConfigResolver(manifest), ConfigModifier(manifest))

    # stage result
    result = {}
    for action in actions:
        for config in manifest.data.configs():
            result[config] = action.resolve(config, result.get(config))    

    return result


def update(dsl, values):
    # setup
    Dirs.instance(dsl)
    manifest = Manifest()
    resolver = ConfigResolver(manifest)

    # update exisiting configs
    for config in manifest.data.configs():
        if config not in values:
            continue
        
        resolver.update(config, values[config])

    resolver.flush()
