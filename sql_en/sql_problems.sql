-- MySQL SQL Practice Problems - Questions Only

-- 1. Complex Queries - Subqueries
-- Problem 1: Basic Subquery
-- Business Scenario: An e-commerce platform needs to find all users who have purchased products priced higher than the average product price.
-- Table Structure: users, orders, order_items, products
-- Question: Write an SQL query to return the usernames and emails of users who have purchased products priced higher than the average product price. Results should not contain duplicates.

-- Problem 2: Correlated Subquery
-- Business Scenario: The marketing team needs to identify high-value users whose purchase frequency is above average.
-- Table Structure: users, orders
-- Question: Write an SQL query to find users who have placed more orders than the average order count across all users. Return username, email, and order count, sorted by order count in descending order.

-- Problem 3: EXISTS Subquery
-- Business Scenario: The sales team needs to find users who have made at least one purchase but have never returned any items.
-- Table Structure: users, orders, returns
-- Question: Write an SQL query to return the username, email, and registration date of users who have at least one order but no return records.

-- Problem 4: Multi-level Nested Subquery
-- Business Scenario: The product team wants to analyze the most popular product categories in high-value orders.
-- Table Structure: orders, order_items, products, product_categories
-- Question: Write an SQL query to find the three most frequently appearing product categories in orders with a total amount exceeding 1000 yuan. Return category name and occurrence count, sorted by occurrence count in descending order.

-- Problem 5: Subquery with Aggregate Functions
-- Business Scenario: The finance department needs to analyze monthly sales compared to the annual average.
-- Table Structure: orders, order_items
-- Question: Write an SQL query to calculate the total sales for each month in 2023 and compare it with the monthly average for that year. Return month, monthly sales, annual monthly average, and percentage difference, sorted by month.

-- 2. Multi-table Joins
-- Problem 6: Inner Join
-- Business Scenario: The sales team needs to analyze sales performance by product category.
-- Table Structure: product_categories, products, order_items, orders
-- Question: Write an SQL query to calculate the total sales amount for each product category. Return category name and total sales amount, sorted by total sales in descending order, showing only categories with sales over 10000.

-- Problem 7: Left Join
-- Business Scenario: The inventory management team needs to analyze the relationship between product sales and inventory.
-- Table Structure: products, order_items, inventory
-- Question: Write an SQL query to find the sales volume and current inventory ratio for all products. Return product name, total sales volume, current total inventory, and sales-to-inventory ratio, including products with no sales records.

-- Problem 8: Right Join
-- Business Scenario: Employee performance evaluation, analyzing sales staff performance.
-- Table Structure: employees, sales
-- Question: Write an SQL query to analyze the sales performance of all employees in the sales department (including employees with no sales records). Return employee name, position, total sales amount, and average commission, sorted by total sales amount in descending order.

-- Problem 9: Full Join (simulated using LEFT JOIN + UNION + RIGHT JOIN)
-- Business Scenario: The marketing team needs a comprehensive understanding of the relationship between user activities and orders.
-- Table Structure: users, orders, user_activity_logs
-- Question: Write an SQL query to get activity and order statistics for all users, including users with no activity records and users with no orders. Return username, activity count, order count, and last activity date.

-- Problem 10: Self Join
-- Business Scenario: The HR department needs to generate an organizational structure report.
-- Table Structure: employees
-- Question: Write an SQL query to generate a report showing each employee and their direct supervisor. Return employee name, employee position, supervisor name, and supervisor position. For employees with no supervisor, display "Top Manager" for supervisor information.

-- Problem 11: Multi-table Join
-- Business Scenario: Comprehensive order analysis report including user, product, and payment information.
-- Table Structure: users, orders, order_items, products, financial_transactions
-- Question: Write an SQL query to generate a detailed order report containing user information, order date, product details, payment amount, and payment method. Limit results to orders from May 2023, sorted by order date.

-- 3. Data Aggregation
-- Problem 12: Basic Aggregation and Grouping
-- Business Scenario: The sales department needs to analyze sales trends by quarter and product category.
-- Table Structure: orders, order_items, products, product_categories
-- Question: Write an SQL query to calculate sales by quarter and product category for 2023. Return year, quarter, category name, and total sales amount, sorted by quarter and sales amount in descending order.

-- Problem 13: HAVING Clause
-- Business Scenario: Identify high-sales but low-rated products that may need quality improvements.
-- Table Structure: products, order_items, reviews
-- Question: Write an SQL query to find products with sales exceeding 10000 but with an average rating below 4. Return product name, total sales, review count, and average rating, sorted by average rating in ascending order.

