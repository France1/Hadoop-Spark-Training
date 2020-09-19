# Modify default configurations

### Spark-shell configurations
Recover the list of all configuration arguments that can be specified before starting `spark-shell`:
```
spark-shell --help
```

Within `spark-shell` the current value of all configuration arguments can be accessed as:
```
sc.getConf.getAll.foreach(println)
```

### Increasing memory and number of executors
Run spark with 10 executors and 2 GB of memory per executor
``` 
spark-shell --num-executors 10 --executor-memory 2G
```

### Connection to MySQL
To connect with the MySQL database installed in the Cloudera VM first download [MySQL driver](https://dev.mysql.com/downloads/connector/j/5.1.html) into the `drivers` folder. Then specify the driver dependency:
```
spark-shell --driver-class-path cloudera/drivers/mysql-connector-java-5.1.48/mysql-connector-java-5.1.48-bin.jar
```

### Avro files
To manipulate Avro files load the corresponding package compatible to Spark 2.4.0:
```
spark-shell --packages org.apache.spark:spark-avro_2.11:2.4.0
```

### XML files
To manipulate XML files load the corresponding package compatible to Spark 2.4.0:
```
spark-shell --packages com.databricks:spark-xml_2.11:0.9.0
```

### Multiple configurations
To combine MySQL driver with Avro and XML file packages:
```
spark-shell\
 --driver-class-path cloudera/drivers/mysql-connector-java-5.1.48/mysql-connector-java-5.1.48-bin.jar\
 --packages com.databricks:spark-xml_2.11:0.9.0,org.apache.spark:spark-avro_2.11:2.4.0

```

