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
LOAD DATA INPATH '/user/cloudera/customers' OVERWRITE INTO TABLE 'customers'
```
Verify that data has been loaded:
```
SELECT * FROM customers LIMIT 5;
```
and also by verifying that HDFS files have been copied:
```
hdfs dfs -ls /user/cloudera/hive_database/customers
```
