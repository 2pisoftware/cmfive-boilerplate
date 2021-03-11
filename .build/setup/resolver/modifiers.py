import json
from jinja2 import Template, StrictUndefined, UndefinedError

modifier_registry = {}


def register_modifier(name):
    """add resolver class to registry"""
    def add_class(clazz):
        modifier_registry[name] = clazz
        return clazz
    return add_class

class Modifier:
    def __init__(self, database):
        self.database = database


@register_modifier('json_serialize')
class JsonSerialize(Modifier):
    def modify(self, value, prop):
        return json.dumps(value)


@register_modifier('substitue')
class Substitue(Modifier):
    def modify(self, value, prop):                                
        serialized = json.dumps(value)
        try:
            template = Template(serialized, undefined=StrictUndefined)

            # normalize
            if isinstance(prop["key"], str):
                prop["key"] = [prop["key"]]
            
            result = template.render({
                key:  self.database.get(key) for key in prop["key"]}
            )
        except UndefinedError as exc:
            raise Exception(f"template placeholder token is missing - {prop['key']}") from exc
        
        return json.loads(result)


@register_modifier('merge')
class Merge(Modifier):
    def modify(self, value, prop):                
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
