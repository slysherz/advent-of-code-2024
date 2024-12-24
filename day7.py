import re
import shared


def parse_input():
    input = shared.get_input()
    result = []
    for m in re.finditer(r"(\d+): ([\d ]+)", input):
        r, ns = m.groups()
        result.append((int(r), [int(s) for s in ns.split(" ")]))
    return result


def concat(a, b):
    return int(str(a) + str(b))


def solvable1(r, ns):
    possibilities = set([ns[0]])
    for n in ns[1:]:
        possibilities = set(n + c for c in possibilities) | set(
            n * c for c in possibilities
        )

    return r in possibilities


def solvable2(r, ns):
    possibilities = set([ns[0]])
    for n in ns[1:]:
        possibilities = (
            set(n + c for c in possibilities)
            | set(n * c for c in possibilities)
            | set(concat(c, n) for c in possibilities)
        )

    return r in possibilities


def main():
    input = parse_input()

    result1 = sum(n if solvable1(n, ns) else 0 for n, ns in input)
    result2 = sum(n if solvable2(n, ns) else 0 for n, ns in input)
    print(f"Result part 1: {result1}")
    print(f"Result part 2: {result2}")


if __name__ == "__main__":
    main()
