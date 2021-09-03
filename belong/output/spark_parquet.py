from belong.output.output import Output


class SparkParquetOutput(Output):

    def load(self, sql_context, definition):
        df = sql_context.sql("SELECT * FROM " + definition['name'])
        df.write.parquet(definition['url'])
