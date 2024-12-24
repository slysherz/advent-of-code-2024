import sys
import re
import shared

def parse_input():
    input = shared.get_input()
    result = []
    for m in re.finditer(r'(\d+): ([\d ]+)', input):
        r, ns = m.groups()
        result.append((int(r), [int(s) for s in ns.split(' ')]))
    return result

def solvable(r, ns):
    possibilities = set([ns[0]])
    for n in ns[1:]:
        possibilities = set(n + c for c in possibilities) | set(n * c for c in possibilities)

    return r in possibilities

def main():
    input = parse_input()

    result = sum(1 if solvable(n, ns) else 0 for n, ns in input)
    print(f"Result part 1: {result}")

if __name__ == '__main__':
    main()