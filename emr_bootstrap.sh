#!/usr/bin/env bash

INSTALL_COMMAND="sudo python3 -m pip install"
dependencies="numpy pandas slackclient pyarrow boto3 botocore py4j python-memcached redis"

sudo yum install -y python3-pip gcc
for dep in $dependencies; do
    $INSTALL_COMMAND $dep
done;
