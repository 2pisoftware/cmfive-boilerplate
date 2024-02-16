#!/bin/bash

# ================================================================
# Entry point for the container
# ================================================================

echo "zend_extension=xdebug.so" > /etc/php/8.1/fpm/conf.d/20-xdebug.ini \
	&& echo "[xdebug]" >> /etc/php/8.1/fpm/conf.d/20-xdebug.ini  \
	&& echo "xdebug.mode=debug,develop" >> /etc/php/8.1/fpm/conf.d/20-xdebug.ini  \
	&& echo "xdebug.discover_client_host=true" >> /etc/php/8.1/fpm/conf.d/20-xdebug.ini  \
	&& echo "xdebug.max_nesting_level=250" >> /etc/php/8.1/fpm/conf.d/20-xdebug.ini  \
	&& echo "xdebug.start_with_request=yes" >> /etc/php/8.1/fpm/conf.d/20-xdebug.ini 

supervisord -n -c /etc/supervisord.conf