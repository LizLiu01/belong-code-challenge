from belong.reader.file_reader import FileReader


class LocalFileReader(FileReader):

    def read(self, file_path):
        with open(file_path, 'r') as reader:
            sql_text = reader.read()

        return sql_text
