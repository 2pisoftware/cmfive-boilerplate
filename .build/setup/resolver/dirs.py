from pathlib import Path


class Dirs:
    _instance = None

    def __init__(self, dsl):
        self._dsl = dsl

    @classmethod
    def instance(cls, dsl=None):
        if cls._instance is None:
            cls._instance = Dirs(dsl)
        return cls._instance

    @property
    def dsl(self):
        return Path(self._dsl).expanduser().resolve()

    @property
    def lookup(self):
        return self.dsl.parent
