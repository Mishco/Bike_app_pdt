import psycopg2

_connection = None

def get_connection():
    global _connection
    global _db_cur
    if not _connection:
        try:
            _connection = psycopg2.connect(dbname='osm', host='localhost', port=5432, user='postgres', password='123456789')
        except:
            print("I am unable to connect to the database")

    # old settings
    #_db_cur = _connection.cursor()
    _db_cur = _connection.cursor(cursor_factory = psycopg2.extras.DictCursor)
    return _db_cur

# List of stuff accessible to importers of this module. Just in case
__all__ = [ 'getConnection' ]
