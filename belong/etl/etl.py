from urllib.parse import urlparse
from belong.util.string import StringUtils
from belong.definition.local_definition import LocalDefinition
from belong.definition.s3_definition import S3Definition


class ETL:

    def execute_pipeline_definition(self, pipeline_path, sql_context):

        config_path_loc = urlparse(pipeline_path, allow_fragments=False)

        if config_path_loc.scheme == 's3':
            s3_defo = S3Definition
            step_list = s3_defo.read(s3_defo, pipeline_path)
        elif config_path_loc.netloc == '':
            local_defo = LocalDefinition
            step_list = local_defo.read(local_defo, pipeline_path)
        else:
            raise Exception('URL not supported')

        for inp in step_list['input']:
            package_path = 'belong.input.' + inp['type']
            concrete_class = StringUtils.snake_to_camel(inp['type'] + '_input')

            mod_import = __import__(package_path, fromlist=[concrete_class])
            clazz = getattr(mod_import, concrete_class)
            df = clazz.extract(clazz, sql_context, inp)
            df.createOrReplaceTempView(inp['name'])

        try:
            for trans in step_list['transform']:
                package_path = 'belong.reader.' + trans['type']
                concrete_class = StringUtils.snake_to_camel(trans['type'] + '_reader')
                mod_import = __import__(package_path, fromlist=[concrete_class])
                clazz = getattr(mod_import, concrete_class)
                sql_text = clazz.read(clazz, trans['url'])
                df = sql_context.sql(sql_text)
                df.createOrReplaceTempView(trans['name'])
        except:
            pass

        for out in step_list['output']:
            package_path = 'belong.output.' + out['type']
            concrete_class = StringUtils.snake_to_camel(out['type'] + '_output')

            mod_import = __import__(package_path, fromlist=[concrete_class])
            clazz = getattr(mod_import, concrete_class)

            clazz.load(clazz, sql_context, out)


