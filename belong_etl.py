from belong.config.local_belong_config import LocalBelongConfig
from belong.config.s3_belong_config import S3BelongConfig
from belong.context.spark import BelongContext
from belong.etl.etl import ETL
import getopt
import sys
from urllib.parse import urlparse
from awsglue.utils import getResolvedOptions, GlueArgumentError
from awsglue.job import Job


def main():

    args = getResolvedOptions(sys.argv, ['JOB_NAME', 'config','pipeline','run_mode'])

    config_path = args['config']
    pipeline_path = args['pipeline']
    run_mode = args['run_mode']

    if config_path == '' or pipeline_path == '':
        raise Exception('Configuration and Pipeline must be set')
    else:
        (config_scheme, config_bucket, config_key) = parse_s3_uri(config_path)

        sc = BelongContext(config_path, run_mode)
        if run_mode == 'glue':
            args = getResolvedOptions(sys.argv, ['JOB_NAME'])
            job = Job(sc.sql_context)
            job.init(args['JOB_NAME'], args)
        etl = ETL
        etl.execute_pipeline_definition(etl, pipeline_path, sc.sql_context)
        if run_mode == "glue":
            job.commit()


def parse_s3_uri(uri: str) -> (str, str, str):
    s3_path_loc = urlparse(uri, allow_fragments=False)
    scheme, bucket, key = (s3_path_loc.scheme, s3_path_loc.netloc, s3_path_loc.path[1:])
    return scheme, bucket, key


if __name__ == "__main__":
    main()
