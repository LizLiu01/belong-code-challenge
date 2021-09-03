from abc import ABC, abstractmethod


class Input(ABC):

    @abstractmethod
    def extract(self):
        pass
