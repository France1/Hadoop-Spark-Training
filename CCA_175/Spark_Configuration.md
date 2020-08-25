# Spark Configuration
To recover the list of all configuration arguments that can be specified before starting `spark-shell`:
```
spark-shell --help
```

Within `spark-shell` the current value of all configuration arguments can be accessed as:
```
sc.getConf.getAll.foreach(println)
```

### Example
Run spark with 10 executors and 2 GB of memory per executor
``` 
spark-shell --num-executors 10 --executor-memory 2G
```


