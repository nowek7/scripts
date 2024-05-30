from datetime import datetime
import json
import subprocess
import os

DESTINATION_FILE = 'build_info.json'

def get_build_date() -> str:
    return datetime.now().strftime('%Y-%m-%d %H:%M:%S')

def is_git_repository() -> bool:
    return os.path.isdir(os.path.join(os.getcwd(), '.git'))

def get_branch_name() -> str:
    """Return the current Git branch name."""

    try:
        return subprocess.check_output(['git', 'rev-parse', '--abbrev-ref', 'HEAD']).decode("utf8").strip()
    except subprocess.CalledProcessError as e:
        print("Error: Unable to get the branch name.")
        print(e.output.decode("utf8"))
        return ""

def get_last_commit_date() -> str:
    """Return the date of the last commit in ISO 8601 format."""

    try:
        return subprocess.check_output(['git', 'log', '-1', '--date=iso8601-strict', '--pretty=format:%cd']).decode("utf8").strip()
    except subprocess.CalledProcessError as e:
        print("Error: Unable to get the last commit date.")
        print(e.output.decode("utf8"))
        return ""

def get_last_commit_hash() -> str:
    """Return the hash of the last commit."""

    try:
        return subprocess.check_output(['git', 'rev-parse', 'HEAD']).decode("utf8").strip()
    except subprocess.CalledProcessError as e:
        print("Error: Unable to get the last commit hash.")
        print(e.output.decode("utf8"))
        return ""

def get_last_commit_tag() -> str:
    """Return the tag name of the last commit."""

    try:
        return subprocess.check_output(['git', 'describe', '--tags', '--abbrev=0'], stderr=subprocess.STDOUT).decode('utf8').strip()
    except subprocess.CalledProcessError as ex:
        print(f"Error: Unable to get the last commit tag - {ex.output.decode('utf8')}")
        return ""

def get_repository_info() -> dict:
    if is_git_repository():
        return {
            'buildDate': get_build_date(),
            'gitBranch': get_branch_name(),
            'gitDate': get_last_commit_date(),
            'gitHash': get_last_commit_hash(),
            'gitTag': get_last_commit_tag()
        }
    else:
        return {}

if __name__ == '__main__':
    repository_info = get_repository_info()
    with open(f'{DESTINATION_FILE}', 'w', encoding='utf-8') as file:
        json.dump(repository_info, file, ensure_ascii=False, indent=2)
