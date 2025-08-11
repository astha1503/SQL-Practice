-- E-COMMERCE DATABASE SETUP
-- Copy and paste this into any SQL environment (MySQL, PostgreSQL, SQLite, etc.)


CREATE DATABASE ecommerce_practice;
USE ecommerce_practice;
-- Create tables
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    city VARCHAR(50),
    country VARCHAR(50),
    signup_date DATE
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2),
    stock_quantity INT
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    status VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Insert sample data
INSERT INTO customers VALUES
(1, 'John', 'Smith', 'john.smith@email.com', 'New York', 'USA', '2023-01-15'),
(2, 'Sarah', 'Johnson', 'sarah.j@email.com', 'London', 'UK', '2023-02-20'),
(3, 'Mike', 'Brown', 'mike.brown@email.com', 'Toronto', 'Canada', '2023-01-30'),
(4, 'Emma', 'Davis', 'emma.davis@email.com', 'Sydney', 'Australia', '2023-03-10'),
(5, 'Carlos', 'Rodriguez', 'carlos.r@email.com', 'Madrid', 'Spain', '2023-02-05'),
(6, 'Lisa', 'Wilson', 'lisa.wilson@email.com', 'New York', 'USA', '2023-04-12'),
(7, 'David', 'Lee', 'david.lee@email.com', 'Seoul', 'South Korea', '2023-03-25'),
(8, 'Anna', 'Mueller', 'anna.m@email.com', 'Berlin', 'Germany', '2023-01-08');

INSERT INTO products VALUES
(101, 'Laptop Pro', 'Electronics', 999.99, 50),
(102, 'Wireless Mouse', 'Electronics', 29.99, 200),
(103, 'Coffee Mug', 'Home', 12.99, 150),
(104, 'Desk Chair', 'Furniture', 199.99, 75),
(105, 'Phone Case', 'Electronics', 19.99, 300),
(106, 'Water Bottle', 'Home', 15.99, 120),
(107, 'Notebook', 'Office', 8.99, 250),
(108, 'Headphones', 'Electronics', 79.99, 100),
(109, 'Plant Pot', 'Home', 24.99, 80),
(110, 'Desk Lamp', 'Furniture', 45.99, 60);

INSERT INTO orders VALUES
(1001, 1, '2023-05-01', 1029.98, 'completed'),
(1002, 2, '2023-05-02', 32.98, 'completed'),
(1003, 3, '2023-05-03', 199.99, 'completed'),
(1004, 1, '2023-05-05', 45.99, 'completed'),
(1005, 4, '2023-05-07', 94.97, 'shipped'),
(1006, 5, '2023-05-08', 28.98, 'completed'),
(1007, 6, '2023-05-10', 159.97, 'pending'),
(1008, 2, '2023-05-12', 79.99, 'completed'),
(1009, 7, '2023-05-15', 1019.98, 'shipped'),
(1010, 8, '2023-05-18', 67.98, 'completed');

INSERT INTO order_items VALUES
(1, 1001, 101, 1, 999.99),
(2, 1001, 102, 1, 29.99),
(3, 1002, 103, 1, 12.99),
(4, 1002, 105, 1, 19.99),
(5, 1003, 104, 1, 199.99),
(6, 1004, 110, 1, 45.99),
(7, 1005, 108, 1, 79.99),
(8, 1005, 107, 1, 8.99),
(9, 1005, 106, 1, 5.99),
(10, 1006, 102, 1, 29.99),
(11, 1007, 104, 1, 199.99),
(12, 1007, 109, 2, 24.99),
(13, 1007, 107, 1, 8.99),
(14, 1008, 108, 1, 79.99),
(15, 1009, 101, 1, 999.99),
(16, 1009, 105, 1, 19.99),
(17, 1010, 103, 2, 12.99),
(18, 1010, 106, 2, 15.99);

-- ========================================
-- PRACTICE QUESTIONS (START WITH THESE)
-- ========================================

-- BEGINNER LEVEL (Basic SELECT, WHERE, ORDER BY)
-- 1. Show all customers from USA
SELECT * FROM customers 
WHERE country = 'USA';

-- 2. Find all products under $50
SELECT product_name FROM products 
WHERE price < 50 ;

-- 3. List all orders placed in May 2023, ordered by date
SELECT * FROM orders 
WHERE MONTH(order_date) = 5 AND YEAR(order_date) = 2023
ORDER BY DAY(order_date);

-- 4. Show customer names and emails for customers who signed up in 2023
SELECT first_name , last_name , email FROM customers
WHERE YEAR(signup_date) = 2023;

-- 5. Find all electronics products, sorted by price (highest first)
SELECT * FROM products 
WHERE category = 'electronics' OR category = 'Electronics'
ORDER BY price DESC;


-- INTERMEDIATE LEVEL (JOINs, GROUP BY, Aggregations)
-- 6. Show customer names with their total order amounts
SELECT customers.first_name , sum(total_amount) as spendAmount FROM customers
LEFT JOIN orders
ON customers.customer_id = orders.customer_id
GROUP BY customers.customer_id , customers.first_name
ORDER BY spendAmount DESC;

