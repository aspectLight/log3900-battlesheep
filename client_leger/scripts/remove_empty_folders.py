#!/usr/bin/env python3
"""Remove empty directories under client_leger. Skips .git, .dart_tool, build, .idea, .vscode."""

import os
import sys

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.normpath(os.path.join(SCRIPT_DIR, ".."))
SKIP_NAMES = frozenset({".git", ".dart_tool", "build", ".idea", ".vscode"})


def main() -> None:
    entries: list[tuple[str, list[str], list[str]]] = []
    for dirpath, dirnames, filenames in os.walk(ROOT, topdown=True):
        dirnames[:] = [d for d in dirnames if d not in SKIP_NAMES]
        if dirpath == ROOT:
            continue
        if os.path.basename(dirpath) in SKIP_NAMES:
            continue
        entries.append((dirpath, list(dirnames), list(filenames)))
    removed: set[str] = set()
    by_depth = sorted(entries, key=lambda e: -e[0].count(os.sep))
    for dirpath, dirnames, filenames in by_depth:
        children_gone = all(
            os.path.normpath(os.path.join(dirpath, d)) in removed for d in dirnames
        )
        if not filenames and children_gone and os.path.isdir(dirpath):
            try:
                os.rmdir(dirpath)
                removed.add(os.path.normpath(dirpath))
            except OSError:
                pass
    for path in sorted(removed):
        print(path)
    if removed:
        print(f"Removed {len(removed)} empty folder(s).", file=sys.stderr)
    else:
        print("No empty folders found.", file=sys.stderr)


if __name__ == "__main__":
    main()
