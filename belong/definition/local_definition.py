from belong.definition.definition import Definition
import yaml


class LocalDefinition(Definition):

    def read(self, defo_path):
        with open(defo_path) as file:
            step_list = yaml.load(file)
        return step_list
