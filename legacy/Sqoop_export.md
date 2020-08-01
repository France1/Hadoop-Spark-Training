# Sqoop commands to export HDFS to a local database

### Prepare data 

Create a table `ingredients` in mysql database `retail_db`
```
CREATE TABLE ingredients (
  ingredient_id INT NOT NULL, 
  ingredient_name VARCHAR(30) NOT NULL,
  ingredient_price INT NOT NULL,
  PRIMARY KEY (ingredient_id),  
  UNIQUE (ingredient_name)
);
```
insert data into `ingredients`
```
INSERT INTO ingredients
    (ingredient_id, ingredient_name, ingredient_price)
VALUES 
    (1, "Beef", 5),
    (2, "Lettuce", 1),
    (3, "Tomatoes", 2),
    (4, "Taco Shell", 2),
    (5, "Cheese", 3),
    (6, "Milk", 1),
    (7, "Bread", 2);
```
Import table into HDFS
```
sqoop import \
  --connect jdbc:mysql://quickstart:3306/retail_db \
  --username root \
  --password cloudera \
  --table ingredients \
  --target-dir "/user/cloudera/ingredients" 
```

### Export data
The mySQL table into which data are exported need to exist in the database. Create a new table `ingredients_exported` as
```
CREATE TABLE ingredients_exported (
  ingredient_id INT NOT NULL, 
  ingredient_name VARCHAR(30) NOT NULL,
  ingredient_price INT NOT NULL,
  PRIMARY KEY (ingredient_id),  
  UNIQUE (ingredient_name)
);
```
Then populate `customers_exported` table using data in HDFS
``` 
sqoop export \
  --connect jdbc:mysql://quickstart:3306/retail_db \
  --username root \
  --password cloudera \
  --table ingredients_exported \
  --export-dir "/user/cloudera/ingredients/"
```
To verify that data has been exported into mySQL
```
SELECT * FROM ingredients_exported
```

