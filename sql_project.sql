DROP TABLE if exists zepto:

create table zepto(
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outOfStock BOOLEAN,	
quantity INTEGER
);

-- Data exploration

--count of raws
select count(*) from zepto;

--sample data
select * from zepto
limit 10;

--null values
select * from zepto
where name is null
or
category is null
or
mrp is null
or
discountpercent is null
or
availablequantity is null
or
discountedsellingprice is null
or
weightingms is null
or
outofstock is null
or
quantity is null;

--diffrent product category
select distinct category 
from zepto

--product in stock v/s out of stock
select outOfStock , count(sku_id)
from zepto
GROUP BY outOfStock;

--product name present multiple times
SELECT name ,count (sku_id) as "number of skus"
from zepto
group by name
having count(sku_id)>1
order by count(sku_id) desc;

--data cleaning

--product with price zero

select * from zepto 
WHERE mrp = 0 or discountedSellingPrice =0;

DELETE FROM zepto
WHERE mrp=0;

--convert paise to rupees
UPDATE zepto
SET mrp=mrp/100.0,
discountedSellingPrice=discountedSellingPrice/100.0;

--data analysis
-- Q1. Find the top 10 best-value products based on the discount percentage.
select distinct name,mrp,discountpercent
from zepto
order by discountpercent desc
limit 10;

--Q2.What are the Products with High MRP but Out of Stock
select distinct name ,mrp
from zepto
where outOfstock = True and mrp>300
order by mrp desc;

--Q3.Calculate Estimated Revenue for each category
select category ,
SUM(discountedSellingPrice*availableQuantity) as total_revenue
from zepto
group by category
order by total_revenue;

-- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.  
select name, mrp,discountPercent
from zepto
WHERE mrp>500 and discountPercent<10 
order by mrp desc,discountPercent desc;

-- Q5. Identify the top 5 categories offering the highest average discount percentage.
select category,
avg(discountPercent) as avg_discountPercent
from zepto
group by category
order by avg_discountPercent desc
limit 5;

-- Q6. Find the price per gram for products above 100g and sort by best value.
select distinct name ,weightInGms, discountedSellingPrice,
ROUND(discountedSellingPrice/weightInGms,2) as price_per_gms
from zepto 
where   weightInGms>=100
order by price_per_gms;

--Q7.Group the products into categories like Low, Medium, Bulk.
select distinct name , weightInGms ,
case when weightInGms<1000 then 'low'
 	 when weightInGms >1000 then 'mid'
	 else 'bulk'
	 end as weighted_category
from zepto;	 
	 
--Q8.What is the Total Inventory Weight Per Category 
select category,
sum( weightInGms * availableQuantity ) as total_weight
from zepto
group by category
order by total_weight;