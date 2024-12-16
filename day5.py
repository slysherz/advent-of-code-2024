import shared
import re
from functools import cmp_to_key

def valid_sequence(sequence, order):
    for i in range(len(sequence) - 1):
        if order[sequence[i + 1]][sequence[i]] == 1:
            return False
    return True

def main():
    input = shared.get_input()
    pairs = [(int(m.groups()[0]), int(m.groups()[1])) for m in re.finditer(r'(\d+)\|(\d+)', input)]
    sequences = [[int(s) for s in m[0].split(',')] for m in re.findall(r'(\d+(,\d+)+)', input)]
    
    MIN = min([min(s) for s in pairs])
    MAX = max([max(s) for s in pairs]) + 1

    order = [[0] * MAX for _ in range(MAX)]
    for pair in pairs:
        order[pair[0]][pair[1]] = 1
    
    def compare(a, b):
        if order[a][b] == 1:
            return 1
        elif order[b][a] == 1:
            return -1
        return 0

    result1 = 0
    result2 = 0
    for sequence in sequences:
        if valid_sequence(sequence, order):
            result1 += sequence[len(sequence) // 2]
        else:
            ns = sorted(sequence, key=cmp_to_key(compare))
            result2 += ns[len(ns) // 2]
    
    print("Result part 1:", result1)
    print("Result part 2:", result2)
            
if __name__ == '__main__':
    main()