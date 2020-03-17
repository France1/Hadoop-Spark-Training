# Hive Tutorial

### Load data into table
Import `customers` table into HDFS:
```
sqoop import \
  --connect jdbc:mysql://quickstart:3306/retail_db \
  --username root \
  --password cloudera \
  --table customers \
  --target-dir "/user/cloudera/customers" \
  --columns "customer_id,customer_fname,customer_lname,customer_city"
```
Create a database called `hive_db` and HDFS storage location `/user/cloudera/hive_database`:
```
CREATE DATABASE hive_db COMMENT 'hive test database' LOCATION '/user/cloudera/hive_database';
USE hive_db;
```
Create a hive table called `customers`:
```
CREATE TABLE customers
(id INT, f_name STRING, l_name STRING, city STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ","
STORED AS TEXTFILE;
```
Load data from HDFS location into Hive `customers` table:
```
LOAD DATA INPATH '/user/cloudera/customers' OVERWRITE INTO TABLE customers
```
Verify that data has been loaded:
```
SELECT * FROM customers LIMIT 5;
```
and also by verifying that HDFS files have been copied:
```
hdfs dfs -ls /user/cloudera/hive_database/customers
```
### Query data from table
Count the number of customers in each city and return the cities with more than 200 customers sorting the results by the name of the city:
```
SELECT city, COUNT(*) FROM customers 
GROUP BY city 
HAVING COUNT(*)>200
ORDER BY city 
LIMIT 100;
```
Create a column `bigCity` with values 1 if the city has more than 50 customers, or 0 otherwise
```
SELECT city,
IF (COUNT(*)>50,1,0) AS bigCity FROM customers
GROUP BY city;
```
### Create table in compressed Parquet format
Enable Snappy compression:
```
SET hive.exec.compress.output=true;
SET parquet.compression=SNAPPY;
```
Crate table stored as Parque files by loading the existing `customers` text files table:
```
CREATE TABLE customers_parquet
STORED AS parquet
LOCATION '/user/cloudera/customer-parquet'
AS SELECT * FROM customers;
```

### Table Partitioning
Import `orders` table into HDFS:
```
sqoop import \
  --connect jdbc:mysql://quickstart:3306/retail_db \
  --username root \
  --password cloudera \
  --table orders \
  --target-dir "/user/cloudera/orders" \
  --delete-target-dir
```
Create an external table to load `orders` data:
```
CREATE EXTERNAL TABLE orders
(ordid INT, date STRING, custid INT, status STRING)
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY ","
STORED AS TEXTFILE
LOCATION '/user/cloudera/hive_orders';
```
Load data from HDFS location into Hive `orders` table:
```
LOAD DATA INPATH '/user/cloudera/orders' OVERWRITE INTO TABLE orders;
```
Show which are the different `status` in `orders` table:
```
SELECT DISTINCT(status) FROM orders;
```
Create partitioned table
```
CREATE EXTERNAL TABLE orders_partitioned
(ordid INT, date STRING, custid INT)
PARTITIONED BY (status STRING)
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY ",";
```
Enable partitioning:
```
set hive.exec.dynamic.partition=true;
set hive.exec.dynamic.partition.mode=nonstrict;
```
Populate partitioned table:
```
INSERT OVERWRITE TABLE orders_partitioned 
PARTITION (status)
SELECT ordid, date, custid, status FROM orders;
```
Show partitions that have been created:
```
SHOW PARTITIONS orders_partitioned;
```
Query ordered that have been cancelled using status partitioning:
```
SELECT * FROM orders_partitioned WHERE status = 'CANCELED' LIMIT 5;
```
