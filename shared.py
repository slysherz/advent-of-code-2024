import sys

def get_input():
    filename = sys.argv[1]
    with open(filename) as f:
        return f.read()
    
    raise Exception("No input file provided")