-- 7. Find the top 3 best-selling products by quantity sold
SELECT products.product_name , SUM(order_items.quantity) as totalquan FROM products
LEFT JOIN order_items
ON products.product_id = order_items.product_id
GROUP BY products.product_name 
ORDER BY totalquan DESC  LIMIT 3;

-- 8. List customers who have never placed an order
SELECT customers.first_name , customers.last_name 
FROM customers
LEFT JOIN orders
ON orders.customer_id = customers.customer_id 
WHERE orders.order_id IS NULL;

-- 9. Show the average order value by country
SELECT customers.country , AVG(orders.total_amount)
FROM customers 
LEFT JOIN orders 
ON customers.customer_id = orders.customer_id
GROUP BY customers.country ;

-- 10. Find which products have been ordered together (same order)
SELECT  order_items.order_id  , products.product_name FROM order_items
LEFT JOIN products
ON products.product_id = order_items.product_id;

SELECT order_items.order_id, GROUP_CONCAT(products.product_name) as products_together
FROM order_items
LEFT JOIN products
ON products.product_id = order_items.product_id
GROUP BY order_items.order_id;

-- //// GROUP_CONCAT(products.product_name SEPARATOR ' + ') as products_together --

-- ADVANCED LEVEL (Subqueries, Window Functions, Complex JOINs)

-- 11. Find customers who spent more than the average customer
--  Step 1 : finding the avg of per coustomer 
SELECT customer_Id , SUM(total_amount) as sum FROM orders
GROUP BY customer_Id ;

--  Step 2 : Finding the avg og customer spending
SELECT AVG(sum) as avg_per_cus
FROM ( SELECT customer_Id , SUM(total_amount) as sum FROM orders
GROUP BY customer_Id ) as sum_costomer ;

SELECT customers.first_name FROM customers
LEFT JOIN ( SELECT customer_Id , SUM(total_amount) as sum FROM orders
GROUP BY customer_Id ) as sum_costomer
ON customers.customer_Id = sum_costomer.customer_Id 
WHERE sum_costomer.sum > (SELECT AVG(sum) as avg_per_cus
							FROM ( SELECT customer_Id , SUM(total_amount) as sum FROM orders
							GROUP BY customer_Id ) as sum_costomer)  ;
                            
-- 12. Show each customer's order history with running totals

-- This code is only show the customer total spending
SELECT customers.first_name, customers.last_name, SUM(orders.total_amount) AS total_spent
FROM customers
LEFT JOIN orders ON customers.customer_id = orders.customer_id 
GROUP BY customers.customer_id, customers.first_name, customers.last_name;

-- it is showing the all order in date wise 
SELECT customers.first_name, customers.last_name, 
       orders.order_date, orders.total_amount
FROM customers
LEFT JOIN orders ON customers.customer_id = orders.customer_id
ORDER BY customers.customer_id, orders.order_date;

-- Show each order with a row number
SELECT customer_id, order_date, total_amount,
       ROW_NUMBER() OVER (ORDER BY order_date) as row_num
FROM orders;

-- query for the qusation 
SELECT customers.first_name , customers.last_name , orders.order_date , orders.total_amount, 
SUM(total_amount) OVER
				(PARTITION BY customers.customer_id 			-- Separate calculation per customer
				ORDER BY orders.order_date) AS RUNNING_TOTAL		-- Add amounts chronologically
FROM customers
LEFT JOIN orders
ON customers.customer_id = orders.customer_id
ORDER BY customers.customer_id, orders.order_date ;

-- 13. Find the second highest order amount for each customer
SELECT customers.first_name , customers.last_name , orders.total_amount , 
RANK() OVER(PARTITION BY customers.customer_id ORDER BY total_amount DESC) 
FROM customers
LEFT JOIN orders
ON customers.customer_id = orders.customer_id
WHERE r = 2 ;

-- This Code change by CHATgpt so lookback darling
SELECT *
FROM (
    SELECT customers.first_name, customers.last_name, orders.total_amount, 
        RANK() OVER (PARTITION BY customers.customer_id ORDER BY orders.total_amount DESC) AS r
    FROM customers
    LEFT JOIN orders ON customers.customer_id = orders.customer_id
) AS ranked_orders
WHERE r = 2;

WITH ranked_orders AS (
    SELECT 
        customers.first_name, 
        customers.last_name, 
        orders.total_amount, 
        RANK() OVER (PARTITION BY customers.customer_id ORDER BY orders.total_amount DESC) AS r
    FROM customers
    LEFT JOIN orders ON customers.customer_id = orders.customer_id
)
SELECT *
FROM ranked_orders
WHERE r = 2;

-- 14. Identify customers who bought products from at least 2 categories
SELECT order_items.order_item_id , order_items.order_id , order_items.product_id , products.category , order_items.quantity FROM order_items
LEFT JOIN products
ON order_items.product_id = products.product_id;

