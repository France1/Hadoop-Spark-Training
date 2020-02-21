# Sqoop commands to export HDFS to a local database

### Prepare data 
```
sqoop import \
  --connect jdbc:mysql://quickstart:3306/retail_db \
  --username root \
  --password cloudera \
  --table customers \
  --target-dir "/user/cloudera/customers" 
```

### Problem 1
##### Instructions:
Using sqoop export, move data from HDFS to MySQL
##### Description:
- HDFS location: `/user/cloudera/customers/`
- MySQL table: `customers_exported`
- Null string: `EMPTY`
- Null non-string: `0`
- Mappers: `3`

The target table must already exist into the database 
```
sqoop export \
  --connect jdbc:mysql://quickstart:3306/retail_db \
  --username root \
  --password cloudera \
  --table customers_exported \
  --export-dir "/user/cloudera/customers/" \
  --input-fields-terminated-by '*' \
  --input-null-string 'EMPTY' \
  --input-null-non-string 0 \
  -m 3
```
To verify that data has been imported into HDFS
```
hdfs dfs -ls /user/cloudera/problem1/orders/parquetdata
```
Use `parquet-tools` to read the first 5 rows of the compressed parquet files
```
parquet-tools head -n5 hdfs://localhost/user/cloudera/problem1/orders/parquetdata/1c2b1059-499a-420c-a5b4-db82256a4044.parquet
```
and the metadata
```
parquet-tools meta hdfs://localhost/user/cloudera/problem1/orders/parquetdata/1c2b1059-499a-420c-a5b4-db82256a4044.parquet
```

