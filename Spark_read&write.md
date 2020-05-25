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
#### Write dataframe to Json format 
Write data into `json` folder inside the HDFS folder
```
df.write.json("hdfs://localhost/user/cloudera/spark_io/json")
```
Verify that data has been written into HDFS
```
hdfs dfs -ls /user/cloudera/spark_io/json/
hdfs dfs -cat /user/cloudera/spark_io/json/part-00000-1e355657-cb40-4cac-965c-9f7b8663342c-c000.json
```
### Load Json file
Import previously created json data into dataframe
```
val df_json = spark.read.json("hdfs://localhost/user/cloudera/spark_io/json")
```
this will import all json files within the directory `/user/cloudera/spark_io/json`
#### Write data frame to Parquet format
```
df_json.write.parquet("hdfs://localhost/user/cloudera/spark_io/parquet")
```
Verify that data has been written into HDFS - since parquet is compressed into binary format it is necessary to use `parquet-tools` to visualise the content of the file
```
hdfs dfs -ls /user/cloudera/spark_io/parquet/
parquet-tools cat hdfs://localhost/user/cloudera/spark_io/parquet/part-00001-c0338de7-04e3-40e4-946a-ada0c196bdc1-c000.snappy.parquet
```
### Load Parquet file
Import previously created parquet data into dataframe
```
val df_parquet = spark.read.parquet("hdfs://localhost/user/cloudera/spark_io/parquet")
```
#### Write dataframe to CSV format
```
df_parquet.write.option("header","true").csv("hdfs://localhost/user/cloudera/spark_io/csv")
```
Verify that data has been written into HDFS 
```
hdfs dfs -ls /user/cloudera/spark_io/csv/
hdfs dfs -cat /user/cloudera/spark_io/csv/part-00001-9060606a-4285-4af0-a643-ad6a872bfc3c-c000.csv
```
### Load CSV file
Include the spark avro in the dependencies for the current scala version `2.11`, and spark version `2.4.0`
```
spark-shell --packages org.apache.spark:spark-avro_2.11:2.4.0
```
Import previously created csv data into dataframe
```
val df_csv = spark.read.option("header","true").option("inferSchema","true").csv("hdfs://localhost/user/cloudera/spark_io/csv")
```
#### Write dataframe to Avro format
```
df_csv.write.format("avro").save("hdfs://localhost/user/cloudera/spark_io/avro")
```
Verify that data has been written into HDFS - since avro is compressed into binary format it is necessary to use `avro-tools` to visualise the content of the file 
```
hdfs dfs -ls /user/cloudera/spark_io/avro/
avro-tools tojson hdfs://localhost/user/cloudera/spark_io/avro/part-00000-f60900a4-aa03-4837-b7d3-b60a3ee3d0a3-c000.avro
```
Avro files can also be saved as a Hive table
```
df_csv.write.format("com.databricks.spark.avro").saveAsTable(hivedb.hivetable_avro)
```
### Load Avro file
Include spark avro and xml dependencies 
```
spark-shell --packages com.databricks:spark-xml_2.11:0.9.0,org.apache.spark:spark-avro_2.11:2.4.0
```
Import previously created avro data into dataframe
```
val df_avro = spark.read.format("avro").load("hdfs://localhost/user/cloudera/spark_io/avro")
```
#### Write dataframe to XML format
```
df_avro.write.format("com.databricks.spark.xml").
  option("rootTag", "myRootTag").
  option("rowTag", "myRowTag").
  save("hdfs://localhost/user/cloudera/spark_io/xml")
```
### Load XML file
It is necessary to specify the `rootTag` and `rowTag` to import the dataframe
```
val df_xml = spark.read.format("com.databricks.spark.xml").
  option("rootTag", "myRootTag").
  option("rowTag", "myRowTag").
  load("hdfs://localhost/user/cloudera/spark_io/xml")
```



