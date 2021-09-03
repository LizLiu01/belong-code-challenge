from belong.definition.definition import Definition
import yaml
import boto3
from urllib.parse import urlparse


class S3Definition(Definition):

    def read(self, defo_path):
        s3 = boto3.resource('s3')
        s3_loc = urlparse(defo_path, allow_fragments=False)
        s3_key = s3_loc.path[1:]
        obj = s3.Object(s3_loc.netloc, s3_key)
        config_text = obj.get()['Body'].read().decode('utf-8')
        step_list = yaml.load(config_text)
        return step_list
