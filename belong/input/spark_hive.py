from belong.input.input import Input


class SparkHiveInput(Input):

    def extract(self, sql_context, definition):
        df = sql_context.sql(definition['sql'])
        return df