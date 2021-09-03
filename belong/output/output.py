from abc import ABC, abstractmethod


class Output(ABC):

    @abstractmethod
    def load(self):
        pass
