import os
import subprocess
import logging

logger = logging.getLogger(__name__)


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
