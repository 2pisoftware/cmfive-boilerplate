"""
todo:
- add logging
- test status codes on cmfive.php for database migrtion failure
- environment variable override
- make command run exceptions less generic
- review file permissions
"""
from jinja2 import Template
import yaml
import click
import subprocess
import os
import sys
import json
import time
from pathlib import Path


# ---------------
# Utiltiy Methods
# ---------------
def cwd_dir():
    return Path(__file__).expanduser().resolve().parent


def root_dir():
    return cwd_dir().joinpath(*[".." for _ in range(4)])


def run(command, container_name=None):
    os.environ['PYTHONUNBUFFERED'] = "1"

    if container_name:
        command = f"docker exec -it {container_name} {command}"

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


def create_file_in_root(filename, contents):
    with open(root_dir().joinpath(filename), "w") as fp:
        fp.write(contents)


def load_config():
    with open(cwd_dir().joinpath("config.yml"), "r") as fp:
        return yaml.load(fp, Loader=yaml.FullLoader)

config = load_config()


# -----------
# Application
# -----------
def db_container():
    return f"mysql-{config['mysql_suffix']}"


def web_container():
    return f"nginx-php{config['php_suffix']}"


def create_docker_compose_file():
    create_file_in_root(
        "docker-compose.yml",
        render_template(
            cwd_dir().joinpath("templates", "docker-compose.yml.template"),
            config,
        )
    )


def docker_compose_up():
    print('docker compose up')
    run('docker-compose up -d')


def create_cmfive_config_file():
    print('create cmfive config file')
    create_file_in_root(
        "config.php",
        render_template(
            cwd_dir().joinpath("templates", "config.php.template"),
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
    print('setup cmfive')
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


# ----------------------
# Command Line Interface
# ----------------------
@click.group()
def cli():
    pass


@cli.command('provision-test-env')
def provision_test_env():
    """provision test infrastructure to run cmfive test suits"""

    create_docker_compose_file()
    docker_compose_up()
    create_cmfive_config_file()
    create_database()
    install_test_packages()
    setup_cmfive()


@cli.command('teardown-env')
def provision_test_env():
    """provision test infrastructure to run cmfive test suits"""
    pass

if __name__ == '__main__':
    cli()
