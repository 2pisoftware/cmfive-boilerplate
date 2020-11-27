import json
import yaml


def deserialize(data, ext):
    ext = ext.replace(".", "")

    if ext == "json":
        return json.loads(data)
    elif ext in ["yml", "yaml"]:
        return yaml.load(data, Loader=yaml.FullLoader)
    else:
        raise Exception(f"unable to deserialize *.{ext}")
