import logging
from common import init_singletons
from docker import DockerCompose
from cmfive import CmfiveDevelopment, CmfiveProduction
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
    # provision cmfive instance
    logger.info('provision cmfive instance')
    cmfive = CmfiveProduction.create()
    cmfive.setup()            

    # snapshot web container
    logger.info('snapshot web container')
    WebService.snapshot_container(tag)

    # teardown cmfive instance
    logger.info('teardown cmfive instance')
    DockerCompose().down()