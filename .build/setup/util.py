"""
<description>
"""
from distutils import dir_util
import os
import subprocess
from jinja2 import Template, StrictUndefined
from jinja2.exceptions import UndefinedError
import logging

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
            template = Template(fp.read(), undefined=StrictUndefined)
            result = template.render(tokens)
        except UndefinedError as exc:
            raise Exception("template placeholder token is missing") from exc

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
