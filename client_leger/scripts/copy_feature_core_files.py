#!/usr/bin/env python3

import os
import shutil

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.normpath(os.path.join(SCRIPT_DIR, ".."))
LIB = os.path.join(ROOT, "lib")
OUTPUT_DIR = os.path.join(SCRIPT_DIR, "feature_core_export")


def _collect_coordinators() -> list[str]:
    out: list[str] = []
    for dirpath, _dirnames, filenames in os.walk(LIB):
        if os.path.basename(dirpath) != "coordinators":
            continue
        for f in filenames:
            if f.endswith(".dart"):
                out.append(os.path.join(dirpath, f))
    return out


def _collect_app_transition() -> list[str]:
    app_transition_dir = os.path.join(LIB, "core", "app_transition")
    if not os.path.isdir(app_transition_dir):
        return []
    out: list[str] = []
    for name in os.listdir(app_transition_dir):
        path = os.path.join(app_transition_dir, name)
        if os.path.isfile(path) and name.endswith(".dart"):
            out.append(path)
    return out


def main() -> None:
    all_sources: list[str] = []
    all_sources.extend(_collect_coordinators())
    all_sources.extend(_collect_app_transition())
    if os.path.isdir(OUTPUT_DIR):
        shutil.rmtree(OUTPUT_DIR)
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    for src in all_sources:
        name = os.path.basename(src)
        dest = os.path.join(OUTPUT_DIR, name)
        shutil.copy2(src, dest)
        print(name)
    print(f"Copied {len(all_sources)} files to {OUTPUT_DIR}")


if __name__ == "__main__":
    main()
