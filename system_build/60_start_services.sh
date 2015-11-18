#!/bin/bash

service grafana-server stop
sleep 2
service opentsdb stop
sleep 2
service hbase-master stop
sleep 2

service hbase-master start
sleep 2
service opentsdb start
sleep 2
service grafana-server start
sleep 2


exit
