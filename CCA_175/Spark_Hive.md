# Spark read and write Hive metastore tables
In this example a CSV table is firslty loaded into Hive, then read from Spark, and finally exported into a new Hive table.

#### Load data into Hive table
Create a database `hive_db` at HDFS storage location `/user/cloudera/hive_database`:
```
CREATE DATABASE hive_db COMMENT 'hive spark database' LOCATION '/user/cloudera/hive_database';
USE hive_db;
```
Create Hive `orders` table
```
CREATE TABLE orders
(order_id INT, order_date TIMESTAMP, order_customer_id INT, order_status STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ","
STORED AS TEXTFILE
TBLPROPERTIES ("skip.header.line.count"="1");
```
Load data from local file `/cloudera/data/retail_db/orders.csv` into Hive `orders` table
```
LOAD DATA LOCAL INPATH '/cloudera/data/retail_db/orders.csv' OVERWRITE INTO TABLE orders;
```
Verify that data has been copied
```
SELECT * FROM orders LIMIT 5;
```
and thata data are stored in HDFS
```
hdfs dfs -ls /user/cloudera/hive_database/orders
```

#### Read table 
Verify Spark access to Hive metastore
```
spark.sql("show tables in hive_db").show()
```
Import `orders` table in Hive Metastore into a dataframe
```
val df = spark.sql("select * from hive_db.orders")
df.show()
```
#### Write table
Save dataframe as Hive table `orders_new`, then verify that table has been saved
```
df.write.saveAsTable("hive_db.orders_new")
spark.sql("show tables in hive_db").show()
```

Add different formats and compressions
