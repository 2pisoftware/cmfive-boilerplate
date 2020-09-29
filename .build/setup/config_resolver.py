"""
"""
import json
import yaml
from dirs import Directories
from botocore.exceptions import ClientError

# -----------------
# Resolver Registry
# -----------------
registry = {}


def register_resolver(name):
    """add resolver class to registry"""
    def add_class(clazz):
        registry[name] = clazz
        return clazz
    return add_class


# ---------
# Resolvers
# ---------
class Resolver:
    def __init__(self, context, config, key):
        self.context = context
        self.config = config
        self.key = key


@register_resolver('local')
class LocalResolver(Resolver):
    _data = None  # cache

    def resolve(self):
        return self.load()[self.key]["value"]

    def load(self):
        clazz = type(self)
        if clazz._data is None:
            dirs = Directories.instance()
            with open(dirs.env.joinpath("config.yml"), "r") as fp:
                clazz._data = yaml.load(fp.read(), Loader=yaml.FullLoader)

        return clazz._data


@register_resolver('datastore')
class DatastoreResolver(Resolver):
    _data = None  # cache

    def resolve(self):
        configs = self.load()

        assert self.key in configs, f"config {self.key} not present"
        return configs[self.key]

    def load(self):
        clazz = type(self)
        if clazz._data is None:
            # load data from s3 bucket
            response = self.context.s3.get_object(Bucket=self.s3bucket, Key=self.s3key)

            # deserialize
            clazz._data = yaml.load(
                response['Body'].read().decode('utf-8'),
                Loader=yaml.FullLoader
            )

        return clazz._data

    @property
    def s3bucket(self):
        normalize = self.context.s3_folder.replace("s3://", "")
        return normalize.split("/", 1)[0]

    @property
    def s3key(self):
        full_path = f"{self.context.s3_folder}/{self.context.cmfive_client}_config.yml"
        normalize = full_path.replace("s3://", "")
        return normalize.split("/", 1)[1]


@register_resolver('output')
class StackOutputResolver(Resolver):
    def resolve(self):
        for stack in self.stacks():
            value = self.outputs(stack).get(self.key)
            if value is not None:
                return value
        else:
            raise Exception(f"Stack output '{self.key}' is not present")

    def stacks(self):
        filters = ['ROLLBACK_COMPLETE', 'CREATE_COMPLETE', 'UPDATE_COMPLETE']
        stacks = self.context.cf.list_stacks(StackStatusFilter=filters)

        while True:
            for stack in stacks['StackSummaries']:
                yield stack['StackName']

            if 'NextToken' in stacks:
                stacks = self.context.cf.list_stacks(
                    NextToken=stacks['NextToken'],
                    StackStatusFilter=filters
                )
            else:
                break

    def outputs(self, stack):
        summary = self.context.cf.describe_stacks(StackName=stack)['Stacks'][0]

        if 'Outputs' not in summary:
            return {}

        for output in summary['Outputs']:
            return {
                output["ExportName"]:output["OutputValue"]
                for output in summary['Outputs']
                if 'ExportName' in output
            }


@register_resolver('secret')
class SecretManagerResolver(Resolver):
    def resolve(self):
        try:
            secret = self.context.ss.get_secret_value(SecretId=self.key)
        except ClientError as e:
            raise Exception(f"Unable to retrieve secretId '{self.key}'") from e

        entries = json.loads(secret['SecretString'])
        return entries[self.config]