SELECT orders.customer_id,tab.category,SUM(tab.quantity) AS total_quantity
FROM orders
LEFT JOIN (
    SELECT order_items.order_id,products.category,order_items.quantity
    FROM order_items
    LEFT JOIN products
    ON order_items.product_id = products.product_id
) AS tab
ON orders.order_id = tab.order_id
GROUP BY orders.customer_id, tab.category;

SELECT customers.first_name , customers.last_name , new_tab.total_quantity  FROM customers
LEFT JOIN (
			SELECT orders.customer_id,tab.category,SUM(tab.quantity) AS total_quantity
			FROM orders
			LEFT JOIN (
				SELECT order_items.order_id,products.category,order_items.quantity
				FROM order_items
				LEFT JOIN products
				ON order_items.product_id = products.product_id
			) AS tab
			ON orders.order_id = tab.order_id
			GROUP BY orders.customer_id, tab.category
) AS new_tab ON customers.customer_id = new_tab.customer_id 
WHERE total_quantity >= 2 ;

SELECT customers.first_name , customers.last_name , new_tab.total_quantity  FROM customers
LEFT JOIN (
			SELECT orders.customer_id,tab.category,COUNT(distinct(tab.category)) AS total_quantity
			FROM orders
			LEFT JOIN (
				SELECT order_items.order_id,products.category,order_items.quantity
				FROM order_items
				LEFT JOIN products
				ON order_items.product_id = products.product_id
			) AS tab
			ON orders.order_id = tab.order_id
			GROUP BY orders.customer_id, tab.category
) AS new_tab ON customers.customer_id = new_tab.customer_id 
WHERE total_quantity >= 2 ;

SELECT orders.customer_id,tab.category , COUNT(*)OVER(PARTITION BY orders.customer_id ORDER BY tab.category ) AS total_quantity
FROM orders
LEFT JOIN (
    SELECT order_items.order_id,products.category,order_items.quantity
    FROM order_items
    LEFT JOIN products
    ON order_items.product_id = products.product_id
) AS tab
ON orders.order_id = tab.order_id ;

SELECT * 
FROM customers
LEFT JOIN ( SELECT orders.customer_id,tab.category , COUNT(*)OVER(PARTITION BY orders.customer_id ) AS no_category
			FROM orders
			LEFT JOIN (
				SELECT order_items.order_id,products.category,order_items.quantity
				FROM order_items
				LEFT JOIN products
				ON order_items.product_id = products.product_id
			) AS tab
			ON orders.order_id = tab.order_id 
) AS new_tab
ON new_tab.customer_id = customers.customer_id 
WHERE new_tab.no_category >= 2;

-- Staring from now DATE : 11 Augest 2025
SELECT c.first_name , c.last_name , category_count.no_category
FROM customers c
LEFT JOIN (
    SELECT 
        o.customer_id,
        COUNT(DISTINCT p.category) AS no_category
    FROM orders o
    LEFT JOIN order_items oi
        ON o.order_id = oi.order_id
    LEFT JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY o.customer_id
) AS category_count
    ON c.customer_id = category_count.customer_id
WHERE category_count.no_category >= 2;


-- 15. Find the month-over-month growth in total sales
SELECT MONTH(order_date) , total_amount FROM orders
GROUP BY MONTH(order_date)
ORDER BY MONTH(order_date) , YEAR(order_date);

SELECT 
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month,
    SUM(total_amount) AS monthly_total
FROM orders
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date);

-- Modify the Q : Find the day-over-day growth in total sales
SELECT 
	DAY(order_date) AS order_day,
    MONTH(order_date) AS order_month,
    SUM(total_amount) AS daily_total,
    LAG(daily_total) OVER(ORDER BY order_date)
FROM orders
GROUP BY DAY(order_date) , MONTH(order_date)
ORDER BY DAY(order_date) , MONTH(order_date);


SELECT 
    order_date,
    daily_total,
    daily_total - LAG(daily_total) OVER (ORDER BY order_date) AS prev_day_total
FROM (
    SELECT 
        DATE(order_date) AS order_date,
        SUM(total_amount) AS daily_total
    FROM orders
    GROUP BY DATE(order_date)
) AS daily_sales   
ORDER BY order_date;


-- CHALLENGE QUESTIONS (Real business scenarios)
-- 16. Create a customer segmentation: VIP (>$500), Regular ($100-500), New (<$100)
-- 17. Find products that are frequently bought together (market basket analysis)
-- 18. Calculate customer lifetime value and acquisition cohorts
-- 19. Identify at-risk customers (haven't ordered in 30+ days)
-- 20. Build a sales dashboard query with key metrics

-- ========================================
-- LEARNING PROGRESSION TIPS:
-- ========================================
-- 1. Start with questions 1-5, make sure you can write them without looking up syntax
-- 2. Move to 6-10, focus on understanding JOINs and GROUP BY
-- 3. Try 11-15, practice subqueries and window functions
-- 4. Challenge yourself with 16-20, think like a business analyst
-- 
-- Don't look up answers immediately! Struggle with each query for 10-15 minutes first.
-- Write down what you're trying to achieve before writing the SQL.
-- Test your queries and verify the results make sense.