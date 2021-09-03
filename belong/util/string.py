
class StringUtils:

    @staticmethod
    def snake_to_camel(text):
        return ''.join(x.capitalize() or '_' for x in text.split('_'))
