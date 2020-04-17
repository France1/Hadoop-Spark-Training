# Spark RDD

In Cloudera VM start spark as
```
spark-shell
```
which will open a scala CLI with Spark Context available as `sc`

Copy data into hdfs as
```
hdfs dfs -mkdir /user/cloudera/practice
hdfs dfs -copyFromLocal /cloudera/Udemy-CCA175/data/employees.txt /user/cloudera/practice 
```

## Transformations
Apply function to list using **map()** 
```
val rdd = sc.parallelize(List(1,2,3,4,5)) 
val resultRDD = rdd.map(x => x*2) 
resultRDD.collect()
```
Measure length of lines in text file using **map()** 
```
val rdd = sc.textFile("/user/cloudera/practice/employees.txt") 
val resultRDD = rdd.map(x => x.length) 
resultRDD.collect()
```
Collect all entries in comma separated text file using **flatmap()**
```
val rdd = sc.textFile("/user/cloudera/practice/employees.txt") 
val resultRDD = rdd.flatMap(x => x.split(","))
resultRDD.collect()
```
Select multiples of 2 in list using **filter()**
```
val rdd = sc.parallelize(List(1,2,3,4,5)) 
val resultRDD = rdd.filter(x => x%2==0) 
resultRDD.collect()
```
Append list to list using **union()**
```
val rdd1 = sc.parallelize(List(1,2,3,4,5)) 
val rdd2 = sc.parallelize(List(6,7,8,9)) 
val resultRDD = rdd1.union(rdd2) 
resultRDD.collect()
```
Find common elements in two lists using **intersection()**
```
val rdd1 = sc.parallelize(List(1,2,3,4,5)) 
val rdd2 = sc.parallelize(List(1,2,3,6,7)) 
val resultRDD = rdd1.intersection(rdd2) 
resultRDD.collect()
```
Find unique elements in list using **distinct()**
```
val rdd1 = sc.parallelize(List(1,1,2,2,3,4,5))
val resultRDD = rdd1.distinct()
resultRDD.collect()
```
Increase number of partitions of list
```
val rdd = sc.parallelize(List(1,1,2,2,3,4,5),2)
rdd.partitions.size
```
Apply function to each partitions using **mapPartitions()**. Note that mapPartitions requires to return an iterator 
```
val rdd = sc.parallelize(List(1,1,2,2,3,4,5),2)
val resultRDD = rdd.mapPartitions(iter => List(iter.toList).iterator)
resultRDD.collect()
```
Similar to above but with indexing using **mapPartitionsWithIndex**
```
val rdd = sc.parallelize(List(1,1,2,2,3,4,5),3) 
val resultRDD = rdd.mapPartitionsWithIndex{
  (index,iterator) => {
  println("Partition index: "+ index) 
  List(iterator.size).iterator }}
resultRDD.collect()
```
Group items in text using **groupByKey()**
```
val rdd = sc.textFile("/user/cloudera/practice/birthdays.txt") 
val pairRdd = rdd.map(x => x.split(',')).map(split => (split(0),split(1)))
val groupedRDD = pairRdd.groupByKey() 
groupedRDD.collect
```
Sum values on same keys using **reduceByKey()**
```
val rdd = sc.textFile("/user/cloudera/practice/subject.txt")
val pairRdd = rdd.map(x => (x.split(',')(0),x.split(',')(1).toInt)) 
val reducedRDD = pairRdd.reduceByKey(_+_) 
reducedRDD.collect
```
Sort keys in ascending order using **sortByKey()**
```
val rdd = sc.textFile("/user/cloudera/practice/students.txt")
val pairRdd = rdd.map(x => (x.split(',')(0).toInt,x.split(',')(1))) 
val sortedRdd = pairRdd.sortByKey()
sortedRdd.collect
```
Sort values in ascending order using **sortBy()**
```
val rdd = sc.textFile("/user/cloudera/practice/score.txt")
val pairRdd = rdd.map(x => (x.split(',')(0),x.split(',')(1).toInt)) 
val sortedRDD = pairRdd.sortBy(_._2)
sortedRDD.collect
```
