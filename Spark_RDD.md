# Spark RDD

In Cloudera VM start spark as
```
spark-shell
```
which will open a scala CLI with Spark Context available as `sc`

## Transformations
Apply **map()** to a list
```
val rdd = sc.parallelize(List(1,2,3,4,5)) 
val resultRDD = rdd.map(x => x*2) 
resultRDD.collect()
```
Apply **map()** to a text file
```
val rdd = sc.textFile("/cloudera/Udemy-CCA175/data/employees.txt") 
val resultRDD = rdd.map(x => x.length) 
resultRDD.collect()
```
