# Hadoop-Spark-Training
Tutorials and example code to prepare for Cloudera "CCA Spark and Hadoop Developer" Certification

All the examples and exercises are run using [Cloudera QuickStart Docker Image](https://hub.docker.com/r/cloudera/quickstart/). It is recommended to increase the RAM used by Docker in Preferences->Advanced to at least 8 GiB as well as the number of CPUs (I am currently using 6). 

To start the Docker image run
```
docker run --hostname=quickstart.cloudera --privileged=true -it \
-v $(pwd):/cloudera -p 8888:8888 -p 80:80 \
cloudera/quickstart /usr/bin/docker-quickstart
```
Cloudera Live VM can be accessed at `localhost:80` and Hue at `localhost:8888` using `admin` for both username and password.

To upgrade to Spark 2.4
```
./cloudera/upgrade_spark.sh
source ~/.bash_profile
```

### Other references
- [Exam content and tips 2020](https://towardsdatascience.com/clouderas-cca-175-the-2020-update-what-changed-what-didn-t-and-how-to-prepare-for-the-exam-716413ff1f15)
- [Cloudera new exam environment](https://ondemand.cloudera.com/courses/course-v1:Cloudera+CertPrep+101/courseware/f39b99b8d41849beb5b2453d539059fe/e4ae1c3be51349e685f5dc016fabd3a9/?activate_block_id=block-v1%3ACloudera%2BCertPrep%2B101%2Btype%40sequential%2Bblock%40e4ae1c3be51349e685f5dc016fabd3a9)
