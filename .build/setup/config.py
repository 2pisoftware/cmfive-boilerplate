"""
<description>
"""
from pathlib import Path
import yaml


class Directories:
    def __init__(self, env):
        self._env = env

    @property
    def cwd(self):
        return Path(__file__).expanduser().resolve().parent

    @property
    def root(self):
        return self.cwd.joinpath(*[".." for _ in range(2)])

    @property
    def common(self):
        return self.cwd.joinpath("..", "common")

    @property
    def env(self):
        return self.cwd.joinpath("..", "environment", self._env)

    @property
    def stage(self):
        return self.env.joinpath("stage")

    @property
    def cmfive(self):
        return self.env.joinpath("configs", "cmfive")

    @property
    def docker(self):
        return self.env.joinpath("configs", "docker")

    @property
    def image(self):
        return self.env.joinpath("configs", "image")


class Config:
    config = None

    @classmethod
    def data(cls, env):
        if cls.config is None:
            cls.config = cls.load(env)
        return cls.config

    @staticmethod
    def load(env):
        dirs = Directories(env)
        with open(dirs.env.joinpath("config.yml"), "r") as fp:
            result = yaml.load(fp, Loader=yaml.FullLoader)
            result["environment"] = env

        return result
