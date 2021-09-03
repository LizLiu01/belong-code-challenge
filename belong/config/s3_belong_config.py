from belong.config.belong_config import BelongConfig
from pyhocon import ConfigFactory
import boto3
from urllib.parse import urlparse


class S3BelongConfig(BelongConfig):

    def load(self, config_path):
        s3 = boto3.resource('s3')
        s3_loc = urlparse(config_path, allow_fragments=False)
        s3_key = s3_loc.path[1:]
        obj = s3.Object(s3_loc.netloc, s3_key)
        config_text = obj.get()['Body'].read().decode('utf-8')
        conf = ConfigFactory.parse_string(config_text)
        return conf


