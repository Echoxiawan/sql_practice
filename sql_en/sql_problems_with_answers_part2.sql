-- MySQL SQL Practice Problems - Questions and Answers (Part 2: Problems 11-20)

-- Problem 11: Multi-table Join
-- Business Scenario: Comprehensive order analysis report including user, product, and payment information.
-- Table Structure: users, orders, order_items, products, financial_transactions
-- Question: Write an SQL query to generate a detailed order report containing user information, order date, product details, payment amount, and payment method. Limit results to orders from May 2023, sorted by order date.

-- Correct Answer:
SELECT 
    o.order_id,
    u.username,
    u.email,
    o.order_date,
    p.product_name,
    oi.quantity,
    oi.unit_price,
    oi.discount,
    (oi.quantity * oi.unit_price * (1 - oi.discount)) AS item_total,
    ft.amount AS payment_amount,
    o.payment_method
FROM orders o
JOIN users u ON o.user_id = u.user_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
LEFT JOIN financial_transactions ft ON o.order_id = ft.order_id AND ft.transaction_type = 'Income'
WHERE YEAR(o.order_date) = 2023 AND MONTH(o.order_date) = 5
ORDER BY o.order_date, o.order_id, p.product_name;

-- Explanation:
-- 1. Join multiple related tables to get complete order information:
--    - Join orders table with users table using user_id
--    - Join orders table with order_items table using order_id
--    - Join order_items table with products table using product_id
--    - Join orders table with financial_transactions table using order_id, and limit to transactions of type "Income"
-- 2. Calculate the total amount for each order item (item_total)
-- 3. Use the WHERE clause to filter orders from May 2023
-- 4. Sort by order date, order ID, and product name


-- 3. Data Aggregation
-- Problem 12: Basic Aggregation and Grouping
-- Business Scenario: The sales department needs to analyze sales trends by quarter and product category.
-- Table Structure: orders, order_items, products, product_categories
-- Question: Write an SQL query to calculate sales by quarter and product category for 2023. Return year, quarter, category name, and total sales amount, sorted by quarter and sales amount in descending order.

-- Correct Answer:
SELECT 
    2023 AS year,
    QUARTER(o.order_date) AS quarter,
    pc.category_name,
    SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) AS total_sales
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
JOIN product_categories pc ON p.category_id = pc.category_id
WHERE YEAR(o.order_date) = 2023
GROUP BY QUARTER(o.order_date), pc.category_id, pc.category_name
ORDER BY quarter, total_sales DESC;

-- Explanation:
-- 1. Use the QUARTER() function to get the quarter from the order date
-- 2. Join relevant tables to get order, product, and category information
-- 3. Use WHERE to filter orders from 2023
-- 4. Group by quarter and product category to calculate total sales
-- 5. Sort by quarter and total sales in descending order


-- Problem 13: HAVING Clause
-- Business Scenario: Identify high-sales but low-rated products that may need quality improvements.
-- Table Structure: products, order_items, reviews
-- Question: Write an SQL query to find products with sales exceeding 10000 but with an average rating below 4. Return product name, total sales, review count, and average rating, sorted by average rating in ascending order.

-- Correct Answer:
SELECT 
    p.product_name,
    SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) AS total_sales,
    COUNT(r.review_id) AS review_count,
    AVG(r.rating) AS avg_rating
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
LEFT JOIN reviews r ON p.product_id = r.product_id
GROUP BY p.product_id, p.product_name
HAVING total_sales > 10000 AND avg_rating < 4
ORDER BY avg_rating ASC;

-- Explanation:
-- 1. Join products and order_items tables to calculate sales
-- 2. Use LEFT JOIN with reviews table to get rating information (ensuring products with no reviews are included)
-- 3. Group by product to calculate total sales, review count, and average rating
-- 4. Use HAVING to filter for products with sales over 10000 and average rating below 4
-- 5. Sort by average rating in ascending order


-- Problem 14: Complex Grouping and Aggregation
-- Business Scenario: Analyze spending patterns of different user levels across different seasons.
-- Table Structure: users, orders, order_items
-- Question: Write an SQL query to calculate spending by user level and season. Return user level, season (Spring, Summer, Autumn, Winter), order count, and total spending, sorted by user level and total spending in descending order.

