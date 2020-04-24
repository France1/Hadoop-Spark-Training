# Spark read and write files in different formats

## Read files
Spark uses [DataFrameReader](https://spark.apache.org/docs/latest/api/scala/index.html#org.apache.spark.sql.DataFrameReader) to load a different data sources from external storage into a dataframe
### Text, csv, parquet, and json
```
val df = spark.read.
\\       text("file-path.txt")
\\       csv("file-path.csv")
\\       json("file-path.json")
\\       parquet("file-path.parquet")
```
### Avro
To read Avro files it is necessary to firstly include the spark avro in the dependencies
```
spark-shell --packages org.apache.spark:spark-avro_2.12:2.4.4
```
Then to read the file as
```
val df = spark.read.format("avro").load("<file-path.avro>")
```
### Hive tables
