import sys
import os
import textwrap

CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))
ROOT_DIR = os.path.dirname(os.path.dirname(os.path.dirname(CURRENT_DIR)))

sys.path.append(ROOT_DIR + '/lib/openpyxl-2.3.1')
sys.path.append(ROOT_DIR + '/lib/jdcal-1.2')
sys.path.append(ROOT_DIR + '/lib/et_xmlfile-1.0.1')

from openpyxl import load_workbook


##  Constants  ##

VERBOSE = "-v" in sys.argv

INSERT_SQL = "INSERT INTO {} ({})\n    VALUES ({});\n\n"

SQL_PATH = ROOT_DIR + "/src/data/setup.sql"
CREATE_TABLES_PATH = ROOT_DIR + "/src/data/create_tables.sql"
DROP_TABLES_PATH = ROOT_DIR + "/src/data/drop_tables.sql"
SEED_PATH = ROOT_DIR + "/src/data/seed.xlsx"


##  Functions  ##

# Generate Insert SQL
# Creates an INSERT INTO SQL statement
# Parameters:
#   relation:   name of relation to generate SQL statement for
#   attrs:      attributes that will be set in the statement
#   vals:       values for the provided attributes (must be same length as
#               attrs)
# Exceptions:
#   ValueError: attrs and vals must be the same length
def generate_insert_sql(relation, attrs=[], vals=[]):
    if (len(attrs) != len(vals)):
        raise ValueError("Attibutes and values must be the same length.")

    return INSERT_SQL.format(relation, list_to_str(attrs), list_to_str(vals, '\''))

# List to String
# Converts a list of elements to a string by casting each element as a string
# and placing the specified delimiter between them
# Parameters:
#   arr:    array of elements to convert to string
#   wrap:   string to wrap elements in
#   delim:  delimeter place between elements
def list_to_str(arr=[], wrap='', delim=', '):
    return delim.join(wrap + (x.encode('utf-8') if isinstance(x, unicode) else str(x)).replace("'", "\\'") + wrap for x in arr)

# Log
# Alternative to print that maintain indent based on prefix
# Parameters:
#   msg:    message that will be written to the console
#   prefix: string that is prepended to msg, indentation will match this
def log(msg="", prefix=""):
    if VERBOSE:
        wrapper = textwrap.TextWrapper(initial_indent=prefix, width=200, subsequent_indent=' '*len(prefix))
        print(wrapper.fill(' '.join(msg.split())))


##  Main  ##

if os.path.exists(SQL_PATH):
    os.remove(SQL_PATH)

with open(SQL_PATH, "w+") as outFile:
    if os.path.exists(DROP_TABLES_PATH):
        with open(DROP_TABLES_PATH, "r") as f:
            outFile.write(f.read() + "\n\n")

    if os.path.exists(CREATE_TABLES_PATH):
        with open(CREATE_TABLES_PATH, "r") as f:
            outFile.write(f.read() + "\n\n")

    seed = load_workbook(filename=SEED_PATH, read_only=True, data_only=True)
    relationNames = seed.get_sheet_names()

    for relationName in relationNames:
        attributes = None
        relation = seed[relationName]
        log(relationName, "RELATION NAME:  ")

        for row in relation.rows:
            vals = []
            for cell in row:
                vals.append(cell.value)

            if attributes is None:
                attributes = vals
                log(list_to_str(vals), "ATTRIBUTES:    ")
            else:
                sql = generate_insert_sql(relationName, attributes, vals)
                outFile.write(sql)
                log(list_to_str(vals), "    VALUES:    ")
                log(sql, "    SQL:       ")

        log()
