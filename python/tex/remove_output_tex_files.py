#!/bin/python3

import os
from pathlib import Path
from typing import Iterable, Iterator

SKIPPED_DIRS = frozenset(('.git', '.vscode', '_input', '_Plik_wzorcowy',
                          '999_scripts'))
REMOVED_EXTS = frozenset(('.log', '.table', '.aux', '.cdr', '.out', '.gnuplot', '.toc', '.blg', '.bbl',
                          '.synctex(busy)', '.synctex.gz', '.dvi'))

def skipped_dir(dirs: list[str]) -> bool:
    return any(skip_dir in dirs for skip_dir in SKIPPED_DIRS)

def skip_file(path: str) -> bool:
    return any(path.endswith(ext) for ext in REMOVED_EXTS)

def skip_files(paths: Iterable) -> bool:
    return filter(skip_file, paths)

def find_output_files() -> Iterator[str]:
    for root, dirs, files in os.walk('.'):
        if skipped_dir(root):
            continue

        filtered_names = skip_files(files)
        for name in filtered_names:
            yield os.path.join(root, name)

def remove_output_file(path: str) -> None:
    file = Path(path)
    if file.exists():
        os.chmod(file, 0o777)
        file.unlink()

if __name__ == '__main__':
    for output_file in find_output_files():
        try:
            remove_output_file(output_file)
            print(f'Removed {output_file}')
        except UnicodeDecodeError as error:
            print(f'{output_file} -> {str(error)}')
