#!/usr/bin/env python3
"""Report Dart class constructors with more than MAX_PARAMS parameters."""

import os
import re
import sys

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.normpath(os.path.join(SCRIPT_DIR, "..", "lib"))
MAX_PARAMS = 5
SKIP_NAMES = frozenset({".git", ".dart_tool", "build", "generated"})


def find_matching_paren(lines: list[str], start_row: int, open_col: int) -> tuple[int, int] | None:
    line = lines[start_row]
    depth = 1
    i = start_row
    j = open_col + 1
    while i < len(lines):
        current = lines[i]
        while j < len(current):
            c = current[j]
            if c == "(" or c == "[" or c == "<":
                depth += 1
            elif c == ")" or c == "]" or c == ">":
                depth -= 1
                if depth == 0 and c == ")":
                    return (i, j)
            elif c == "{":
                depth += 1
            elif c == "}":
                depth -= 1
            j += 1
        i += 1
        j = 0
    return None


def count_top_level_commas(text: str) -> int:
    depth = 0
    count = 0
    i = 0
    while i < len(text):
        c = text[i]
        if c == "(" or c == "[" or c == "<" or c == "{":
            depth += 1
        elif c == ")" or c == "]" or c == ">" or c == "}":
            depth -= 1
        elif c == "," and depth == 0:
            count += 1
        i += 1
    return count


def count_params(param_text: str) -> int:
    param_text = param_text.strip()
    if not param_text or param_text.startswith(")"):
        return 0
    if param_text.startswith("{"):
        inner = param_text[1:]
        depth = 1
        for i, c in enumerate(inner):
            if c == "{":
                depth += 1
            elif c == "}":
                depth -= 1
                if depth == 0:
                    inner = inner[:i]
                    break
        inner = inner.strip()
        if not inner:
            return 0
        commas = count_top_level_commas(inner)
        if inner.rstrip().endswith(","):
            return commas
        return commas + 1
    return count_top_level_commas(param_text) + 1


def check_file(path: str) -> list[tuple[int, int, str]]:
    with open(path, encoding="utf-8", errors="replace") as f:
        lines = f.readlines()
    violations: list[tuple[int, int, str]] = []
    class_stack: list[tuple[str, int]] = []
    i = 0
    while i < len(lines):
        line = lines[i]
        class_match = re.match(r"^\s*class\s+(\w+)\s*[{\s]", line)
        if class_match:
            class_stack.append((class_match.group(1), 0))
        for c in line:
            if c == "{":
                if class_stack:
                    class_stack[-1] = (class_stack[-1][0], class_stack[-1][1] + 1)
            elif c == "}":
                if class_stack:
                    name, depth = class_stack[-1]
                    depth -= 1
                    if depth <= 0:
                        class_stack.pop()
                    else:
                        class_stack[-1] = (name, depth)
        current_class = class_stack[-1][0] if class_stack else None
        if current_class:
            match = re.search(r"^\s*(?:factory\s+)?(\w+(?:\.\w+)?)\s*\(", line)
            if match:
                name = match.group(1)
                if name == current_class or name.startswith(current_class + "."):
                    open_col = match.end(1)
                    paren_start = line.find("(", open_col - 1)
                    if paren_start != -1:
                        end = find_matching_paren(lines, i, paren_start)
                        if end is not None:
                            end_row, end_col = end
                            if end_row == i:
                                param_text = line[paren_start + 1 : end_col]
                            else:
                                parts = [line[paren_start + 1 :].rstrip()]
                                for r in range(i + 1, end_row):
                                    parts.append(lines[r].rstrip())
                                parts.append(lines[end_row][:end_col])
                                param_text = " ".join(parts)
                            param_count = count_params(param_text)
                            if param_count > MAX_PARAMS:
                                violations.append((i + 1, param_count, name))
        i += 1
    return violations


def main() -> None:
    total = 0
    for dirpath, dirnames, filenames in os.walk(ROOT, topdown=True):
        dirnames[:] = [d for d in dirnames if d not in SKIP_NAMES]
        for name in filenames:
            if not name.endswith(".dart"):
                continue
            path = os.path.join(dirpath, name)
            rel = os.path.relpath(path, ROOT)
            violations = check_file(path)
            for line_no, count, ctor_name in violations:
                print(f"{rel}:{line_no}: {ctor_name} ({count} parameters)")
                total += 1
    if total:
        print(f"\n{total} constructor(s) exceed {MAX_PARAMS} parameters.", file=sys.stderr)
        sys.exit(1)
    print(f"No constructors exceed {MAX_PARAMS} parameters.", file=sys.stderr)


if __name__ == "__main__":
    main()
