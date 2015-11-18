#!/bin/bash

yum install -y gnuplot
rpm -ivh https://github.com/OpenTSDB/opentsdb/releases/download/v2.1.2/opentsdb-2.1.2.noarch.rpm
echo 'tsd.core.auto_create_metrics = true' >> /etc/opentsdb/opentsdb.conf
echo 'tsd.storage.fix_dulicates = true' >> /etc/opentsdb/opentsdb.conf
