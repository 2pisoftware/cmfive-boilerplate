class RequestUnhandled(Exception):
    pass


class Database:    
    def __init__(self):        
        self.proxies = []
     
    def add_proxy(self, proxy):        
        self.proxies.append(proxy)
        proxy.database = proxy

    def get(self, key):        
        for proxy in self.proxies:
            try:
                value = proxy.get(key)                
            except RequestUnhandled:
                continue
            else:
                return value
        else:
            raise Exception(f"get request for '{key}' is unhandled")

    def get_all(self):            
        result = {}
        for proxy in self.proxies:
            proxy.get_all(result)
        
        return result

    def put(self, key, value):        
        for proxy in self.proxies:
            try:
                proxy.put(key, value)                
            except RequestUnhandled:
                continue
            else:
                break
        else:
            raise Exception(f"put request for '{key}' is unhandled")

    def put_all(self, data):
        for key, value in data.items():
            self.put(key, value)
