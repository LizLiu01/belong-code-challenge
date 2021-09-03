from abc import ABC, abstractmethod


class BelongConfig(ABC):

    @abstractmethod
    def load(self, config_path):
        pass