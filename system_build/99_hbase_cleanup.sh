#!/bin/bash

echo "truncate 'tsdb'" | hbase shell
echo "truncate 'tsdb-meta'" | hbase shell
echo "truncate 'tsdb-tree'" | hbase shell
echo "truncate 'tsdb-uid'" | hbase shell
sleep 10
service hbase-master stop
sleep 10
service hbase-master start
