-- MySQL SQL Practice Problems - Questions and Answers (Part 3: Problems 21-25)

-- 4. Business Report Analysis
-- Problem 21: Sales Funnel Analysis
-- Business Scenario: An e-commerce platform needs to analyze the user conversion funnel from browsing to purchasing.
-- Table Structure: user_activity_logs, orders
-- Question: Write an SQL query to analyze the sales funnel for May 2023, counting users who browsed products, added to cart, created orders, and completed payment, along with conversion rates. Return the name of each stage, user count, and conversion rate from the previous stage.

-- Correct Answer:
WITH funnel_stages AS (
    SELECT '1. Browse Products' AS stage, COUNT(DISTINCT user_id) AS user_count
    FROM user_activity_logs
    WHERE YEAR(created_at) = 2023 AND MONTH(created_at) = 5
    AND activity_type = 'Product Browsing'
    
    UNION ALL
    
    SELECT '2. Add to Cart' AS stage, COUNT(DISTINCT user_id) AS user_count
    FROM user_activity_logs
    WHERE YEAR(created_at) = 2023 AND MONTH(created_at) = 5
    AND activity_type = 'Add to Cart'
    
    UNION ALL
    
    SELECT '3. Create Order' AS stage, COUNT(DISTINCT user_id) AS user_count
    FROM user_activity_logs
    WHERE YEAR(created_at) = 2023 AND MONTH(created_at) = 5
    AND activity_type = 'Place Order'
    
    UNION ALL
    
    SELECT '4. Complete Payment' AS stage, COUNT(DISTINCT user_id) AS user_count
    FROM user_activity_logs
    WHERE YEAR(created_at) = 2023 AND MONTH(created_at) = 5
    AND activity_type = 'Payment'
)
SELECT 
    stage,
    user_count,
    CASE 
        WHEN stage = '1. Browse Products' THEN NULL
        ELSE ROUND(user_count / LAG(user_count) OVER (ORDER BY stage) * 100, 2)
    END AS conversion_rate
FROM funnel_stages
ORDER BY stage;

-- Explanation:
-- 1. Create a CTE to calculate the number of users at each funnel stage
--    - Use UNION ALL to combine results from four queries
--    - Each query counts users for a specific activity type
-- 2. In the main query, use the LAG window function to get the user count from the previous stage
-- 3. Calculate conversion rate: current stage users / previous stage users * 100
-- 4. Use a CASE expression to handle the first stage, which has no previous stage
-- 5. Sort results by stage order


-- Problem 22: RFM Customer Analysis
-- Business Scenario: The marketing team needs to classify customers based on Recency, Frequency, and Monetary value.
-- Table Structure: users, orders, order_items
-- Question: Write an SQL query to calculate each user's last purchase date, purchase count, and total spending, then classify users as "High Value," "Medium Value," or "Low Value" based on these three dimensions. Return user ID, username, values for the three dimensions, and final classification.

-- Correct Answer:
WITH user_rfm AS (
    SELECT 
        u.user_id,
        u.username,
        DATEDIFF(CURRENT_DATE, MAX(o.order_date)) AS recency,
        COUNT(DISTINCT o.order_id) AS frequency,
        SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) AS monetary
    FROM users u
    LEFT JOIN orders o ON u.user_id = o.user_id
    LEFT JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.status = 'Completed'
    GROUP BY u.user_id, u.username
),
rfm_scores AS (
    SELECT 
        user_id,
        username,
        recency,
        frequency,
        monetary,
        CASE 
            WHEN recency <= 30 THEN 3
            WHEN recency <= 90 THEN 2
            ELSE 1
        END AS r_score,
        CASE 
            WHEN frequency >= 5 THEN 3
            WHEN frequency >= 2 THEN 2
            ELSE 1
        END AS f_score,
        CASE 
            WHEN monetary >= 10000 THEN 3
            WHEN monetary >= 1000 THEN 2
            ELSE 1
        END AS m_score
    FROM user_rfm
)
SELECT 
    user_id,
    username,
    recency AS days_since_last_purchase,
    frequency AS purchase_count,
    monetary AS total_spent,
    CASE 
        WHEN (r_score + f_score + m_score) >= 8 THEN 'High Value'
        WHEN (r_score + f_score + m_score) >= 5 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment
FROM rfm_scores
ORDER BY (r_score + f_score + m_score) DESC, user_id;

-- Explanation:
-- 1. Create a CTE user_rfm to calculate RFM metrics for each user
--    - recency: days since last purchase (difference between current date and last order date)
--    - frequency: number of purchases (count of distinct orders)
--    - monetary: total amount spent
-- 2. Create a CTE rfm_scores to assign scores for each dimension
--    - r_score: score based on recency (higher for more recent purchases)
--    - f_score: score based on frequency (higher for more frequent purchases)
--    - m_score: score based on monetary value (higher for larger spending)
-- 3. In the main query, classify customers based on the sum of their three scores
-- 4. Sort results by total score in descending order and user ID


-- Problem 23: Year-over-Year/Quarter-over-Quarter Growth Analysis
-- Business Scenario: The finance department needs to analyze year-over-year and quarter-over-quarter sales growth by product category.
-- Table Structure: orders, order_items, products, product_categories
-- Question: Write an SQL query to calculate sales for each product category by quarter in 2023, and the growth rates compared to the previous quarter and the same quarter last year. Return year, quarter, category name, sales amount, quarter-over-quarter growth rate, and year-over-year growth rate.

