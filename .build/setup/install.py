"""
todo:
- logging
- test status codes on cmfive.php for database migrtion failure
- environment variable override
- make command run exceptions less generic
- review file permissions
- jinja2 enforce substituion
- unit tests
- documentation
- pull out dev dependencies from prod setup
- review security
"""
from jinja2 import Template
import yaml
import click
import subprocess
import os
import sys
import json
import shutil
from distutils import dir_util
import time
from pathlib import Path


# ---------------
# Utiltiy Methods
# ---------------
def run(command, container_name=None):
    os.environ['PYTHONUNBUFFERED'] = "1"

    if container_name:
        command = f"docker exec {container_name} {command}"

    # run command
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

    return stdout, stderr, proc.returncode


def render_template(fpath, tokens):
    with fpath.open() as fp:
        template = Template(fp.read())

    return template.render(tokens)


def load_config(environment):
    with open(env_dir(environment).joinpath("config.yml"), "r") as fp:
        return yaml.load(fp, Loader=yaml.FullLoader)


def delete_dir(target):
    try:
        dir_util.remove_tree(target)
    except FileNotFoundError:
        pass


def copy_dirs(source, target):
    dir_util.copy_tree(str(source), str(target))


def inflate(fpath, contents, extension, in_place):
    # generate file from template without extension
    filename = str(fpath).replace(extension, "")
    with open(filename, "w") as fp:
        fp.write(contents)

    # delete template
    if in_place:
        fpath.unlink()


def inflate_template(fpath, extension, tokens, in_place):
    # ignore
    if not fpath.name.endswith(extension):
        return

    # step 1
    contents = render_template(fpath, tokens)

    # step 2
    inflate(fpath, contents, extension, in_place)


def inflate_templates(target, extension, tokens, in_place):
    # traverse all dirs and files
    for p in target.iterdir():
        if p.is_dir():
            inflate_templates(p, extension, tokens, in_place)
        if p.is_file():
            inflate_template(p, extension, tokens, in_place)

config = None


# -----------
# Application
# -----------
# directories
def cwd_dir():
    return Path(__file__).expanduser().resolve().parent


def root_dir():
    return cwd_dir().joinpath(*[".." for _ in range(2)])


def common_dir():
    return cwd_dir().joinpath("..", "common")


def env_dir(env):
    return cwd_dir().joinpath("..", "environment", env)


def stage_dir(env):
    return env_dir(env).joinpath("stage")


def cmfive_dir(env):
    return env_dir(env).joinpath("configs", "cmfive")


def docker_dir(env):
    return env_dir(env).joinpath("configs", "docker")


def image_dir(env):
    return env_dir(env).joinpath("configs", "image")


# container names
def db_container():
    return f"mysql-{config['mysql_suffix']}"


def web_container():
    return f"nginx-php{config['php_suffix']}"


# utility
def create_file_in_env(environment, filename, contents):
    with open(env_dir(environment).joinpath(filename), "w") as fp:
        fp.write(contents)


def create_file_in_root(filename, contents):
    with open(root_dir().joinpath(filename), "w") as fp:
        fp.write(contents)


# logic
def create_docker_compose_file(env):
    create_file_in_root(
        "docker-compose.yml",
        render_template(
            docker_dir(env).joinpath("docker-compose.yml.template"),
            dict(**config, environment=env),
        )
    )


def create_docker_file(env):
    create_file_in_env(
        env,
        "Dockerfile",
        render_template(
            docker_dir(env).joinpath("Dockerfile.template"),
            dict(**config, environment=env),
        )
    )


def add_docker_ignore_file(env):
    """try copy .dockerignore to root dir"""
    source = docker_dir(env).joinpath(".dockerignore")

    if source.exists():
        target = root_dir().joinpath(".dockerignore")
        target.write_text(source.read_text())


def create_stage_directory(env):
    """create temp stage dir for image configs"""
    delete_dir(stage_dir(env))
    copy_dirs(common_dir(), stage_dir(env))
    copy_dirs(image_dir(env), stage_dir(env))
    inflate_templates(stage_dir(env), ".template", config, True)


def create_docker_build_context(env):
    """prepare docker, docker-compose and image configs"""
    create_stage_directory(env)
    create_docker_compose_file(env)
    create_docker_file(env)
    add_docker_ignore_file(env)


def docker_compose_up():
    print('docker compose up')
    run('docker-compose up -d')


def create_cmfive_config_file(env):
    print('create cmfive config file')
    create_file_in_root(
        "config.php",
        render_template(
            cmfive_dir(env).joinpath("config.php.template"),
            dict(**config, db_hostname=db_container()),
        )
    )


def wait_for_database():
    command = 'mysql -u root -proot -e "SHOW STATUS;"'
    elapsed, timeout, increment = 0, 60, 10

    while elapsed < timeout:
        try:
            run(command, db_container())
        except:
            elapsed += increment
            time.sleep(increment)
        else:
            break
    else:
        raise Exception("mysql wait timeout")


def create_database():
    print('create database')
    wait_for_database()

    sql = """
        CREATE DATABASE {db_database};
        CREATE USER '{db_username}'@'%' IDENTIFIED BY '{db_password}';
        GRANT ALL PRIVILEGES ON {db_database}.* TO '{db_username}'@'%';
        FLUSH PRIVILEGES;
    """.format(**config)

    run(f'mysql -u root -proot -e "{sql}"', db_container())


def install_test_packages():
    print('install test packages')
    run("sh test/.install/install.sh", web_container())


def setup_cmfive():
    print('setup_cmfive')
    run("php cmfive.php install core", web_container())
    run("php cmfive.php seed encryption", web_container())
    run("php cmfive.php install migration", web_container())
    run("php cmfive.php seed admin '{}' '{}' '{}' '{}' '{}'".format(
        config['admin_username'],
        config['admin_password'],
        config['admin_email'],
        config['admin_login_username'],
        config['admin_login_password']
    ), web_container())

    # modify folder permissions
    run(f"chmod 777 -R cache storage uploads", web_container())


def provision_dev_env():
    env = "dev"

    # load environment configs
    global config
    config = load_config(env)

    # provision
    create_docker_build_context(env)
    create_cmfive_config_file(env)
    docker_compose_up()
    create_database()
    install_test_packages()
    setup_cmfive()


def provision_prod_env():
    env = "prod"

    # load environment configs
    global config
    config = load_config(env)

    # provision
    create_docker_build_context(env)
    create_cmfive_config_file(env)
    docker_compose_up()
    create_database()
    setup_cmfive()


# ----------------------
# Command Line Interface
# ----------------------
@click.group()
def cli():
    pass


@cli.command('update-env')
@click.argument('environment')
def update_env(environment):
    """update docker artifacts for environment"""

    # load environment configs
    global config
    config = load_config(environment)

    create_docker_build_context(environment)


@cli.command('provision-dev-env')
def provision_dev_env_cmd():
    """provision test infrastructure to run cmfive test suits"""
    provision_dev_env()


@cli.command('provision-prod-env')
def provision_prod_env_cmd():
    """provision test infrastructure to run cmfive test suits"""
    provision_prod_env()


@cli.command('create-prod-image')
@click.argument('name')
def create_prod_image(name):
    """snapshot container"""
    provision_prod_env()
    run(f"docker commit {web_container()} {name}")
    run(f"docker-compose down -v")


if __name__ == '__main__':
    cli()
