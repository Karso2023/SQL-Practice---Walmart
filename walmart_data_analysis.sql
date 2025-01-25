-- Create database
CREATE DATABASE IF NOT EXISTS walmartSales;


-- Create table
CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);

-- Feature Engineering -- 

-- time_of_day

select	
	time,
    (case
		when `time` between "00:00:00" and "12:00:00" then "Morning"
		when `time` between "12:01:00" and "16:00:00" then "Afternoon"
        else "evening"
    end
    ) as time_of_date
from sales;

alter table sales add column time_of_day varchar(20);

update sales
set time_of_day = (
	case
		when `time` between "00:00:00" and "12:00:00" then "Morning"
		when `time` between "12:01:00" and "16:00:00" then "Afternoon"
        else "evening"
	end
);

select 
	date,
    dayname(date) as day_name
from sales;

alter table sales add column day_name varchar(10);

update sales
set day_name = dayname(date);

select 
	date,
    monthname(date)
from sales;


alter table sales add column month_name varchar(10);

update sales 
set month_name = monthname(date);

-- --------------------------------------------------------------------
-- ---------------------------- Questions ------------------------------
-- --------------------------------------------------------------------

-- How many unique cities does the data have?
select 
	distinct city 
from sales;

-- In which city is each branch?
select 
	distinct city,
    branch
from sales;

-- How many unique product lines does the data have?
select
	count(distinct product_line)
from sales;

-- What is the most common payment method?
select
	payment_method,
    count(payment_method) as cnt
from sales
group by payment_method
order by cnt desc;

-- What is the most selling product line?
select
	product_line,
    count(product_line) as cnt
from sales
group by product_line
order by cnt desc;
    
-- What is the total revenue by month?
select
	month_name as month,
    sum(total) as total_revenue
from sales
group by month_name
order by total_revenue desc;

-- What month had the largest COGS?
select 
	month_name as month,
    sum(cogs) as cogs
from sales
group by month_name
order by cogs desc;

-- What product line had the largest revenue?
select
	product_line,
    sum(total) as total_revenue
from sales
group by product_line
order by total_revenue desc;

-- What is the city with the largest revenue?
select
	city,
    sum(total) as total_revenue
from sales
group by city
order by total_revenue desc;

-- What product line had the largest VAT?
select 
	product_line,
    avg(VAT) as vat
from sales
group by product_line
order by vat desc;

-- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales

-- Which branch sold more products than average product sold?
select
	branch,
    sum(quantity) as qty
from sales
group by branch
having sum(quantity) > (select avg(quantity) from sales);

-- What is the most common product line by gender?
select
	gender,
    product_line,
    count(gender) as total_cnt
from sales
group by gender, product_line
order by total_cnt desc;

-- What is the average rating of each product line?
select
	product_line,
    round(avg(rating), 2) as avg_rating
from sales
group by product_line
order by avg_rating desc;

-- Number of sales made in each time of the day per weekday
select
	time_of_day,
    count(*) as total_sales
from sales
where day_name = "Monday"
group by time_of_day
order by total_sales desc;

-- Which of the customer types brings the most revenue?
select
	customer_type,
    round(sum(total),3) as total_revenue
from sales
group by customer_type
order by total_revenue desc;

-- Which city has the largest tax percent/ VAT (Value Added Tax)?
select 
	city,
    round(avg(VAT),3) as VAT
from sales
group by city
order by VAT desc;

-- Which customer type pays the most in VAT?
select 
	customer_type,
    round(avg(VAT),3) as VAT
from sales
group by customer_type
order by VAT desc;

-- How many unique customer types does the data have?
select
	distinct customer_type
from sales;

-- How many unique payment methods does the data have?
select
	distinct payment_method
from sales;

-- Which customer type buys the most?
select
	customer_type,
    count(*) as customer_cnt
from sales
group by customer_type
order by customer_cnt desc;

-- What is the gender of most of the customers?
select
	gender,
    count(*) as gender_cnt
from sales
group by gender
order by gender_cnt desc;

-- What is the gender distribution per branch?
select
	gender,
    count(*) as gender_cnt
from sales
where branch = "A"
group by gender
order by gender_cnt desc;

select
	gender,
    count(*) as gender_cnt
from sales
where branch = "B"
group by gender
order by gender_cnt desc;

select
	gender,
    count(*) as gender_cnt
from sales
where branch = "C"
group by gender
order by gender_cnt desc;

-- Which time of the day do customers give most ratings?
select
	time_of_day,
    avg(rating) as avg_rating
from sales
group by time_of_day
order by avg_rating desc;
-- Which time of the day do customers give most ratings per branch?
select
	time_of_day,
    avg(rating) as avg_rating
from sales
where branch = "A"
group by time_of_day
order by avg_rating desc;

select
	time_of_day,
    avg(rating) as avg_rating
from sales
where branch = "B"
group by time_of_day
order by avg_rating desc;

select
	time_of_day,
    avg(rating) as avg_rating
from sales
where branch = "C"
group by time_of_day
order by avg_rating desc;

-- Which day of the week has the best avg ratings?
select 
	day_name,
    avg(rating) as avg_rating
from sales
group by day_name
order by avg_rating desc;

-- Which day of the week has the best average ratings per branch?
select 
	day_name,
    avg(rating) as avg_rating
from sales
where branch = "A"
group by day_name
order by avg_rating desc;

select 
	day_name,
    avg(rating) as avg_rating
from sales
where branch = "B"
group by day_name
order by avg_rating desc;

select 
	day_name,
    avg(rating) as avg_rating
from sales
where branch = "C"
group by day_name
order by avg_rating desc;













