#!/usr/bin/env python3
"""Run import_lint and print a readable report grouped by file."""

import os
import re
import subprocess
import sys

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.normpath(os.path.join(SCRIPT_DIR, ".."))

def run_import_lint() -> str:
    result = subprocess.run(
        "dart run import_lint",
        capture_output=True,
        text=True,
        encoding="utf-8",
        cwd=ROOT,
        shell=True,
    )
    return result.stdout + result.stderr

def parse_line(line: str) -> tuple[str, str, str, int] | None:
    parts = line.strip().split(" • ")
    if len(parts) != 3:
        return None
    rule_name, package_path, rest = (p.strip() for p in parts)
    match = re.search(r"':(\d+)\s*$", rest)
    if not match:
        return None
    line_no = int(match.group(1))
    import_stmt = rest[: match.start()].strip()
    if package_path.startswith("package:"):
        file_path = package_path.split(":", 1)[1]
    else:
        file_path = package_path
    file_path = file_path.replace("\\", "/")
    return (rule_name, file_path, import_stmt, line_no)

def main() -> None:
    out = run_import_lint()
    lines = [l for l in out.splitlines() if l.strip()]

    if not lines or "No issues found" in out:
        print(out.strip())
        sys.exit(0)

    by_file: dict[str, list[tuple[str, str, int]]] = {}
    for raw in lines:
        parsed = parse_line(raw)
        if not parsed:
            continue
        rule_name, file_path, import_stmt, line_no = parsed
        if file_path not in by_file:
            by_file[file_path] = []
        by_file[file_path].append((rule_name, import_stmt, line_no))

    print("Import lint - cross-feature violations")
    print("=" * 60)
    total = sum(len(v) for v in by_file.values())
    print(f"Total: {total} violation(s) in {len(by_file)} file(s)\n")

    for file_path in sorted(by_file.keys()):
        items = by_file[file_path]
        print(f"  {file_path}")
        for rule_name, import_stmt, line_no in sorted(items, key=lambda x: x[2]):
            print(f"    line {line_no}: {import_stmt}")
            print(f"      rule: {rule_name}")
        print()

    sys.exit(1 if by_file else 0)

if __name__ == "__main__":
    main()
