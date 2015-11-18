#!/bin/bash

wget -O /etc/yum.repos.d/bigtop.repo http://archive.apache.org/dist/bigtop/bigtop-1.0.0/repos/centos6/bigtop.repo
yum install -y hbase hbase-master

