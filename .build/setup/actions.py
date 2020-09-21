import logging
from common import init_singletons
from docker import DockerCompose
from cmfive import CmfiveDevelopment
from service.web import WebService
import util

logger = logging.getLogger(__name__)


def update_default():
    init_singletons("default", True)
    DockerCompose().init_environment()


def provision_dev():
    cmfive = CmfiveDevelopment.create()
    cmfive.setup()


def create_production_image(tag):
    # init
    init_singletons("prod", False)
    docker = DockerCompose()
    docker.init_environment()

    # build image       
    logger.info(f"build image '{WebService.image_name()}'")
    docker.build()

    # tag image
    logger.info(f"tag image '{WebService.image_name()}'")
    WebService.tag_image(tag)
