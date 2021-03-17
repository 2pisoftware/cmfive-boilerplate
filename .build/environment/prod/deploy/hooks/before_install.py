#!/usr/bin/python3

from pathlib import Path
import csv
import os
import subprocess
import logging


# init logger
logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)

CWD = Path(__file__).expanduser().resolve().parent


def run(command):
    os.environ['PYTHONUNBUFFERED'] = "1"

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


def parse_stdout(stdout):
    return (_ for _ in stdout.split("\n") if _ != "")


def running_containers():
    stdout, _, _ = run("docker container ls -q")
    return parse_stdout(stdout)


def stopped_containers():
    stdout, _, _ = run("docker container ls -qa")
    return parse_stdout(stdout)


def images():
    stdout, _, _ = run("docker image ls -qa")
    return parse_stdout(stdout)


def stop_all_containers():
    for container in running_containers():
        output = run(f"docker container stop {container}")
        logger.info(output)


def remove_all_containers():
    for container in stopped_containers():
        output = run(f"docker container rm {container}")
        logger.info(output)


def remove_all_images():
    for image in images():
        output = run(f"docker image rm {image}")
        logger.info(output)


stop_all_containers()
remove_all_containers()
remove_all_images()