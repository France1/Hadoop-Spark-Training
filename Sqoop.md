# Sqoop commands to import a local database into HDFS

### Navigate through the mySQL local databases
Connect to mySQL in Cloudera Quickstart VM:
```
mysql -u root -h localhost -p
```
use `cloudera` as a password.
Visualise the databases in the local machine:
```
show databases;
```
In these example we will use the `retail_db` database. To select it and show the tables in it:
```
use retail_db;
show tables;
```
Visualise the columns in `customers` table, and the number of rows
```
describe customers;
select count(*) from customers;
```

The template of a Sqoop command for this task is as follows:
```

```
