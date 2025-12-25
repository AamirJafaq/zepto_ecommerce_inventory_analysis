DROP TABLE IF EXISTS zepto_inventory;
CREATE TABLE zepto_inventory (
product_entry_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outOfStock BOOLEAN
);

-- Data Exploration
-- Count the number of observations.
SELECT count(*) FROM zepto_inventory;
-- There are 3732 obervations.

-- Is there any null value?
SELECT * FROM zepto_inventory
WHERE category IS NULL OR mrp IS NULL OR discountPercent IS NULL OR
availableQuantity IS NULL OR discountedSellingPrice IS NULL OR WeightInGms IS NULL OR
outOfStock IS NULL;
-- There are no null values.

-- Show how many different product categories?
SELECT category, count(name) AS num_of_products
FROM zepto_inventory
GROUP BY category;
-- There are 14 different categories.

-- Compare the products out of stock and in stock.
SELECT outofstock, count(product_entry_id) AS num_of_products
FROM zepto_inventory
GROUP BY outOfStock;
-- 3279 products are out of stock while 453 products are in stock 


-- Product name present multiple times.
SELECT name, count(name) AS product_name_repetition
FROM zepto_inventory
GROUP BY name
HAVING count(name)>1
ORDER BY count(name) DESC;


-- Data Cleaning
-- Identify products with price 0. Remove it.
SELECT name
FROM zepto_inventory
WHERE mrp=0 OR discountedSellingPrice=0; -- There is one product 'Cherry Blossom Liquid Shoe Polish Neutral' that is price price zero.

DELETE FROM zepto_inventory
WHERE mrp=0;


-- Convert the values of mrp (in paisa) into rupees (by dividing 100).
UPDATE zepto_inventory
SET mrp=mrp/100.0, discountedSellingPrice=discountedSellingPrice/100.0;
SELECT mrp, discountedSellingPrice
FROM zepto_inventory; -- conversionn is successfull.


-- Quesetions/Answers
--Q1. Find the top 10 best value products based on the discount percentage.
SELECT name, mrp, discountPercent
FROM zepto_inventory
ORDER BY discountPercent DESC
LIMIT 10;


--Q2. What are the products with high mrp but out of stock.
SELECT DISTINCT name, mrp, outOfStock
FROM zepto_inventory
WHERE outOfStock='TRUE' AND mrp>250
ORDER BY mrp DESC; -- Let products with mrp greater than 250 are highly valuable.
-- There are 10 products having high mrp but out of stock.


--Q3. Find the estimated revenue for each category.
SELECT category, sum(discountedSellingPrice*availableQuantity) AS total_revenue
FROM zepto_inventory
GROUP BY category
ORDER BY total_revenue DESC;

--Q4. Find all products where mrp is greater than 500 and discount is less than 10%.
SELECT DISTINCT name, mrp, discountPercent
FROM zepto_inventory
WHERE mrp>500 AND discountPercent<10;



--Q5. Identity the top 5 categories offering the highest average discount percentage.
SELECT category, ROUND(avg(discountPercent),2) AS average_discount
FROM zepto_inventory
GROUP BY category
ORDER BY avg(discountPercent) DESC
LIMIT 5;


--Q6. Find the price per gram for products above 100g and sort by best value.
SELECT DISTINCT name, discountedSellingPrice, ROUND(discountedSellingPrice/WeightInGms,2) AS price_per_gram
FROM zepto_inventory
WHERE WeightInGms>=100
ORDER BY price_per_gram ASC;

--Q7. What is total inventory weight per category?
SELECT category, sum(WeightInGms*availableQuantity) AS total_weight 
FROM zepto_inventory
GROUP BY category
ORDER BY sum(WeightInGms) DESC;
