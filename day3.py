import sys
import re

def get_input():
    filename = sys.argv[1]
    with open(filename) as f:
        return f.read()
    
    raise Exception("No input file provided")

def main():
    result1 = 0
    result2 = 0
    enabled = True
    for line in get_input().splitlines():
        for m in re.finditer(r'(mul\((\d+),(\d+)\))|(do\(\))|(don\'t\(\))', line):
            s = m.group()
            if s == 'do()':
                enabled = True
            elif s == 'don\'t()':
                enabled = False
            else:
                n1, n2 = m.groups()[1:3]
                mul = int(n1) * int(n2)
                result1 += mul
                if enabled:
                    result2 += mul

    print(f"Result part 1: {result1}")
    print(f"Result part 2: {result2}")

if __name__ == '__main__':
    main()