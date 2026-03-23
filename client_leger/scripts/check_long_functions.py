#!/usr/bin/env python3
"""Report Dart functions/methods with more than MAX_LINES lines (body from { to })."""

import os
import re
import sys

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.normpath(os.path.join(SCRIPT_DIR, "..", "lib"))
MAX_LINES = 30
SKIP_NAMES = frozenset({".git", ".dart_tool", "build", "generated"})


def find_matching_brace(lines: list[str], start_row: int, open_col: int) -> int | None:
    stack = 1
    for i in range(start_row + 1, len(lines)):
        line = lines[i]
        for j, c in enumerate(line):
            if c == "{":
                stack += 1
            elif c == "}":
                stack -= 1
                if stack == 0:
                    return i
    return None


def extract_name(line: str) -> str:
    match = re.search(r"(\w+)\s*\([^)]*\)\s*(?:async\s*)?\{", line)
    if match:
        return match.group(1)
    return "?"


def check_file(path: str) -> list[tuple[int, int, str]]:
    with open(path, encoding="utf-8", errors="replace") as f:
        lines = f.readlines()
    violations: list[tuple[int, int, str]] = []
    i = 0
    while i < len(lines):
        line = lines[i]
        if re.search(r"\)\s*(?:async\s*)?\s*\{", line):
            open_col = line.rfind("{")
            if open_col != -1:
                end_row = find_matching_brace(lines, i, open_col)
                if end_row is not None:
                    count = end_row - i + 1
                    if count > MAX_LINES:
                        name = extract_name(line)
                        violations.append((i + 1, count, name))
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
            in_view_folder = "widgets" in rel or "screens" in rel
            if in_view_folder and "view_model" not in name:
                continue
            parts = rel.split(os.sep)
            if "di" in parts or "painters" in parts:
                continue
            violations = check_file(path)
            for line_no, count, func_name in violations:
                print(f"{rel}:{line_no}: {func_name} ({count} lines)")
                total += 1
    if total:
        print(f"\n{total} function(s) exceed {MAX_LINES} lines.", file=sys.stderr)
        sys.exit(1)
    print(f"No functions exceed {MAX_LINES} lines.", file=sys.stderr)


if __name__ == "__main__":
    main()
