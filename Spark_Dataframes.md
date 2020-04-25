# Spark Dataframes

## Initialize Dataframe
Inferring dataframe schema
```
val df = spark.read.
         option("header", "true").
         option("inferSchema","true").
         csv("/cloudera/Hadoop-Spark-Training/data/retail_db/orders.csv")
```
Read data frame and then modify schema
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
Defining dataframe schema before importing
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
