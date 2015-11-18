
System Acitivty Review Visualization Tools

This is a set of programs to get some tools up and running that will
allow someone to review cluster activity at a hardware level and from
the data that has been recorded in the GPDB perfmon database.

The tools used are HBase, OpenTSDB and Grafana

Included are scripts to get these tools up and running.

An AMI with them pre-installed is located in us-east as ami-d22560b8

Also included are a set of script to import:
- gpdb system_history
- gpdb database_history
- sar logs
- tpcds query runs

This is a first go at this to see if there is any stickyness or need for these tools
