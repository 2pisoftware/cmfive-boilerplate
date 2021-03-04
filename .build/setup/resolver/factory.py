from .manifest_manager import ManifestManager
from .provider_manager import ProviderManager
from .resolver_manager import ResolverManager
from .actions import ActionManager, action_registry
from .dirs import Dirs
import resolver.database as db
import resolver.database_proxies as db_proxy


def init_proxies(manifest_manager, resolver_manager):
    # schema proxy
    yield db_proxy.SchemaDatabaseProxy(manifest_manager, resolver_manager)
        
    # proxies that require primary resolver
    if resolver_manager.is_primary_resolver_defined():
        resolver = resolver_manager.get_primary_resolver()
    
        # custom behavior proxy
        yield db_proxy.IntrinsicDatabaseProxy(
            manifest_manager, 
            resolver, 
            {ActionManager.IDENTIFIER: action_registry}
        )
    
        # non-schema proxy
        yield db_proxy.SchemalessDatabaseProxy(manifest_manager, resolver)


def init_database(dirs):    
    # init systems
    manifest_manager = ManifestManager(dirs)
    provider_manager = ProviderManager(manifest_manager, dirs)
    resolver_manager = ResolverManager(manifest_manager, provider_manager, dirs)    
    manifest_manager.load()    

    # init database
    database = db.Database()
    for proxy in init_proxies(manifest_manager, resolver_manager):
        database.add_proxy(proxy)

    return database


def init_action_manager(dirs):        
    database = init_database(dirs)
    return ActionManager(database, dirs)
