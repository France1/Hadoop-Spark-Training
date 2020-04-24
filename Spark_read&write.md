# Spark read and write files in different formats

Spark uses [DataFrameReader](https://spark.apache.org/docs/latest/api/scala/index.html#org.apache.spark.sql.DataFrameReader) to load different types of data sources from external storage into a dataframe, and [DataFrameWriter](https://spark.apache.org/docs/latest/api/scala/index.html#org.apache.spark.sql.DataFrameWriter
) to save a dataframe to external storage

#### Text files:
```
val df = spark.read.text("read-path.txt")
df = spark.write.text("write-path.txt")
```
#### CSV files:
```
val df = spark.read.csv("read-path.csv")
df = spark.write.csv("write-path.csv")
```
#### JSON files:
```
val df = spark.read.json("read-path.json")
df = spark.write.json("write-path.json")
```
#### Parquet files:
```
val df = spark.read.parquet("read-path.parquet")
df = spark.write.csv("write-path.parquet")
```
#### Avro files
https://databricks.com/blog/2018/11/30/apache-avro-as-a-built-in-data-source-in-apache-spark-2-4.html
Include the spark avro in the dependencies
```
spark-shell --packages org.apache.spark:spark-avro_2.12:2.4.4
```
then read/write files as
```
val df = spark.read.format("avro").load("read-path.avro")
df.write.format("avro").save("write-path.avro")
```



