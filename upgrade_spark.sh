cd /home

# default java version is 1.7 but spark 2.4 requires java 1.8
sudo yum remove java -y
sudo yum install java-1.8.0-openjdk -y
export JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk.x86_64

# download spark 2.4
yum install wget -y
wget https://archive.apache.org/dist/spark/spark-2.4.0/spark-2.4.0-bin-hadoop2.6.tgz
tar -xvzf spark-2.4.0-bin-hadoop2.6.tgz 
mv spark-2.4.0-bin-hadoop2.6 spark_2

# set PATH to new directory
# export PATH=/home/spark_2/bin:$PATH
echo 'export PATH=/home/spark_2/bin:$PATH'  >> ~/.bash_profile
echo 'source ~/.bash_profile' 

# copy data into hdfs
hdfs dfs -mkdir /user/cloudera/
hdfs dfs -copyFromLocal /cloudera/Udemy-CCA175/data /user/cloudera 
