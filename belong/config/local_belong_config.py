from belong.config.belong_config import BelongConfig
from pyhocon import ConfigFactory


class LocalBelongConfig(BelongConfig):

    def load(self, config_path):
        conf = ConfigFactory.parse_file(config_path)
        return conf
