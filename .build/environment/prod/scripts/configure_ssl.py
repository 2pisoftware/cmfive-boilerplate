import json
import logging
from common import ConfigManager
from docker import DockerCompose
from service.web import WebService

logger = logging.getLogger(__name__)


def main():
    install_certbot()
    request_certificate()


def install_certbot():
    logger.info("install certbot")
    run("add-apt-repository ppa:certbot/certbot -y")
    run("apt install python3-certbot-nginx -y")


def request_certificate():
    logger.info("request ssl certificate")    
    config = ConfigManager.instance().config    
    run("certbot --nginx {} --non-interactive --agree-tos --redirect -m {}".format(
        " ".join(f"-d {_}" for _ in json.loads(config['site_domains'])),
        config['certbot_webmaster']
    ))


def run(command):
    """run command against service container(s)"""
    for container in DockerCompose.containers_by_service(WebService.SERVICE_NAME):
        container.run_command(command)
