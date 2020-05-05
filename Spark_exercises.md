# Spark Exercises

#### Problem 1
Find best 5 orders for the day based on total revenue
```
import org.apache.spark.sql.expressions.Window
\\ make date only column
val order_dates = orders.withColumn("date", date_format(col("order_date"), "yyyy-MM-dd")).select("order_id","date")
\\ join orders and order_items
val joined = order_items.join(order_dates, 
         order_items("order_item_order_id") === order_dates("order_id"), "inner")
\\ tot revenue by product and by date
val grouped = joined.groupBy("date","order_item_product_id").
         agg(round(sum("order_item_subtotal"),2).alias("tot_revenue")).
         orderBy(col("tot_revenue").desc)
\\ ranked tot_revenue for each day
val windowSpec = Window.partitionBy("date").orderBy($"tot_revenue".desc)
val ranked = grouped.withColumn("rank", rank().over(windowSpec))
\\ show first 3 products per day
ranked.filter(col("rank") <= 3).show()        
```

#### Problem 2
Find average revenue per day and all orders that are above average
```
import org.apache.spark.sql.expressions.Window
\\ join orders and order_items
val joined = order_items.join(orders, 
         order_items("order_item_order_id") === orders("order_id"), "inner")
\\ tot revenue by product and by date
val grouped = joined.groupBy("order_date","order_item_product_id").
         agg(round(sum("order_item_subtotal"),2).alias("order_revenue")).
         orderBy(col("order_revenue").desc)
 \\ calculate avg revenue for each day
 val windowSpec = Window.partitionBy("order_date")
 val day_avg = grouped.withColumn("day_avg", avg("order_revenue").over(windowSpec))
 \\ orders above the daily average
 day_avg.filter($"order_revenue" > $"day_avg").show(10)
 ```

### Problem 3
Find 3 highest orders for each day
```
import org.apache.spark.sql.expressions.Window
val orders_day = orders.withColumn("day", date_format(col("order_date"), "yyyy-MM-dd")).drop("order_date")
val joined = orders_day.join(order_items, orders_day("order_id") === order_items("order_item_order_id")).
                        join(products, order_items("order_item_order_id") === products("product_id")).
                        select("day", "order_item_subtotal", "product_name")
val grouped = joined.groupBy("day", "product_name").agg(round(sum("order_item_subtotal"),2).alias("order_revenue"))
val windowSpec = Window.partitionBy("day").orderBy($"order_revenue".desc)
val ranked = grouped.withColumn("rank", rank().over(windowSpec))
ranked.filter($"rank" <= 3).orderBy($"day".desc).show(10)
```
