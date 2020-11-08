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


# load context
with open(CWD.joinpath('..', 'manifest')) as fp:
    reader = csv.reader(fp, delimiter=',')
    for row in reader:
        region, account_id, docker_image = row
        break

# steps
def login_to_ecr():
    output = run(f"aws ecr get-login-password --region {region} | docker login --username AWS --password-stdin {account_id}.dkr.ecr.{region}.amazonaws.com")
    logger.info(output)

def pull_image():
    output = run(f"docker pull {docker_image}")
    logger.info(output)

def run_container():
    output = run(f"docker run -d -p 3000:3000 {docker_image}")
    logger.info(output)

login_to_ecr()
pull_image()
run_container()