-- Problem 14: Complex Grouping and Aggregation
-- Business Scenario: Analyze spending patterns of different user levels across different seasons.
-- Table Structure: users, orders, order_items
-- Question: Write an SQL query to calculate spending by user level and season. Return user level, season (Spring, Summer, Autumn, Winter), order count, and total spending, sorted by user level and total spending in descending order.

-- Problem 15: Aggregate Functions with CASE Expression
-- Business Scenario: Analyze product sales performance in different price ranges.
-- Table Structure: products, order_items
-- Question: Write an SQL query to categorize products as "Low Price" (<100), "Medium Price" (100-1000), and "High Price" (>1000), and calculate the number of products, total sales, and average selling price for each group, sorted by price group in ascending order.

-- Problem 16: Window Functions Basics
-- Business Scenario: The sales team needs to analyze month-over-month sales growth.
-- Table Structure: orders, order_items, products
-- Question: Write an SQL query to calculate the total sales for each month in 2023 and the growth percentage compared to the previous month. Return year-month, sales amount, and month-over-month growth rate, sorted by year-month.

-- Problem 17: Window Functions with Ranking
-- Business Scenario: Identify the best-selling products in each category.
-- Table Structure: products, order_items, product_categories
-- Question: Write an SQL query to find the top 3 products by sales amount in each product category. Return category name, product name, sales amount, and rank within the category, sorted by category name and rank.

-- Problem 18: Cumulative Sum Window Function
-- Business Scenario: The finance team needs to analyze cumulative sales achievement.
-- Table Structure: orders, order_items
-- Question: Write an SQL query to calculate daily sales and cumulative sales for 2023. Return date, daily sales amount, and cumulative sales amount, sorted by date.

-- Problem 19: Moving Average Window Function
-- Business Scenario: Sales trend analysis, smoothing short-term fluctuations.
-- Table Structure: orders, order_items
-- Question: Write an SQL query to calculate daily sales and 7-day moving average sales for 2023. Return date, daily sales amount, and 7-day moving average, sorted by date.

-- Problem 20: Window Functions with Partition Comparison
-- Business Scenario: Compare each product's sales with the average sales of its category.
-- Table Structure: products, order_items, product_categories
-- Question: Write an SQL query to calculate each product's sales, the average sales of its category, and the percentage deviation from the category average. Return product name, product sales, category average sales, and percentage deviation, sorted by percentage deviation in descending order.

-- 4. Business Report Analysis
-- Problem 21: Sales Funnel Analysis
-- Business Scenario: An e-commerce platform needs to analyze the user conversion funnel from browsing to purchasing.
-- Table Structure: user_activity_logs, orders
-- Question: Write an SQL query to analyze the sales funnel for May 2023, counting users who browsed products, added to cart, created orders, and completed payment, along with conversion rates. Return the name of each stage, user count, and conversion rate from the previous stage.

-- Problem 22: RFM Customer Analysis
-- Business Scenario: The marketing team needs to classify customers based on Recency, Frequency, and Monetary value.
-- Table Structure: users, orders, order_items
-- Question: Write an SQL query to calculate each user's last purchase date, purchase count, and total spending, then classify users as "High Value," "Medium Value," or "Low Value" based on these three dimensions. Return user ID, username, values for the three dimensions, and final classification.

-- Problem 23: Year-over-Year/Quarter-over-Quarter Growth Analysis
-- Business Scenario: The finance department needs to analyze year-over-year and quarter-over-quarter sales growth by product category.
-- Table Structure: orders, order_items, products, product_categories
-- Question: Write an SQL query to calculate sales for each product category by quarter in 2023, and the growth rates compared to the previous quarter and the same quarter last year. Return year, quarter, category name, sales amount, quarter-over-quarter growth rate, and year-over-year growth rate.

-- Problem 24: User Retention Rate Analysis
-- Business Scenario: The product team needs to analyze user retention after initial use.
-- Table Structure: users, user_activity_logs
-- Question: Write an SQL query to calculate the monthly retention rates for users who registered in January 2023 over the next 5 months. Return user registration month, each subsequent month, and the corresponding retention rate percentage.

-- Problem 25: Product Combination Analysis
-- Business Scenario: The marketing team wants to understand which products are frequently purchased together for bundled sales.
-- Table Structure: orders, order_items, products
-- Question: Write an SQL query to find the most commonly purchased product pairs within the same order. Return the name of the first product, the name of the second product, and the number of times they appear together, sorted by co-occurrence count in descending order, limited to the top 20 results. 