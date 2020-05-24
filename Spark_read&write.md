# Spark read and write files in different formats

Spark uses [DataFrameReader](https://spark.apache.org/docs/latest/api/scala/index.html#org.apache.spark.sql.DataFrameReader) to load different types of data sources from external storage into a dataframe, and [DataFrameWriter](https://spark.apache.org/docs/latest/api/scala/index.html#org.apache.spark.sql.DataFrameWriter
) to save a dataframe to external storage. In order to read and write files we first create a folder in HDFS
```
hdfs dfs hdfs dfs -mkdir /user/cloudera/spark_io
```

### Load data from MySQL database
Cloudera VM installation contains the popular *retail_db* dataset inside a MySQL database. To connect spark to MySQL first download [MySQL driver](https://dev.mysql.com/downloads/connector/j/5.1.html) into the `drivers` folder. Then make it available to Spark shell
```
spark-shell --driver-class-path drivers/mysql-connector-java-5.1.48/mysql-connector-java-5.1.48-bin.jar 
```
then read for instance `orders` table from database as
```
val df = spark.read.format("jdbc").
option("url", "jdbc:mysql://quickstart:3306/retail_db").
option("dbtable", "orders").
option("user", "root").
option("password", "cloudera").
load()
```
#### Write dataframe to json format 
Write data into `json` folder inside the HDFS folder
```
df.write.json("hdfs://quickstart.cloudera/user/cloudera/spark_io/json")
```
Verify that data has been written into HDFS
```
hdfs dfs -ls /user/cloudera/spark_io/json/
hdfs dfs -cat /user/cloudera/spark_io/json/part-00000-1e355657-cb40-4cac-965c-9f7b8663342c-c000.json
```

#### Text:
```
val df = spark.read.text("read-path.txt")
df = spark.write.text("write-path.txt")
```
#### CSV:
```
val df = spark.read.csv("read-path.csv")
df = spark.write.csv("write-path.csv")
```
#### JSON:
```
val df = spark.read.json("read-path.json")
df = spark.write.json("write-path.json")
```
#### Parquet:
```
val df = spark.read.parquet("read-path.parquet")
df = spark.write.csv("write-path.parquet")
```
#### Avro
Include the spark avro in the dependencies for the current scala version `2.11`, and spark version `2.4.0`
```
spark-shell --packages org.apache.spark:spark-avro_2.11:2.4.0
```
then read/write files as
```
val df = spark.read.format("avro").load("read-path.avro")
df.write.format("avro").save("write-path.avro")
df.write.format("com.databricks.spark.avro").saveAsTable(hivedb.hivetable_avro)
```
  


