from belong.output.output import Output


class SparkConsoleOutput(Output):

    def load(self, sql_context, definition):
        df = sql_context.sql("SELECT * FROM " + definition['name'])
        df.show()
