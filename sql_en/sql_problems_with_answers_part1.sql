-- MySQL SQL Practice Problems - Questions and Answers (Part 1: Problems 1-10)

-- 1. Complex Queries - Subqueries
-- Problem 1: Basic Subquery
-- Business Scenario: An e-commerce platform needs to find all users who have purchased products priced higher than the average product price.
-- Table Structure: users, orders, order_items, products
-- Question: Write an SQL query to return the usernames and emails of users who have purchased products priced higher than the average product price. Results should not contain duplicates.

-- Correct Answer:
SELECT DISTINCT u.username, u.email
FROM users u
JOIN orders o ON u.user_id = o.user_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE p.unit_price > (SELECT AVG(unit_price) FROM products)
ORDER BY u.username;

-- Explanation:
-- 1. First, we use a subquery to calculate the average price of all products (SELECT AVG(unit_price) FROM products)
-- 2. Then, we use multiple table joins to find users who have purchased products with prices higher than the average:
--    - Join users table with orders table using user_id
--    - Join orders table with order_items table using order_id
--    - Join order_items table with products table using product_id
-- 3. Use the DISTINCT keyword to remove duplicate users
-- 4. Finally, sort the results by username


-- Problem 2: Correlated Subquery
-- Business Scenario: The marketing team needs to identify high-value users whose purchase frequency is above average.
-- Table Structure: users, orders
-- Question: Write an SQL query to find users who have placed more orders than the average order count across all users. Return username, email, and order count, sorted by order count in descending order.

-- Correct Answer:
WITH user_order_counts AS (
    SELECT u.user_id, u.username, u.email, COUNT(o.order_id) AS order_count
    FROM users u
    LEFT JOIN orders o ON u.user_id = o.user_id
    GROUP BY u.user_id, u.username, u.email
)
SELECT username, email, order_count
FROM user_order_counts
WHERE order_count > (
    SELECT AVG(order_count) 
    FROM user_order_counts
)
ORDER BY order_count DESC;

-- Explanation:
-- 1. Use a Common Table Expression (CTE) user_order_counts to calculate the number of orders for each user
-- 2. In the CTE, use LEFT JOIN to ensure users with no orders are included, with their order count as 0
-- 3. In the main query, use a subquery to calculate the average order count across all users
-- 4. Filter for users with order counts higher than the average
-- 5. Finally, sort by order count in descending order


-- Problem 3: EXISTS Subquery
-- Business Scenario: The sales team needs to find users who have made at least one purchase but have never returned any items.
-- Table Structure: users, orders, returns
-- Question: Write an SQL query to return the username, email, and registration date of users who have at least one order but no return records.

-- Correct Answer:
SELECT u.username, u.email, u.register_date
FROM users u
WHERE EXISTS (
    SELECT 1 FROM orders o WHERE o.user_id = u.user_id
) 
AND NOT EXISTS (
    SELECT 1 FROM orders o 
    JOIN returns r ON o.order_id = r.order_id 
    WHERE o.user_id = u.user_id
)
ORDER BY u.register_date;

-- Explanation:
-- 1. Use EXISTS subquery to check if the user has any orders
-- 2. Use NOT EXISTS subquery to check if the user has no return records
--    - This is done by joining orders and returns tables, and looking for return records associated with the user
-- 3. Combine both conditions to find users with orders but no returns
-- 4. Finally, sort by registration date


-- Problem 4: Multi-level Nested Subquery
-- Business Scenario: The product team wants to analyze the most popular product categories in high-value orders.
-- Table Structure: orders, order_items, products, product_categories
-- Question: Write an SQL query to find the three most frequently appearing product categories in orders with a total amount exceeding 1000 yuan. Return category name and occurrence count, sorted by occurrence count in descending order.

-- Correct Answer:
WITH high_value_orders AS (
    SELECT o.order_id
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY o.order_id
    HAVING SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) > 1000
)
SELECT pc.category_name, COUNT(oi.order_item_id) AS appearance_count
FROM high_value_orders hvo
JOIN order_items oi ON hvo.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
JOIN product_categories pc ON p.category_id = pc.category_id
GROUP BY pc.category_id, pc.category_name
ORDER BY appearance_count DESC
LIMIT 3;

-- Explanation:
-- 1. Create a CTE high_value_orders to find orders with total amount exceeding 1000 yuan
--    - The total amount calculation includes quantity, unit price, and discount
-- 2. Join high_value_orders, order_items, products, and product_categories tables
-- 3. Group by product category and count how many times each category appears in high-value orders
-- 4. Sort by appearance count in descending order and limit to the top three results


