"""
"""
from pathlib import Path


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

    @property
    def override(self):
        return self.env.joinpath("configs", "common_override")

    @property
    def scripts(self):
        return self.env.joinpath("scripts")
    
    @property
    def vscode(self):
        return self.root.joinpath(".vscode")