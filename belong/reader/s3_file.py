from belong.reader.file_reader import FileReader
import boto3
from urllib.parse import urlparse


class S3FileReader(FileReader):

    def read(self, file_path):
        s3 = boto3.resource('s3')
        s3_loc = urlparse(file_path, allow_fragments=False)
        s3_key = s3_loc.path[1:]
        obj = s3.Object(s3_loc.netloc, s3_key)
        return obj.get()['Body'].read().decode('utf-8')

