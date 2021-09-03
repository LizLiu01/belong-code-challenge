from abc import ABC, abstractmethod


class Definition(ABC):

    @abstractmethod
    def read(self):
        pass