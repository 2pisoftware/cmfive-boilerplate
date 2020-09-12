"""
Traverse all dirs and files under .build and inflate files with the '.templat'
extention by substiting the php version.
"""
from jinja2 import Template
from pathlib import Path
import sys


EXTENSION = ".template"


def substitute_tokens(fpath, tokens):
    with fpath.open() as fp:
        template = Template(fp.read())

    return template.render(tokens)


def create_file(fpath, contents):
    filename = str(fpath).replace(EXTENSION, "")
    with open(filename, "w") as fp:
        fp.write(contents)


def inflate_template(fpath, tokens):
    # ignore
    if not fpath.name.endswith(EXTENSION):
        return

    # step 1
    contents = substitute_tokens(fpath, tokens)

    # step 2
    create_file(fpath, contents)


def preprocess(target, tokens):
    # traverse all dirs and files
    for p in target.iterdir():
        if p.is_dir():
            preprocess(p, tokens)
        if p.is_file():
            inflate_template(p, tokens)


def parse_cli_input():
    cli_arg = sys.argv[1].split('=')
    return {cli_arg[0]: cli_arg[1]}


if __name__ == "__main__":
    root = Path("").expanduser().resolve()
    tokens = parse_cli_input()
    preprocess(root, tokens)