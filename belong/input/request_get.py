from belong.input.input import Input
import boto3
from belong.util.upload_to_s3 import upload_to_s3
import requests


class RequestGetInput(Input):

    def extract(self, sql_context, definition):
        remote_content = requests.get(definition['url']).content
        client = boto3.client('s3')
        upload_to_s3(definition['bucket'],definition['upload_key'],remote_content,client)
        url = f"s3://{definition['bucket']}/{definition['upload_key']}"
        df = sql_context.read\
            .option('header', 'true') \
            .option('inferschema', 'false')\
            .option('delimiter', ',') \
            .option('quote', '"') \
            .csv(url)
        return df
