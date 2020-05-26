# Spark Dataframes
Useful references:
- [Data types](https://spark.apache.org/docs/latest/sql-reference.html)
- [Column espressions](https://spark.apache.org/docs/latest/api/scala/index.html#org.apache.spark.sql.Column)
- [Common functions](https://spark.apache.org/docs/2.4.0/api/scala/index.html#org.apache.spark.sql.functions$)
- [Dataframe functions](https://spark.apache.org/docs/1.5.0/api/java/org/apache/spark/sql/DataFrame.html)

## Initialize Dataframe
#### Infer  schema
```
val df = spark.read.
         option("header", "true").
         option("inferSchema","true").
         csv("/cloudera/Hadoop-Spark-Training/data/retail_db/orders.csv")
```
#### Read first then modify schema
```
val df = spark.read.
         option("header", "true").
         csv("/cloudera/Hadoop-Spark-Training/data/retail_db/orders.csv")

val df_new = df.select(
             df("order_id").cast("integer"),
             df("order_date").cast("timestamp"),
             df("order_customer_id").cast("integer"),
             df("order_status").cast("string")
             )
```
#### Define schema then read
```
import org.apache.spark.sql.types._

val schema = StructType(Array(
             StructField("order_id", IntegerType, false),
             StructField("order_date", TimestampType, false),
             StructField("order_customer_id", IntegerType, false),
             StructField("order_status", StringType, false)
             ))
             
val df = spark.read.
         option("header", "true").
         schema(schema).
         csv("/cloudera/Hadoop-Spark-Training/data/retail_db/orders.csv")
```
Note that the data types need to be imported with `import org.apache.spark.sql.types._`, with data type names defined as below
```
BinaryType: binary
BooleanType: boolean
ByteType: tinyint
DateType: date
DecimalType: decimal(10,0)
DoubleType: double
FloatType: float
IntegerType: int
LongType: bigint
ShortType: smallint
StringType: string
TimestampType: timestamp
```         
## Manipulate columns

#### Select
Select columns
```
df.select("order_id", "order_date").show(5)
```
Select columns and apply a transformation:
```
df.select(($"order_id"+1).as("new_order_id"), $"order_date").show(5)
\\ or 
df.select((col("order_id")+1).as("new_order_id"), col("order_date")).show(5)
```
#### Modify data type
Convert from long into int data type
```
df.withColumn("order_id", $"order_id".cast("Int")).printSchema
```
#### New column 
Add column as substring of existing column
```
df.withColumn("order_code", $"order_status".substr(0,2)).show(5)
```
## Filtering

#### Comparison
Single condition
```
df.filter($"order_status" === "COMPLETE").show(5)
```
Multiple conditions
```
df.filter($"order_status" === "COMPLETE" || 
          $"order_status" === "ON_HOLD").show(5)

df.filter($"order_status" === "COMPLETE" && 
          date_format($"order_date", "yyyyMM") === "201308").show(5)
```
#### Contain
```
df.filter($"order_status".contains("PAYMENT")).show(5)
```
#### Between limits
```
df.filter($"order_id".between(0,8)).show(10)
```
#### Within list
```
df.filter($"order_status".isin("COMPLETE", "CLOSED")).show(5)
```
#### String starting with
```
df.filter($"order_status".startsWith("C")).show(5)
\\ or
df.filter($"order_status".like("C%")).show(5)
```
## Dataframe Operations

#### When
Modify column values based on condition
```
df.withColumn("new_status", 
              when(col("order_status").isin("COMPLETED","CLOSED"), "OVER").
              when(col("order_status") === "CANCELED", "PENDING").
              otherwise("NONE")).show()
 ```
#### Join
Join on single column
```
val join_type = "inner"
orders.join(order_items, orders("order_id") === order_items("order_item_order_id"), join_type).show(5)
```
Inner join on multiple columns
```
orders.join(order_items, 
         orders("order_id") === order_items("order_item_order_id") &&
         orders("order_id") === order_items("order_item_id")
         ).show(5)
 ```
 #### OrderBy
 Ascending order
 ```
 order_items.orderBy("order_item_subtotal").show(5)
 ```
 Descending order
 ```
 order_items.orderBy(col("order_item_subtotal").desc).show(5)
 // or
 order_items.orderBy($"order_item_subtotal".desc).show(5)
 ```
#### GroupBy
Count items for each status group
```
orders.groupBy("order_status").count.show(10)
```

## Aggregations
Entire data frame 
```
order_items.select(max("order_item_subtotal").alias("total_maximum")).show()
\\ or
order_items.select(avg("order_item_subtotal").alias("total_average")).show()
\\ or
order_items.select(sum("order_item_subtotal").alias("total_sum")).show()
```
By column keys using **agg()**
```
order_items.groupBy("order_item_quantity").agg(avg("order_item_subtotal")).show(10)
```
with multiple functions
```
order_items.groupBy("order_item_quantity").agg(round(avg("order_item_subtotal"),2)).show(10)
```
with multiple columns
```
order_items.groupBy("order_item_quantity").agg(
         round(avg("order_item_subtotal"),2),
         round(max("order_item_product_price"),2)
         ).show(10)
```

## Date functions
#### Convert to string format
```
orders.select($"order_date", (date_format($"order_date", "yyyy/MM/dd a hh:mm:ss.S")).alias("date")).show(5)
```
#### Extract from timestamp
You can extract `year(), quarter(), month(), dayofmonth(), dayofweek(), dayofyear(), hour(), minute(), second(), weekofyear()`
```
orders.select($order_date, month($order_date)).show(5)
```
#### Operations on dates
Add or subract days 
```
orders.select($"order_date", date_add($"order_date", 1)).show(5)
\\ or
orders.select($"order_date", date_sub($"order_date", 1)).show(5)
```
Add months
```
orders.select($"order_date", add_months($"order_date", 1)).show(5)
```
Number of days between two dates
```
orders.select(datediff($"order_date", date_sub($"order_date", 5))).show(5)
```
Number of monthd between two dates
```
orders.select(months_between(add_months($"order_date", 1), $"order_date")).show(5)
```
#### Unix date/time
Convert timestamp to into seconds after epoch date (1 Jan 1970)
```
val orders_epoch = orders.select($"order_date", (unix_timestamp($"order_date")).alias("epoch_date"))
```
Convert epoch timestamp into date/time
```
orders_epoch.select($"order_date", from_unixtime($"epoch_date", "yyyy-MM-dd")).show(5)
```

