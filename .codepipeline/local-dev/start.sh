#!/bin/bash

# ./test/.install/install.sh

#setup for XDebug

if ping -c 1 host.docker.internal; then INTERNAL_HOST_IP=host.docker.internal; \
	else	if ping -c 1 docker.for.mac.localhost; then INTERNAL_HOST_IP=docker.for.mac.localhost; \
	else		if ping -c 1 docker.for.win.localhost; then INTERNAL_HOST_IP=docker.for.win.localhost; \
	else INTERNAL_HOST_IP=$(ip route show default | awk '/default/ {print $3}'); fi; fi; fi;


## Alternate working setup:
# zend_extension=xdebug.so
# xdebug.mode=debug
# xdebug.client_host=${INTERNAL_HOST_IP}
# xdebug.remote_connect_back=On
# xdebug.client_port=9003
# xdebug.remote_handler=dbgp
# xdebug.start_with_request=yes
# xdebug.remote_log=/tmp/xdebug.log


echo "zend_extension=xdebug.so" > /etc/php/8.1/fpm/conf.d/20-xdebug.ini \
	&& echo "[xdebug]" >> /etc/php/8.1/fpm/conf.d/20-xdebug.ini \
	&& echo "xdebug.remote_enable=1" >> /etc/php/8.1/fpm/conf.d/20-xdebug.ini \
	&& echo "xdebug.client_host=${INTERNAL_HOST_IP}" >> /etc/php/8.1/fpm/conf.d/20-xdebug.ini \
	&& echo "xdebug.client_port=9003" >> /etc/php/8.1/fpm/conf.d/20-xdebug.ini \
	&& echo "xdebug.remote_connect_back=0" >> /etc/php/8.1/fpm/conf.d/20-xdebug.ini \
	&& echo "xdebug.remote_autostart=1" >> /etc/php/8.1/fpm/conf.d/20-xdebug.ini \
	&& echo "xdebug.remote_handler=dbgp" >> /etc/php/8.1/fpm/conf.d/20-xdebug.ini \
	&& echo "xdebug.max_nesting_level=250" >> /etc/php/8.1/fpm/conf.d/20-xdebug.ini \
	&& echo "xdebug.mode=debug" >> /etc/php/8.1/fpm/conf.d/20-xdebug.ini


supervisord -n -c /etc/supervisord.conf