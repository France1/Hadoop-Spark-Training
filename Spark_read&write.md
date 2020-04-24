# Spark read and write files in different formats

## Read files
Spark uses [DataFrameReader](https://spark.apache.org/docs/latest/api/scala/index.html#org.apache.spark.sql.DataFrameReader) to load a different data sources from external storage into a dataframe.

#### Text files:
```
val df = spark.read.text("file-path.txt")
```
#### CSV files:
```
val df = spark.read.csv("file-path.csv")
```
#### JSON files:
```
val df = spark.read.json("file-path.json")
```
#### Parquet files:
```
val df = spark.read.parquet("file-path.parquet")
```
#### Avro files
Include the spark avro in the dependencies
```
spark-shell --packages org.apache.spark:spark-avro_2.12:2.4.4
```
then read the file as
```
val df = spark.read.format("avro").load("<file-path.avro>")
```
