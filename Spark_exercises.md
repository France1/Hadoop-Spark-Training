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

\\ make date only column
val orders_day = orders.withColumn("day", date_format(col("order_date"), "yyyy-MM-dd")).drop("order_date")

\\ join orders - order_items - products
val joined = orders_day.join(order_items, orders_day("order_id") === order_items("order_item_order_id")).
                        join(products, order_items("order_item_order_id") === products("product_id")).
                        select("day", "order_item_subtotal", "product_name")
                        
\\ sum orders over day and product name
val grouped = joined.groupBy("day", "product_name").agg(round(sum("order_item_subtotal"),2).alias("order_revenue"))

\\ rank by order revenue
val windowSpec = Window.partitionBy("day").orderBy($"order_revenue".desc)
val ranked = grouped.withColumn("rank", rank().over(windowSpec))

\\ select first 3 revenues
ranked.filter($"rank" <= 3).orderBy($"day".desc).show(10)
```

### Problem 4
Find orders contributing more than 75% of total order revenue
```
import org.apache.spark.sql.expressions.Window

\\ revenue by order_id
val windowSpec = Window.partitionBy("order_item_order_id")
val revenues = order_items.withColumn("order_revenue", sum($"order_item_subtotal").over(windowSpec))

\\ calculate revenue ratio
val ratio = revenues.withColumn("ratio", round($"order_item_subtotal"/$"order_revenue", 2)).
            orderBy("order_item_order_id")
ratio.filter($"ratio" >= 0.75).show(10)
```

### Problem 5
Find difference of revenue in top 2 orders
```
import org.apache.spark.sql.expressions.Window

\\ rank orders with same order_id by revenue
val window = Window.partitionBy("order_item_order_id").orderBy($"order_item_subtotal".desc)
val ranked = order_items.withColumn("rank", rank().over(window))

\\ create column with 2nd highest order
val next_order = ranked.withColumn("next", lead($"order_item_subtotal",1).over(window)).na.fill(0, Array("next"))

\\ difference between item revenue and shifted item revenue
val diff_order = next_order.withColumn("diff", round($"order_item_subtotal"-$"next",1))

\\ select only 1st and 2nd largest revenue
diff_order.filter($"rank" === 1).show(10)
```

### Problem 6
Find best selling and second best selling product in each category
```
import org.apache.spark.sql.expressions.Window

\\ joine order_items, products, and categories tables
val joined = order_items.join(products, order_items("order_item_product_id") === products("product_id")).
                         join(categories, products("product_category_id") === categories("category_id")).
                         select("product_name", "category_name", "order_item_subtotal")
                         
\\ sum orders across categories and products
val grouped = joined.groupBy("product_name","category_name").agg(round(sum("order_item_subtotal"),1).alias("order_revenue"))

\\ rank revenues across categories
val window = Window.partitionBy("category_name").orderBy($"order_revenue".desc)
val ranked = grouped.withColumn("ranked", rank().over(window))

\\ show first 2 best selling products
ranked.filter($"ranked" <= 2).orderBy("category_name").orderBy("category_name","ranked").show(10)
```

### Problem 7
Find the difference between the revenue of each product and the the revenue of the best selling product in each category
```
import org.apache.spark.sql.expressions.Window

\\ join order_items and products tables
val joined = order_items.join(products, order_items("order_item_product_id") === products("product_id")).
                         join(categories, products("product_category_id") === categories("category_id")).
                         select("product_name", "category_name", "order_item_subtotal")

\\ calculate revenue by product and category
val grouped = joined.groupBy("product_name","category_name").agg(round(sum("order_item_subtotal"),1).alias("product_revenue"))

\\ max revenue in each category
val window = Window.partitionBy("category_name").orderBy($"product_revenue".desc)
val ranked = grouped.withColumn("top_revenue", max($"product_revenue").over(window))

\\ difference between product revenue and top category revenue
val diff_revenues = ranked.withColumn("diff", round($"top_revenue"-$"product_revenue",1)).drop("top_revenue")
```