-- Correct Answer:
SELECT 
    u.user_level,
    CASE 
        WHEN MONTH(o.order_date) IN (3, 4, 5) THEN 'Spring'
        WHEN MONTH(o.order_date) IN (6, 7, 8) THEN 'Summer'
        WHEN MONTH(o.order_date) IN (9, 10, 11) THEN 'Autumn'
        ELSE 'Winter'
    END AS season,
    COUNT(DISTINCT o.order_id) AS order_count,
    SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) AS total_amount
FROM users u
JOIN orders o ON u.user_id = o.user_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY u.user_level, season
ORDER BY u.user_level, total_amount DESC;

-- Explanation:
-- 1. Join users, orders, and order_items tables to get complete order information
-- 2. Use a CASE expression to determine the season based on the order month:
--    - March-May: Spring
--    - June-August: Summer
--    - September-November: Autumn
--    - December, January, February: Winter
-- 3. Group by user level and season to calculate order count and total spending
-- 4. Use COUNT(DISTINCT order_id) to ensure correct order count calculation
-- 5. Sort by user level and total spending in descending order


-- Problem 15: Aggregate Functions with CASE Expression
-- Business Scenario: Analyze product sales performance in different price ranges.
-- Table Structure: products, order_items
-- Question: Write an SQL query to categorize products as "Low Price" (<100), "Medium Price" (100-1000), and "High Price" (>1000), and calculate the number of products, total sales, and average selling price for each group, sorted by price group in ascending order.

-- Correct Answer:
SELECT 
    CASE 
        WHEN p.unit_price < 100 THEN 'Low Price'
        WHEN p.unit_price BETWEEN 100 AND 1000 THEN 'Medium Price'
        ELSE 'High Price'
    END AS price_category,
    COUNT(DISTINCT p.product_id) AS product_count,
    SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) AS total_sales,
    AVG(oi.unit_price) AS avg_selling_price
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY price_category
ORDER BY 
    CASE 
        WHEN price_category = 'Low Price' THEN 1
        WHEN price_category = 'Medium Price' THEN 2
        ELSE 3
    END;

-- Explanation:
-- 1. Use a CASE expression to categorize products into three price groups based on unit price
-- 2. Use LEFT JOIN to connect products and order_items tables, ensuring products with no sales records are included
-- 3. Group by price category to calculate the number of products, total sales, and average selling price for each group
-- 4. Use a nested CASE expression in ORDER BY to ensure price groups are sorted as "Low Price", "Medium Price", "High Price"


-- Problem 16: Window Functions Basics
-- Business Scenario: The sales team needs to analyze month-over-month sales growth.
-- Table Structure: orders, order_items, products
-- Question: Write an SQL query to calculate the total sales for each month in 2023 and the growth percentage compared to the previous month. Return year-month, sales amount, and month-over-month growth rate, sorted by year-month.

-- Correct Answer:
WITH monthly_sales AS (
    SELECT 
        DATE_FORMAT(o.order_date, '%Y-%m') AS order_month,  -- Avoid year_month as a keyword
        SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) AS monthly_sales
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE YEAR(o.order_date) = 2023
    GROUP BY order_month
)
SELECT 
    order_month,
    monthly_sales,
    CASE 
        WHEN LAG(monthly_sales) OVER (ORDER BY order_month) IS NULL THEN NULL
        ELSE ROUND((monthly_sales - LAG(monthly_sales) OVER (ORDER BY order_month)) / 
             LAG(monthly_sales) OVER (ORDER BY order_month) * 100, 2)
    END AS month_over_month_growth
FROM monthly_sales
ORDER BY order_month;


-- Explanation:
-- 1. Use a CTE to calculate the total sales for each month in 2023
-- 2. In the main query, use the LAG window function to get the previous month's sales
-- 3. Calculate the month-over-month growth rate: (current month sales - previous month sales) / previous month sales * 100
-- 4. Use a CASE expression to handle the first month, which has no previous month's sales
-- 5. Sort by year-month


-- Problem 17: Window Functions with Ranking
-- Business Scenario: Identify the best-selling products in each category.
-- Table Structure: products, order_items, product_categories
-- Question: Write an SQL query to find the top 3 products by sales amount in each product category. Return category name, product name, sales amount, and rank within the category, sorted by category name and rank.

-- Correct Answer:
WITH product_sales AS (
    SELECT 
        pc.category_id,
        pc.category_name,
        p.product_id,
        p.product_name,
        SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) AS total_sales,
        DENSE_RANK() OVER (PARTITION BY pc.category_id ORDER BY SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) DESC) AS sales_rank
    FROM product_categories pc
    JOIN products p ON pc.category_id = p.category_id
    JOIN order_items oi ON p.product_id = oi.product_id
    GROUP BY pc.category_id, pc.category_name, p.product_id, p.product_name
)
SELECT 
    category_name,
    product_name,
    total_sales,
    sales_rank
