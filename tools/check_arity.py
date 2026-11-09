"""Static arity check: every R.NAME(...) call in gen/ against runtime/r.gd signatures."""
import re
import sys
import os

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def split_params(text):
    parts, depth, cur, quote = [], 0, [], None
    for ch in text:
        if quote:
            cur.append(ch)
            if ch == quote:
                quote = None
            continue
        if ch in "\"'":
            quote = ch
            cur.append(ch)
        elif ch in "([{":
            depth += 1
            cur.append(ch)
        elif ch in ")]}":
            depth -= 1
            cur.append(ch)
        elif ch == "," and depth == 0:
            parts.append("".join(cur).strip())
            cur = []
        else:
            cur.append(ch)
    tail = "".join(cur).strip()
    if tail:
        parts.append(tail)
    return parts


def parse_runtime():
    src = open(os.path.join(ROOT, "runtime", "r.gd"), encoding="utf-8").read()
    sigs = {}
    for m in re.finditer(r"^static func (\w+)\s*\(", src, re.M):
        name = m.group(1)
        i = m.end() - 1
        depth, j, quote = 0, i, None
        while j < len(src):
            ch = src[j]
            if quote:
                if ch == quote:
                    quote = None
            elif ch in "\"'":
                quote = ch
            elif ch == "(":
                depth += 1
            elif ch == ")":
                depth -= 1
                if depth == 0:
                    break
            j += 1
        params = split_params(src[i + 1:j])
        req = sum(1 for p in params if "=" not in p)
        sigs[name] = (req, len(params))
    return sigs


def count_args(src, start):
    """start = index of '(' ; returns (argcount, end_index)."""
    depth, j, quote, n = 0, start, None, 1
    has_content = False
    while j < len(src):
        ch = src[j]
        if quote:
            if ch == "\\":
                j += 2
                continue
            if ch == quote:
                quote = None
            has_content = True
        elif ch in "\"'":
            quote = ch
            has_content = True
        elif ch in "([{":
            depth += 1
            if depth > 1:
                has_content = True
        elif ch in ")]}":
            depth -= 1
            if depth == 0:
                return (n if has_content or n > 1 else 0), j
        elif ch == "," and depth == 1:
            n += 1
            has_content = False
            j += 1
            continue
        elif not ch.isspace() and depth == 1:
            has_content = True
        j += 1
    return n, j


def main():
    sigs = parse_runtime()
    bad = 0
    total = 0
    for dirpath, _, files in os.walk(os.path.join(ROOT, "gen")):
        for f in files:
            if not f.endswith(".gd"):
                continue
            path = os.path.join(dirpath, f)
            src = open(path, encoding="utf-8").read()
            for m in re.finditer(r"\bR\.(\w+)\s*\(", src):
                name = m.group(1)
                if name not in sigs:
                    continue
                n, _ = count_args(src, m.end() - 1)
                total += 1
                lo, hi = sigs[name]
                if n < lo or n > hi:
                    line = src.count("\n", 0, m.start()) + 1
                    rel = os.path.relpath(path, ROOT).replace("\\", "/")
                    print("%s:%d R.%s got %d want %d..%d" % (rel, line, name, n, lo, hi))
                    bad += 1
    print("ARITY calls=%d bad=%d" % (total, bad))
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main())
