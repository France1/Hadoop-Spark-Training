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
Collect all entries in comma separated text file using **flatMap()**
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
Similar to above but with indexing using **mapPartitionsWithIndex()**
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
Apply function to values (without operating on keys) using **mapValues()**
```
val rdd = sc.parallelize(Array(("jim",1),("john",2))) 
val pairRdd = rdd.mapValues(x => x*2) 
pairRdd.collect()
```
Inner join RDD arrays on keys using **join()**
```
val rdd1 = sc.parallelize(Array(("jim","j@gmail.com"),("john","john@gmail.com")))
val rdd2 = sc.parallelize(Array(("rob","robb@gmail.com"),("john","john25@gmail.co m"),("jim","jim32@gmail.com")))
val joinedRdd = rdd1.join(rdd2)
```
Descrease the number of partitions in a node (without reshuffling) using **coalescence()**
```
val rdd = sc.parallelize(List(1,1,2,2,3,4,5),3) 
rdd.partitions.size
val coalescedRdd = rdd.coalesce(1) 
coalescedRdd.partitions.size
```
Change partitions of RDD with reshuffling
```
val rdd = sc.parallelize(List(1,1,2,2,3,4,5)) 
rdd.partitions.size
val repartitionedRdd = rdd.repartition(3) 
repartitionedRdd.partitions.size
```

## Actions

Collect and return entire RDD to driver using **collect()**
```
val rdd = sc.parallelize(List(1,2,3,4,5)) 
rdd.collect()
```
Retrieve n elements to driver using **take()**
```
rdd.take(2)
```
Retrieve first element to driver using **first()**
```
rdd.first()
```
Count and return number of elements using **count()**
```
rdd.count()
```
Retrieve first n elements to driver using **top()**
```
rdd.top(2)
```
Return frequency of elements using **countByValue()**
```
val rdd = sc.parallelize(List(1,1,2,2,2,3,4,4,5)) 
rdd.countByValue()
```
Sum elements using **reduce()**
```
rdd.reduce(_+_)
```
Print all elements using **foreach()**
```
rdd.foreach(println)
```

## Problems
### Problem 1
Filter out all ERROR logs from log file.
- Input location: /user/cloudera/problem1/log.txt
- Output location: /user/cloudera/problem1_sol
- Save as text file

Solution:
```
val rdd = sc.textFile("/user/clouderaproblem1/log.txt")
val rdd_filt = rdd.filter(x => !(x.contains("ERROR")))
rdd_filt.saveAsTextFile("/user/cloudera/problem1_sol")
```
### Problem 2
Find frequency of words in a text file and save output in descending order
- Input location: /user/cloudera/problem2/customer.txt 
- Output location: /user/cloudera/problem2_sol
- Expected output: word, frequency
- Save as text file

Solution:
```
val rdd = sc.textFile("/user/cloudera/problem2/customer.txt")
val rdd_words = rdd.flatMap(x=>x.split(",|\\s"))
val rdd_filt = rdd_words.filter(x=>x.distinct!="X")
val rdd_tuple = rdd_filt.map(x=>(x,1))
val rdd_reduced = rdd_tuple.reduceByKey(x,y=>x+y))
val rdd_sorted = rdd_reduced.sortBy(_._2, false)
rdd_sorted.map(x => x._1 + "," + x._2).saveAsTextFile("/user/cloudera/problem2_sol")
```
### Problem 3
Find the population of each city
- Input location: /user/cloudera/problem3/customer.txt 
- Output location: /user/cloudera/problem3_sol
- Expected output: city => population
- Save as text file

Solution
```
val rdd = sc.textFile("/user/cloudera/problem3/customer.txt")
val rdd_city = rdd.map(x => x.split(",")(6))
val rdd_pairs = rdd_city.map(x => (x,1))
val rdd_freq = rdd_pairs.reduceByKey(_+_)
val rdd_sort = rdd_freq.sortBy(_._2, false)
rdd_sort.map(x => s"${x._1} => ${x._2}").saveAsTextFile("/user/cloudera/problem3_sol")
```
### Problem 4
Find number of orders placed by customers, and sort results in descending order
- Input location customers: /user/cloudera/problem4/customer/customers
- Input location orders: /user/cloudera/problem4/order/orders
- Expected output: customer_fname, customer_lname => num_orders
- Output location: /user/cloudera/problem4_sol

Solution
```
val rdd_customers = sc.textFile("/user/cloudera/problem4/customer/customers")
val rdd_orders = sc.textFile("/user/cloudera/problem4/order/orders")
\\ order pairs map-reduce
val order_pairs = rdd_orders.map(x => (x.split("\t")(2),1))
val order_reduced = order_pairs.reduceByKey(_+_)
\\ customer map-reduce
val customer_pairs = rdd_customers.map{line => 
  val splitted = line.split("\t") 
  (splitted(0), splitted(1)+" "+splitted(2))}
\\ join and sort rdds
val joined = customer_pairs.join(order_reduced)
val sorted = joined.sortBy(_._2._2, false) 
sorted.map(x => s"${x._2._1} => ${x._2._2}").saveAsTextFile("/user/cloudera/problem4_sol")
```