-- Correct Answer:
WITH quarterly_sales AS (
    SELECT 
        YEAR(o.order_date) AS year,
        QUARTER(o.order_date) AS quarter,
        pc.category_id,
        pc.category_name,
        SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) AS sales
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    JOIN product_categories pc ON p.category_id = pc.category_id
    WHERE YEAR(o.order_date) IN (2022, 2023)
    GROUP BY year, quarter, pc.category_id, pc.category_name
)
SELECT 
    q.year,
    q.quarter,
    q.category_name,
    q.sales,
    CASE 
        WHEN prev_q.sales IS NULL OR prev_q.sales = 0 THEN NULL
        ELSE ROUND((q.sales - prev_q.sales) / prev_q.sales * 100, 2)
    END AS qoq_growth,
    CASE 
        WHEN prev_y.sales IS NULL OR prev_y.sales = 0 THEN NULL
        ELSE ROUND((q.sales - prev_y.sales) / prev_y.sales * 100, 2)
    END AS yoy_growth
FROM quarterly_sales q
LEFT JOIN quarterly_sales prev_q ON q.year = prev_q.year 
    AND q.quarter = prev_q.quarter + 1 
    AND q.category_id = prev_q.category_id
    AND (q.quarter > 1 OR prev_q.quarter = 4 AND prev_q.year = q.year - 1)
LEFT JOIN quarterly_sales prev_y ON q.year = prev_y.year + 1 
    AND q.quarter = prev_y.quarter 
    AND q.category_id = prev_y.category_id
WHERE q.year = 2023
ORDER BY q.quarter, q.category_name;

-- Explanation:
-- 1. Create a CTE to calculate sales for each product category by quarter in 2022 and 2023
-- 2. Use self-joins to get:
--    - Previous quarter sales (prev_q)
--    - Same quarter last year sales (prev_y)
-- 3. Calculate quarter-over-quarter growth rate: (current sales - previous quarter sales) / previous quarter sales * 100
-- 4. Calculate year-over-year growth rate: (current sales - same quarter last year sales) / same quarter last year sales * 100
-- 5. Use CASE expressions to handle cases where previous period data is missing or sales were zero
-- 6. Filter for 2023 data and sort by quarter and category name


-- Problem 24: User Retention Rate Analysis
-- Business Scenario: The product team needs to analyze user retention after initial use.
-- Table Structure: users, user_activity_logs
-- Question: Write an SQL query to calculate the monthly retention rates for users who registered in January 2023 over the next 5 months. Return user registration month, each subsequent month, and the corresponding retention rate percentage.

-- Correct Answer:
WITH new_users AS (
    SELECT user_id
    FROM users
    WHERE YEAR(register_date) = 2023 AND MONTH(register_date) = 1
),
monthly_active_users AS (
    SELECT 
        DISTINCT ual.user_id,
        MONTH(ual.created_at) AS activity_month
    FROM user_activity_logs ual
    JOIN new_users nu ON ual.user_id = nu.user_id
    WHERE YEAR(ual.created_at) = 2023 
    AND MONTH(ual.created_at) BETWEEN 1 AND 6
),
retention_data AS (
    SELECT 
        1 AS cohort_month,
        activity_month,
        COUNT(DISTINCT user_id) AS active_users
    FROM monthly_active_users
    GROUP BY activity_month
)
SELECT 
    cohort_month,
    activity_month,
    active_users,
    ROUND(active_users / FIRST_VALUE(active_users) OVER (ORDER BY activity_month) * 100, 2) AS retention_rate
FROM retention_data
ORDER BY activity_month;

-- Explanation:
-- 1. Create a CTE new_users to get users who registered in January 2023
-- 2. Create a CTE monthly_active_users to track when these users were active from January to June
-- 3. Create a CTE retention_data to count active users by month
-- 4. Use the FIRST_VALUE window function to get the number of active users in the first month as a baseline
-- 5. Calculate retention rate: current month active users / first month active users * 100
-- 6. Sort results by month


-- Problem 25: Product Combination Analysis
-- Business Scenario: The marketing team wants to understand which products are frequently purchased together for bundled sales.
-- Table Structure: orders, order_items, products
-- Question: Write an SQL query to find the most commonly purchased product pairs within the same order. Return the name of the first product, the name of the second product, and the number of times they appear together, sorted by co-occurrence count in descending order, limited to the top 20 results.

-- Correct Answer:
WITH order_product_pairs AS (
    SELECT 
        o1.order_id,
        p1.product_id AS product_id1,
        p2.product_id AS product_id2,
        p1.product_name AS product_name1,
        p2.product_name AS product_name2
    FROM order_items o1
    JOIN order_items o2 ON o1.order_id = o2.order_id AND o1.product_id < o2.product_id
    JOIN products p1 ON o1.product_id = p1.product_id
    JOIN products p2 ON o2.product_id = p2.product_id
)
SELECT 
    product_name1,
    product_name2,
    COUNT(*) AS co_occurrence_count
FROM order_product_pairs
GROUP BY product_id1, product_id2, product_name1, product_name2
ORDER BY co_occurrence_count DESC
LIMIT 20;

-- Explanation:
-- 1. Create a CTE to generate product pairs
--    - Self-join the order_items table to find different products within the same order
--    - Use the condition o1.product_id < o2.product_id to ensure each product pair is counted only once
--    - Join with the products table to get product names
-- 2. Group by product pairs and count co-occurrences
-- 3. Sort by co-occurrence count in descending order
-- 4. Limit to the top 20 results 