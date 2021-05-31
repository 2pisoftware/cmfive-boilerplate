#!/bin/bash

pwd >> /home/ubuntu/temp-after-install.txt
ls -la >> /home/ubuntu/temp-after-install1.txt
cd /var/www/cmfive-boilerplate
pwd >> /home/ubuntu/temp-after-instal2.txt
ls -la >> /home/ubuntu/temp-after-install3.txt
chown -R ubuntu:ubuntu $(pwd)