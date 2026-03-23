#!/usr/bin/env python3
"""Output the union of folder structures of all features in lib/features as an ASCII tree."""

from pathlib import Path


def collect_dirs_under(root: Path) -> set[str]:
    out: set[str] = set()
    for p in root.rglob("*"):
        if p.is_dir():
            rel = p.relative_to(root)
            out.add(str(rel).replace("\\", "/"))
    return out


def path_parts(path_str: str) -> list[str]:
    if not path_str:
        return []
    return path_str.split("/")


def add_to_tree(tree: dict, parts: list[str]) -> None:
    if not parts:
        return
    head, rest = parts[0], parts[1:]
    if head not in tree:
        tree[head] = {}
    add_to_tree(tree[head], rest)


def paths_to_tree(paths: set[str]) -> dict:
    tree: dict = {}
    for p in sorted(paths):
        add_to_tree(tree, path_parts(p))
    return tree


def format_tree(
    tree: dict,
    prefix: str = "",
    is_last_sibling: bool = True,
) -> list[str]:
    lines: list[str] = []
    names = sorted(tree.keys())
    for i, name in enumerate(names):
        last = i == len(names) - 1
        connector = "\\-- " if last else "+-- "
        lines.append(prefix + connector + name)
        child_prefix = prefix + ("    " if last else "|   ")
        sub = format_tree(tree[name], child_prefix, last)
        lines.extend(sub)
    return lines


def main() -> None:
    script_dir = Path(__file__).resolve().parent
    features_dir = script_dir.parent / "lib" / "features"
    if not features_dir.is_dir():
        print(f"Features directory not found: {features_dir}")
        return
    all_paths: set[str] = set()
    for feature_path in sorted(features_dir.iterdir()):
        if feature_path.is_dir():
            all_paths |= collect_dirs_under(feature_path)
    tree = paths_to_tree(all_paths)
    print("features (union of all feature folder structures)")
    for line in format_tree(tree):
        print(line)


if __name__ == "__main__":
    main()
