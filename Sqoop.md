# Sqoop commands to import a local database into HDFS

### Navigate through the mySQL local databases
Before importing data into HDFS it is helpful to get more information about the database that needs to be imported. Cloudera Quistart VM has mySQL and some example databases that can be used for practicing. The one that will be used is the `retail_db` database.

Connect to mySQL in Cloudera Quickstart VM:
```
mysql -u root -h localhost -p
```
use `cloudera` as a password.
Visualise the databases in the local machine:
```
show databases;
```
Select `retail_db` and show its tables:
```
use retail_db;
show tables;
```
Visualise the columns in `customers` table, and the number of rows
```
describe customers;
select count(*) from customers;
```
### Backbone of sqoop import commands
The template of a Sqoop command for importing a RDMS into HDFS is as follows:
```
sqoop import \
   --connect jdbc:sqlserver://<host>:<port>/<database_name> \    # ex: jdbc:mysql://quickstart:3306/retail_db
   --username <username> \                                       # ex: root
   --password <password> \                                       # ex: cloudera
   --table <table-name>  \                                       # ex: customers
   --warehouse-dir <dir> \                                       # ex: /user/cloudera/warehouse
   --target-dir <dir> \                                          # ex: /user/cloudera/customers
   --delete-target-dir \                                         # if target-dir already exists
   --as-avrodatafile \                                           # import data to Avro data files
   --compress \                                                  # enable compression
   --compression-codec <algorithm> \                             # ex: snappy
   --where <where-clause> \                                      # ex: "customer_fname='Mary'"
   --columns <col,col,col…> \                                    # ex: "customer_fname,customer_lname,customer_city"
   --query <statement> \                                         # ex: "Select * from customers where customer_id>100 AND                                                                            \$CONDITIONS"
   --split-by <column-name> \                                    # ex: customer_id
   --boundary-query <statement> \                                # ex: "Select min(product_id), max(product_id) from products
                                                                       where product_it>100
   --fields-terminated-by <char> \                               # ex: '|'
   --null-string <char> \                                        # ex: '\\N'
   --null-non-string <char> \                                    # ex: '\\N'
   --incremental <model> \                                       # ex: append
   --check_column <col> \                                        # ex: order_id
   --last-value <val> \                                          # ex: 100003
   --hive-import \                                               # import tables into Hive
   --create-hive-table \                                         # if target hive table already exist job will fail
   --hive-table <table-name> \                                   # ex: customer_mysql
   
```

### Navigate through local database from sqoop
List databases:
```
sqoop list-databases \
  --connect jdbc:mysql://quickstart:3306 \
  --username root \
  --password cloudera
```
List tables within `retail_db` database:
```
sqoop list-tables \
  --connect jdbc:mysql://quickstart:3306/retail_db \
  --username root \
  --password cloudera
```
Retrieve schema of `customers` tables:
```
sqoop eval \
  --connect jdbc:mysql://quickstart:3306/retail_db \
  --username root \
  --password cloudera \
  --query "describe customers"
```

### Problem 1
##### Instructions:
Connect to mySQL database using sqoop, import all orders that have order_status as COMPLETE
##### Data Description:
A mysql instance is running on quickstart at port 3306. In that instance, you will find orders table that
contains order’s data.
- Installation: `quickstart:3306`
- Database name: `retail_db`
- Table name: `Orders`
- Username: `root`
- Password: `cloudera`
##### Output Requirement:
Place the customer’s files in HDFS directory "/user/cloudera/problem1/orders/parquetdata"
Use parquet format with tab delimiter and snappy compression.
Null values are represented as -1 for numbers and "NA" for string
##### Solution
```
sqoop import \
  --connect jdbc:mysql://quickstart:3306/retail_db \
  --username root \
  --password cloudera \
  --table orders \
  --target-dir "/user/cloudera/problem1/orders/parquetdata" \
  --delete-target-dir \
  --as-parquetfile \
  --compress \
  --compression-codec snappy \
  --null-string "NA" \
  --null-non-string -1 \
  --fields-terminated-by "\t" \
  --where "order_status='COMPLETE'" 
```
