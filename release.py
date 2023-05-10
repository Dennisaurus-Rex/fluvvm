from yaml import safe_load, safe_dump
from git import Repo
import argparse
import sys
import re

repo = Repo('.')
tag = repo.git.describe('--tags', '--abbrev=0')
new_release = re.sub(r'[a-zA-Z]', '', tag)
print(new_release)
new_release.replace('v', '')
print(new_release)
regex = re.compile('^[1-9]+\.([0-9]{1}|[1-9][0-9]+)\.([0-9]{1}|[1-9][0-9]+)$')
match = re.match(regex, new_release)

if match is None:
    print('invalid version number')
    exit(1)

with open('pubspec.yaml', 'r') as file:
    data = safe_load(file)
    file.close()

latest_release = data['version']

print(latest_release + ' -> ' + new_release)
    
print('creating release ' + new_release)
data['version'] = new_release

# Open the YAML file for writing
with open('pubspec.yaml', 'w') as file:
    safe_dump(data, file, sort_keys=False)
    file.close()

print('release ' + new_release + ' created')
