from pathlib import Path


class Dirs:    
    def __init__(self, dsl):
        self._dsl = dsl

    @property
    def dsl(self):        
        return Path(self._dsl).expanduser().resolve()

    @property
    def lookup(self):
        return self.dsl.parent
