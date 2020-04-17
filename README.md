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
