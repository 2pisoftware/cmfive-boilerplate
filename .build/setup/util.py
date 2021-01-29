"""
<description>
"""
from distutils import dir_util
from pathlib import Path
from importlib import import_module
from jinja2 import Template, StrictUndefined, Environment, BaseLoader
from jinja2.exceptions import UndefinedError
import logging
import os
import sys
import json
import textwrap
import subprocess

logger = logging.getLogger(__name__)


def run(command, container_name=None):
    os.environ['PYTHONUNBUFFERED'] = "1"

    if container_name:
        command = f"docker exec {container_name} {command}"

    # run command
    logger.debug(f"command: {command}")
    proc = subprocess.Popen(
        command,
        shell=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE
    )
    stdout, stderr = [output.decode("utf-8").strip() for output in proc.communicate()]

    # parse result
    if proc.returncode != 0:
        default = "Unable to execute command"
        error = next(_ for _ in (stderr, stdout, default) if _ != "")
        raise Exception(error)

    logger.debug(f"command output: {stdout}, {stderr}, {proc.returncode}")
    return stdout, stderr, proc.returncode


def delete_dir(target):
    try:
        dir_util.remove_tree(target)
    except FileNotFoundError:
        pass


def copy_dirs(source, target):
    dir_util.copy_tree(str(source), str(target))


def render_template(fpath, tokens):
    with fpath.open() as fp:
        try:
            environment = Environment(loader=BaseLoader)
            environment.filters["fromjson"] = lambda value: json.loads(value)
            template = environment.from_string(fp.read())            
            result = template.render(tokens, undefined=StrictUndefined)
        except UndefinedError as exc:
            raise Exception(f"template placeholder token is missing - {fpath}") from exc

        return result


def inflate_template(filepath, destination, extension, tokens, remove):
    # ignore
    if not filepath.name.endswith(extension):
        return

    # render template
    contents = render_template(filepath, tokens)

    # generate file from template without extension
    filename = filepath.name.replace(extension, "")
    with open(destination.joinpath(filename), "w") as fp:
        fp.write(contents)

    # delete template
    if remove:
        filepath.unlink()


def inflate_templates(target, extension, tokens, remove):
    # traverse all dirs and files
    for p in target.iterdir():
        if p.is_dir():
            inflate_templates(p, extension, tokens, remove)
        if p.is_file():
            inflate_template(p, p.parent, extension, tokens, remove)


def run_scripts(filepath, entrypoint):
    # normalize
    filepath = Path(filepath)

    # opt-out
    if not filepath.exists():
        return

    # load and run scripts
    sys.path.append(str(filepath))
    for p in filepath.iterdir():        
        if p.suffix != ".py":
            continue
        logger.info(f"load and run script '{p.name}'")        
        function = getattr(import_module(p.stem), entrypoint)

        # invoke
        function()


def create_directory_structure(dirpath, exclude_file):
    # remove file from 'dirpath'
    if exclude_file:        
        dirpath.parents[0].mkdir(parents=True, exist_ok=True)
    # assumed 'dirpath' is a directory structure
    else:        
        dirpath.mkdir(parents=True, exist_ok=True)


def write_to_file(filepath, content):
    create_directory_structure(filepath, True)
    with open(filepath, "w") as fp:
        fp.write(content)


def dedent_multiline_string(content, remove_firstline):
    content = textwrap.dedent(content)
    if remove_firstline:
        content = "\n".join(content.split('\n')[1:])
    
    return content