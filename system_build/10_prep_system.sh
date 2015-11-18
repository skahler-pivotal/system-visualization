#!/bin/bash

yum install -y mdadm xfsprogs
yum install -y perl-CPAN

perl -MCPAN -e 'install Date::Parse'
