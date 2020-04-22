#!/bin/bash
set -e
hdfs dfs -mkdir       /tmp
hdfs dfs -mkdir       /user
hdfs dfs -mkdir       /user/hive
hdfs dfs -mkdir       /user/hive/warehouse
hdfs dfs -chmod g+w   /tmp
hdfs dfs -chmod g+w   /user/hive/warehouse