-- Problem 5: Subquery with Aggregate Functions
-- Business Scenario: The finance department needs to analyze monthly sales compared to the annual average.
-- Table Structure: orders, order_items
-- Question: Write an SQL query to calculate the total sales for each month in 2023 and compare it with the monthly average for that year. Return month, monthly sales, annual monthly average, and percentage difference, sorted by month.

-- Correct Answer:
WITH monthly_sales AS (
    SELECT 
        MONTH(o.order_date) AS month,
        SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) AS monthly_total
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE YEAR(o.order_date) = 2023
    GROUP BY MONTH(o.order_date)
),
yearly_average AS (
    SELECT AVG(monthly_total) AS avg_monthly_sales
    FROM monthly_sales
)
SELECT 
    ms.month,
    ms.monthly_total,
    ya.avg_monthly_sales,
    ROUND((ms.monthly_total - ya.avg_monthly_sales) / ya.avg_monthly_sales * 100, 2) AS percentage_diff
FROM monthly_sales ms, yearly_average ya
ORDER BY ms.month;

-- Explanation:
-- 1. Create a CTE monthly_sales to calculate the total sales for each month in 2023
-- 2. Create a CTE yearly_average to calculate the average monthly sales for 2023
-- 3. In the main query, join these two CTEs
-- 4. Calculate the percentage difference between each month's sales and the monthly average
-- 5. Sort the results by month


-- 2. Multi-table Joins
-- Problem 6: Inner Join
-- Business Scenario: The sales team needs to analyze sales performance by product category.
-- Table Structure: product_categories, products, order_items, orders
-- Question: Write an SQL query to calculate the total sales amount for each product category. Return category name and total sales amount, sorted by total sales in descending order, showing only categories with sales over 10000.

-- Correct Answer:
SELECT 
    pc.category_name,
    SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) AS total_sales
FROM product_categories pc
JOIN products p ON pc.category_id = p.category_id
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
GROUP BY pc.category_id, pc.category_name
HAVING total_sales > 10000
ORDER BY total_sales DESC;

-- Explanation:
-- 1. Use INNER JOIN to connect all relevant tables:
--    - Join product_categories table with products table using category_id
--    - Join products table with order_items table using product_id
--    - Join order_items table with orders table using order_id
-- 2. Calculate the total sales for each product category, considering quantity, unit price, and discount
-- 3. Use the HAVING clause to filter for categories with sales over 10000
-- 4. Sort the results by total sales in descending order


-- Problem 7: Left Join
-- Business Scenario: The inventory management team needs to analyze the relationship between product sales and inventory.
-- Table Structure: products, order_items, inventory
-- Question: Write an SQL query to find the sales volume and current inventory ratio for all products. Return product name, total sales volume, current total inventory, and sales-to-inventory ratio, including products with no sales records.

-- Correct Answer:
WITH product_sales AS (
    SELECT 
        p.product_id,
        p.product_name,
        COALESCE(SUM(oi.quantity), 0) AS total_sold
    FROM products p
    LEFT JOIN order_items oi ON p.product_id = oi.product_id
    GROUP BY p.product_id, p.product_name
),
product_inventory AS (
    SELECT 
        p.product_id,
        p.product_name,
        COALESCE(SUM(i.quantity), 0) AS total_inventory
    FROM products p
    LEFT JOIN inventory i ON p.product_id = i.product_id
    GROUP BY p.product_id, p.product_name
)
SELECT 
    ps.product_name,
    ps.total_sold,
    pi.total_inventory,
    CASE 
        WHEN pi.total_inventory = 0 THEN NULL
        ELSE ROUND(ps.total_sold / pi.total_inventory * 100, 2)
    END AS sales_inventory_ratio
FROM product_sales ps
JOIN product_inventory pi ON ps.product_id = pi.product_id
ORDER BY 
    CASE 
        WHEN sales_inventory_ratio IS NULL THEN 2
        ELSE 1
    END,
    sales_inventory_ratio DESC;

-- Explanation:
-- 1. Create a CTE product_sales to calculate the total sales volume for each product
--    - Use LEFT JOIN to ensure products with no sales records are included
--    - Use the COALESCE function to convert NULL values to 0
-- 2. Create a CTE product_inventory to calculate the total inventory for each product
-- 3. Join these two CTEs and calculate the sales-to-inventory ratio
-- 4. Use a CASE statement to handle cases where inventory is 0
-- 5. Sort by sales-to-inventory ratio in descending order, with NULL values last


