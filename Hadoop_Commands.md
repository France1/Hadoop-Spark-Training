# Commonly used Hadoop commands

These examples are run using a [Cloudera Quickstart Docker image](https://hub.docker.com/r/cloudera/quickstart/). To install and use the dockerized version of Cloudera Quickstart refer to the README. 

Copy the local file `access.log.2into`, which is contained into the folder `/opt/examples/`, into HDFS. Then verify that it has been copied
```
hdfs dfs -put /opt/examples/log_files/access.log.2 /user/cloudera/practice
hdfs dfs -ls /user/cloudera/practice
```


