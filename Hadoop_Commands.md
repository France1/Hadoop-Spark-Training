# Commonly used Hadoop commands

These examples are run using a [Cloudera Quickstart Docker image](https://hub.docker.com/r/cloudera/quickstart/). To install and use the dockerized version of Cloudera Quickstart refer to the README. 

Create the folder `/user/cloudera/practice` in HDFS, and copy the local file `/opt/examples/access.log.2into` within it. Then verify that the file has been copied
```
hdfs dfs -mkdir /user/cloudera/practice
hdfs dfs -copyFromLocal /opt/examples/log_files/access.log.2 /user/cloudera/practice
hdfs dfs -ls /user/cloudera/practice
```

Explore the entire content of the file, or only the end of it
```
hdfs dfs -cat /user/cloudera/practice/access.log.2
hdfs dfs -tail /user/cloudera/practice/access.log.2
```

Move the file into the new directory `new-practice`
```
hdfs dfs -mkdir /user/cloudera/new-practice
hdfs dfs -mv /user/cloudera/practice/access.log.2 /user/cloudera/new-practice 
```

Remove the directory and files in within it
```
hdfs dfs -rm -r /user/cloudera/new-practice
```

Copy file from HDFS to the local directory `/home/`
```
hdfs dfs -copyToLocal /user/cloudera/practice/access.log.2 /home/
```
