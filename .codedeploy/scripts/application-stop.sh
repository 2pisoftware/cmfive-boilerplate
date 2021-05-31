#/bin/bash

pwd >> /home/ubuntu/temp.txt
ls >> /home/ubuntu/temp1.txt

if [ -d "/var/www/cmfive-boilerplate" ]; then
    cd /var/www/cmfive-boilerplate
    pwd >> /home/ubuntu/temp2.txt
    ls >> /home/ubuntu/temp3.txt
    docker-compose down
fi