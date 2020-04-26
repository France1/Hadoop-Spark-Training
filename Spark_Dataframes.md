# Spark Dataframes

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

## Dataframe Operations

#### Select
Select columns
```
df.select("order_id", "order_date").show(5)
```
Select columns and apply a transformation:
```
df.select($"order_id"+1, $"order_date").show(5)
\\ or 
df.select(col("order_id")+1, col("order_date")).show(5)
```
#### Filter
Single condition
```
df.filter(df("order_status") === "COMPLETE").show(5)
```
Multiple conditions
```
df.filter(df("order_status") === "COMPLETE" || 
          df("order_status") === "ON_HOLD").show(5)

df.filter(df("order_status") === "COMPLETE" && 
          date_format($"order_date", "yyyyMM") === "201308").show(5)
```
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