FROM product_sales
WHERE sales_rank <= 3
ORDER BY category_name, sales_rank;

-- Explanation:
-- 1. Create a CTE to calculate the sales for each product
-- 2. Use the DENSE_RANK window function to rank products within each category
--    - PARTITION BY category_id ensures ranking is done separately within each category
--    - ORDER BY SUM(...) DESC ensures ranking is based on sales in descending order
-- 3. In the main query, filter for products with rank 3 or better
-- 4. Sort by category name and rank


-- Problem 18: Cumulative Sum Window Function
-- Business Scenario: The finance team needs to analyze cumulative sales achievement.
-- Table Structure: orders, order_items
-- Question: Write an SQL query to calculate daily sales and cumulative sales for 2023. Return date, daily sales amount, and cumulative sales amount, sorted by date.

-- Correct Answer:
WITH daily_sales AS (
    SELECT 
        DATE(o.order_date) AS sale_date,
        SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) AS daily_total
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE YEAR(o.order_date) = 2023
    GROUP BY DATE(o.order_date)
)
SELECT 
    sale_date,
    daily_total,
    SUM(daily_total) OVER (ORDER BY sale_date) AS cumulative_sales
FROM daily_sales
ORDER BY sale_date;

-- Explanation:
-- 1. Create a CTE to calculate the total sales for each day in 2023
-- 2. Use the SUM window function to calculate cumulative sales
--    - OVER (ORDER BY sale_date) ensures the cumulative sum is calculated in date order
-- 3. Sort the results by date


-- Problem 19: Moving Average Window Function
-- Business Scenario: Sales trend analysis, smoothing short-term fluctuations.
-- Table Structure: orders, order_items
-- Question: Write an SQL query to calculate daily sales and 7-day moving average sales for 2023. Return date, daily sales amount, and 7-day moving average, sorted by date.

-- Correct Answer:
WITH daily_sales AS (
    SELECT 
        DATE(o.order_date) AS sale_date,
        SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) AS daily_total
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE YEAR(o.order_date) = 2023
    GROUP BY DATE(o.order_date)
)
SELECT 
    sale_date,
    daily_total,
    AVG(daily_total) OVER (
        ORDER BY sale_date
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS seven_day_moving_avg
FROM daily_sales
ORDER BY sale_date;

-- Explanation:
-- 1. Create a CTE to calculate the total sales for each day in 2023
-- 2. Use the AVG window function to calculate the 7-day moving average
--    - ROWS BETWEEN 6 PRECEDING AND CURRENT ROW defines the window as the current row and the 6 rows before it (for a total of 7 days)
-- 3. Sort the results by date


-- Problem 20: Window Functions with Partition Comparison
-- Business Scenario: Compare each product's sales with the average sales of its category.
-- Table Structure: products, order_items, product_categories
-- Question: Write an SQL query to calculate each product's sales, the average sales of its category, and the percentage deviation from the category average. Return product name, product sales, category average sales, and percentage deviation, sorted by percentage deviation in descending order.

-- Correct Answer:
WITH product_sales AS (
    SELECT 
        p.product_id,
        p.product_name,
        p.category_id,
        SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) AS product_sales
    FROM products p
    JOIN order_items oi ON p.product_id = oi.product_id
    GROUP BY p.product_id, p.product_name, p.category_id
)
SELECT 
    ps.product_name,
    ps.product_sales,
    AVG(ps.product_sales) OVER (PARTITION BY ps.category_id) AS category_avg_sales,
    ROUND((ps.product_sales - AVG(ps.product_sales) OVER (PARTITION BY ps.category_id)) / 
          AVG(ps.product_sales) OVER (PARTITION BY ps.category_id) * 100, 2) AS deviation_percentage
FROM product_sales ps
JOIN product_categories pc ON ps.category_id = pc.category_id
ORDER BY deviation_percentage DESC;

-- Explanation:
-- 1. Create a CTE to calculate the total sales for each product
-- 2. Use the AVG window function to calculate the average sales for each category
--    - PARTITION BY category_id ensures the average is calculated separately for each category
-- 3. Calculate the percentage deviation: (product sales - category average sales) / category average sales * 100
-- 4. Sort the results by percentage deviation in descending order 