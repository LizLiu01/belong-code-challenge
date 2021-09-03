from belong.input.input import Input


class SparkTextInput(Input):

    def extract(self, sql_context, definition):
        df = sql_context.read.option('header', 'true').csv(definition['url'])
        return df
