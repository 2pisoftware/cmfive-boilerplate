from docker import DockerCompose
from resolver.app import run_actions
import pathlib
import logging

logger = logging.getLogger(__name__)


def get_module_names(context):    
    for p in pathlib.Path(context.dirs.root.joinpath("modules")).iterdir():
        if p.is_dir():
            yield p


def install_crm_modules(context, service):    
    # places cmfive modules in the modules directory on filesystem
    run_actions(context.dirs.env.joinpath("config.yml"))
    
    # copy modules from filesystem into running container
    for module in get_module_names(context):
        for container in DockerCompose.containers_by_service(service):
            container.copy_into(
                source=module,
                target=f"/var/www/html/modules/{module.name}"
            )
