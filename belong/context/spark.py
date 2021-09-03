from pyspark import SparkConf, SparkContext
from belong.util.collections import CollectionUtils
import pyspark
from urllib.parse import urlparse
from belong.config.s3_belong_config import S3BelongConfig
from belong.config.local_belong_config import LocalBelongConfig
from awsglue.context import GlueContext

class BelongContext:

    def __init__(self, config_path, run_mode):

        config_path_loc = urlparse(config_path, allow_fragments=False)

        if run_mode == 'emr' or run_mode == 'glue':
            s3_config = S3BelongConfig
            conf = s3_config.load(s3_config, config_path)
        elif run_mode == 'local':
            local_config = LocalBelongConfig
            conf = local_config.load(local_config, config_path)
        else:
            raise Exception('Run mode not supported')

        if run_mode == 'glue':
            self.spark = pyspark.context.SparkContext()
            self.sql_context = GlueContext(self.spark)
        elif run_mode == 'emr' or run_mode == 'local':
            flatten_conf = CollectionUtils.flatten(conf)
            spark_conf = SparkConf().setAll([tuple(x) for x in flatten_conf.items()])
            self.spark = pyspark.context.SparkContext(conf=spark_conf)
            self.sql_context = pyspark.sql.SQLContext(self.spark)
        else:
            Exception('Run mode not supported')
