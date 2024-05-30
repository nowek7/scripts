#!/bin/python3

import os
import platform
from typing import Iterable, Iterator

SKIPPED_DIRS = frozenset(('.git', '.vscode', '_input', '_Plik_wzorcowy',
                          '999_scripts', '00_planimetria'))


REMOVED_EXTS = frozenset(('.log', '.table', '.aux', '.cdr', '.out', '.gnuplot', '.toc', '.blg', '.bbl',
                          '.synctex(busy)', '.synctex.gz', '.dvi'))

COMPILATION_OPTS = frozenset((
    '-halt-on-error',
    '--c-style-errors',
    '--shell-escape',
    '--time-statistics',
    '--interaction=errorstopmode',
    '--file-line-error',
    '--synctex=-1',
    '--quiet'
))

def skipped_dir(dirs: list[str]) -> bool:
    return any(skip_dir in dirs for skip_dir in SKIPPED_DIRS)

def skip_files(paths: Iterable) -> bool:
    return filter(lambda name: name.endswith('.tex'), paths)

def find_tex_files() -> Iterator[str]:
    for root, _, files in os.walk('.'):
        if skipped_dir(root):
            continue

        filtered_names = skip_files(files)
        for name in filtered_names:
            yield (root, name)

def getCompiler() -> str:
    system_name = platform.system()
    if system_name == 'Windows':
        return 'pdflatex.exe'
    elif system_name == 'Linux':
        return 'pdflatex'
    else:
        raise ValueError('Not supported OS!')

def compile(compiler: str, root: str, tex_file: str) -> int:
    aux_directory = f'-aux-directory {root}'
    output_directory = f'-output-directory {root}'

    command = f'''
        {compiler} \
        {' '.join(COMPILATION_OPTS)} \
        {aux_directory} \
        {output_directory} \
        "{tex_file}"'''
    return os.system(command)

def remove_output_files(root: str) -> None:
    if root == '.':
        return None

    for file in os.listdir(root):
        ext = os.path.splitext(file)[1]
        if ext in REMOVED_EXTS:
            os.remove(os.path.join(root, file))

if __name__ == '__main__':
    compiler = getCompiler()
    results = {'success': [], 'failure': []}
    for root, tex_file in find_tex_files():
        try:
            full_path = os.path.join(root, tex_file)

            os.chmod(full_path, 0o777)
            res = compile(compiler, root, full_path)
            if res == 1:
                results['failure'].append(full_path)
            else:
                results['success'].append(full_path)

            remove_output_files(root)

        except Exception as err:
            print(f'{tex_file} - {err.args}')
            results['failure'].append(full_path)
            pass

    with open('tex_files_to_fix.txt', 'w') as file:
        file.write('\n'.join(results['failure']))

    with open('compiled_tex_files.txt', 'w') as file:
        file.write('\n'.join(results['success']))

