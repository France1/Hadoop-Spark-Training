# Commonly used Hadoop commands

These examples are run using a [Cloudera Quickstart Docker image](https://hub.docker.com/r/cloudera/quickstart/). To install and use the dockerized version of Cloudera Quickstart refer to the README. 

Copy a local file into HDFS, and verify that it has been copied
```
hdfs dfs -put /opt/examples/log_files/access.log.2 /user/cloudera/practice
hdfs dfs -ls /user/cloudera/practice
```


