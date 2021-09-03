from pyspark import SQLContext

from belong.output.output import Output


class SparkTableOutput(Output):

    def load(self, sql_context, definition):
        df = sql_context.sql("SELECT * FROM " + definition['name'])
        df.write.saveAsTable(definition['table_name'], format='parquet', mode='overwrite',
                             path=definition['table_path'])
