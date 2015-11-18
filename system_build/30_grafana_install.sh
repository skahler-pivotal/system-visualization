#!/bin/bash

curl -s https://packagecloud.io/install/repositories/grafana/stable/script.rpm.sh | sudo bash
yum install -y grafana
