#!/bin/python3

import argparse
import os
from typing import Iterable, Iterator
import re

SKIPPED_DIRS = frozenset(('.git', '.vscode'))

def skipped_dir(dir: list) -> bool:
    return any(skip_dir in dir.split(os.sep) for skip_dir in SKIPPED_DIRS)

def skip_files(paths: Iterable) -> bool:
    return filter(lambda name: name.endswith('.tex'), paths)

def find_tex_files(directory: str) -> Iterator[str]:
    directory = os.path.abspath(directory)
    for root, _, files in os.walk(directory):
        if skipped_dir(root):
            continue

        filtered_names = skip_files(files)
        for name in filtered_names:
            yield os.path.join(root, name)

def replace_double_dollars(path: str) -> None:
    with open(path, 'r+', encoding='utf-8') as tex_file:
        content = tex_file.read()

        # Trailing whitespaces
        content = content.strip()

        # Find and replace double dollars
        regex = r'(\$\$)([^\$]*)(\$\$)'
        content = re.sub(regex, r'\\[ \2 \\]', content)

        tex_file.seek(0)
        tex_file.write(content)
        tex_file.truncate()

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Process .tex files to replace double dollars with brackets.")
    parser.add_argument('-d', '--directory', type=str, help="Directory to start searching for .tex files.", required=True)
    args = parser.parse_args()

    for tex_file in find_tex_files(args.directory):
        print(f'Processing {tex_file}')
        try:
            replace_double_dollars(tex_file)
            print(f'Replaced double dollars in {tex_file}')
        except UnicodeDecodeError as error:
            print(f'{tex_file} -> {str(error)}')
