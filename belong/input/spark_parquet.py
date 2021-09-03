from belong.input.input import Input


class SparkParquetInput(Input):

    def extract(self, sql_context, definition):
        df = sql_context.read.parquet(definition['url'])
        return df
