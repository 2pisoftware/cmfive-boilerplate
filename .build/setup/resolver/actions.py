import boto3
from botocore.exceptions import ClientError
from .fields import Field
import resolver.util as util
import logging

logger = logging.getLogger(__name__)

# -------
# Manager
# -------
class ActionManager:
    IDENTIFIER = "actions"

    def __init__(self, database, dirs):
        self.database = database 
        self.dirs = dirs

    def execute(self):
        for context in self.database.get(f"custom.{self.IDENTIFIER}"):
            action = self.create_action(context)
            action.execute(self.dirs)

    @staticmethod
    def create_action(context):
        clazz = action_registry[context["type"]]
        return clazz(context)


# -------
# Actions
# -------
action_registry = {}


def register_action(name):
    """add resolver class to registry"""
    def add_class(clazz):
        action_registry[name] = clazz
        return clazz
    return add_class


@register_action("github_clone")
class SourceControlClone:
    def __init__(self, props):
        self.props = props                
        self.username = self.resolve("username")
        self.password = self.resolve("password")
        self.repository = self.resolve("repository")
        self.owner = self.resolve("owner")
        self.ref = self.resolve("ref")
        self._destination = self.resolve("destination")

    def execute(self, dirs):
        logger.info('github_clone') 
        util.run("git clone https://{username}:{password}@github.com/{owner}/{repository}.git --single-branch --branch {ref} {destination}".format(
            username=self.username,
            password=self.password,
            owner=self.owner,
            repository=self.repository,
            ref=self.ref,
            destination=self.destination(dirs)
        ))

    # --------------
    # Helper Methods
    # --------------    
    def destination(self, dirs):
        """clone directory is relative to schema file"""
        if self._destination == "":
            return dirs.lookup.joinpath(self.repository)
        
        return dirs.lookup.joinpath(self._destination)

    def resolve(self, key):        
        return Field.create(key, self.props["prop"][key]).value

    @staticmethod
    def schema():
        return {
            "type" : "object",
            "properties" : {
                "type": { "type" : "string" },
                "prop": { 
                    "type" : "object",
                    "properties": {
                        "username": { "type": ["string", "object"] },
                        "password": { "type": ["string", "object"] },
                        "repository": { "type": ["string", "object"] },
                        "owner": { "type": ["string", "object"] },
                        "ref": { "type": ["string", "object"] },
                        "destination": { "type": ["string", "object"] },
                    },
                    "required": [
                        "username",
                        "password",
                        "repository",
                        "owner",
                        "ref",
                        "destination"
                    ]
                },
            },
            "required": ["type", "prop"]
        }


@register_action("codecommit_clone")
class CodeCommitClone:
    """
    Assumed action is ran in the context of an AWS CodeBuild project with the permission set:
    - "codecommit:GitPull",
    - "codecommit:GetRepository"
    """
    def __init__(self, props):
        self.props = props           
        self.repository = self.resolve("repository")          
        self.ref = self.resolve("ref")
        self._destination = self.resolve("destination")

    def execute(self, dirs):
        logger.info('codecommit_clone')      

        command = self.clone_command(dirs)                 
        logger.info(command)      
        util.run(command)

    # --------------
    # Helper Methods
    # --------------
    def clone_command(self, dirs):        
        return "git clone {url} --single-branch --branch {ref} {destination}".format(
            url=self.codecommit_clone_url,
            ref=self.ref,
            destination=self.destination(dirs)
        )

    def destination(self, dirs):
        """clone directory is relative to schema file"""
        if self._destination == "":
            return dirs.lookup.joinpath(self.repository)
        
        return dirs.lookup.joinpath(self._destination)

    def resolve(self, key):        
        return Field.create(key, self.props["prop"][key]).value

    @property
    def codecommit_clone_url(self):        
        try:
            client = boto3.client('codecommit')
            response = client.get_repository(repositoryName=self.repository)
        except ClientError as e:        
            if e.response['Error']['Code'] == 'RepositoryDoesNotExistException':
                raise Exception(f"CodeCommit repository '{self.repository}' does not exist") from e

            # couldn't handle
            raise

        return response["repositoryMetadata"]["cloneUrlHttp"]    

    @staticmethod
    def schema():
        return {
            "type" : "object",
            "properties" : {
                "type": { "type" : "string" },
                "prop": { 
                    "type" : "object",
                    "properties": {
                        "repository": { "type": ["string", "object"] },                        
                        "ref": { "type": ["string", "object"] },
                        "destination": { "type": ["string", "object"] },                     
                    },
                    "required": [                        
                        "repository",
                        "ref",
                        "destination"
                    ]
                },
            },
            "required": ["type", "prop"]
        }