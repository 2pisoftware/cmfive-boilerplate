#!/bin/bash

while read a; do
    echo ${a//docker.for.mac.localhost/172.18.0.1}
done < /etc/php/7.4/fpm/conf.d/20-xdebug.ini > /etc/php/7.4/fpm/conf.d/20-xdebug.ini.t
mv /etc/php/7.4/fpm/conf.d/20-xdebug.ini{.t,}

service php7.4-fpm restart
