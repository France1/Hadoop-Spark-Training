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
   --connect jdbc:sqlserver://<host>:<port>/<database_name> \    # jdbc:mysql://quickstart:3306/retail_db
   --username <username> \                                       # root
   --password <password> \                                       # cloudera
   --table <table-name>  \                                       # customers
   --warehouse-dir <dir> \                                       # /user/cloudera/warehouse
   --target-dir <dir> \                                          # /user/cloudera/customers
   --delete-target-dir \                                         # if target-dir already exists
   --as-avrodatafile \                                           # import data to Avro data files
```