-- Problem 8: Right Join
-- Business Scenario: Employee performance evaluation, analyzing sales staff performance.
-- Table Structure: employees, sales
-- Question: Write an SQL query to analyze the sales performance of all employees in the sales department (including employees with no sales records). Return employee name, position, total sales amount, and average commission, sorted by total sales amount in descending order.

-- Correct Answer:
SELECT 
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    e.title,
    COALESCE(SUM(s.commission), 0) AS total_sales,
    CASE 
        WHEN COUNT(s.sale_id) = 0 THEN 0
        ELSE ROUND(AVG(s.commission), 2)
    END AS avg_commission
FROM employees e
LEFT JOIN sales s ON e.employee_id = s.employee_id
WHERE e.department = 'Sales Department'
GROUP BY e.employee_id, employee_name, e.title
ORDER BY total_sales DESC;

-- Explanation:
-- 1. Use LEFT JOIN to connect employees and sales tables
--    - The problem asks for RIGHT JOIN, but LEFT JOIN is more intuitive and achieves the same result
-- 2. Filter for employees in the sales department
-- 3. Use the CONCAT function to combine first and last names
-- 4. Calculate total sales and average commission for each employee
-- 5. Use a CASE statement to handle employees with no sales records
-- 6. Sort results by total sales in descending order


-- Problem 9: Full Join (simulated using LEFT JOIN + UNION + RIGHT JOIN)
-- Business Scenario: The marketing team needs a comprehensive understanding of the relationship between user activities and orders.
-- Table Structure: users, orders, user_activity_logs
-- Question: Write an SQL query to get activity and order statistics for all users, including users with no activity records and users with no orders. Return username, activity count, order count, and last activity date.

-- Correct Answer:
-- MySQL doesn't directly support FULL JOIN, so we simulate it using UNION
SELECT 
    u.username,
    COALESCE(activity_count, 0) AS activity_count,
    COALESCE(order_count, 0) AS order_count,
    last_activity_date
FROM users u
LEFT JOIN (
    SELECT 
        user_id, 
        COUNT(log_id) AS activity_count,
        MAX(created_at) AS last_activity_date
    FROM user_activity_logs
    GROUP BY user_id
) a ON u.user_id = a.user_id
LEFT JOIN (
    SELECT 
        user_id, 
        COUNT(order_id) AS order_count
    FROM orders
    GROUP BY user_id
) o ON u.user_id = o.user_id

UNION

SELECT 
    u.username,
    COALESCE(activity_count, 0) AS activity_count,
    COALESCE(order_count, 0) AS order_count,
    last_activity_date
FROM (
    SELECT 
        user_id, 
        COUNT(log_id) AS activity_count,
        MAX(created_at) AS last_activity_date
    FROM user_activity_logs
    GROUP BY user_id
) a
RIGHT JOIN users u ON a.user_id = u.user_id
LEFT JOIN (
    SELECT 
        user_id, 
        COUNT(order_id) AS order_count
    FROM orders
    GROUP BY user_id
) o ON u.user_id = o.user_id
WHERE a.user_id IS NULL

ORDER BY username;

-- Explanation:
-- 1. MySQL doesn't directly support FULL JOIN, so we use a UNION of LEFT JOIN and RIGHT JOIN to simulate it
-- 2. The first query gets all users and their activity and order statistics
-- 3. The second query gets users who have no records in the activity logs but exist in the users table
-- 4. Combine the result sets to ensure we capture all users
-- 5. Use the COALESCE function to convert NULL values to 0
-- 6. Finally, sort by username


-- Problem 10: Self Join
-- Business Scenario: The HR department needs to generate an organizational structure report.
-- Table Structure: employees
-- Question: Write an SQL query to generate a report showing each employee and their direct supervisor. Return employee name, employee position, supervisor name, and supervisor position. For employees with no supervisor, display "Top Manager" for supervisor information.

-- Correct Answer:
SELECT 
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    e.title AS employee_title,
    COALESCE(CONCAT(m.first_name, ' ', m.last_name), 'Top Manager') AS manager_name,
    COALESCE(m.title, 'Top Manager') AS manager_title
FROM employees e
LEFT JOIN employees m ON e.report_to = m.employee_id
ORDER BY 
    CASE WHEN e.report_to IS NULL THEN 0 ELSE 1 END,
    employee_name;

-- Explanation:
-- 1. Use SELF JOIN to connect the employees table to itself
--    - First instance represents employees (e)
--    - Second instance represents supervisors (m)
-- 2. Use LEFT JOIN to ensure employees with no supervisor are included
-- 3. Use the CONCAT function to combine names
-- 4. Use the COALESCE function to set "Top Manager" for employees with no supervisor
-- 5. Use a CASE expression in ORDER BY to ensure top managers appear first