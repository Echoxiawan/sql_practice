-- MySQL SQL练习题 - 问题与答案（第3部分：题目21-25）

-- 4. 业务报表分析
-- 题目21：销售漏斗分析
-- 业务场景：电商平台需要分析用户从浏览到购买的转化漏斗。
-- 表结构：user_activity_logs, orders
-- 问题：编写SQL查询，分析2023年5月的销售漏斗，统计浏览产品、添加购物车、创建订单和完成支付的用户数量及转化率。返回每个阶段的名称、用户数量和与上一阶段的转化率。

-- 正确答案：
WITH funnel_stages AS (
    SELECT '1. 浏览产品' AS stage, COUNT(DISTINCT user_id) AS user_count
    FROM user_activity_logs
    WHERE YEAR(created_at) = 2023 AND MONTH(created_at) = 5
    AND activity_type = '浏览产品'
    
    UNION ALL
    
    SELECT '2. 添加购物车' AS stage, COUNT(DISTINCT user_id) AS user_count
    FROM user_activity_logs
    WHERE YEAR(created_at) = 2023 AND MONTH(created_at) = 5
    AND activity_type = '添加购物车'
    
    UNION ALL
    
    SELECT '3. 创建订单' AS stage, COUNT(DISTINCT user_id) AS user_count
    FROM user_activity_logs
    WHERE YEAR(created_at) = 2023 AND MONTH(created_at) = 5
    AND activity_type = '下单'
    
    UNION ALL
    
    SELECT '4. 完成支付' AS stage, COUNT(DISTINCT user_id) AS user_count
    FROM user_activity_logs
    WHERE YEAR(created_at) = 2023 AND MONTH(created_at) = 5
    AND activity_type = '支付'
)
SELECT 
    stage,
    user_count,
    CASE 
        WHEN stage = '1. 浏览产品' THEN NULL
        ELSE ROUND(user_count / LAG(user_count) OVER (ORDER BY stage) * 100, 2)
    END AS conversion_rate
FROM funnel_stages
ORDER BY stage;

-- 解析：
-- 1. 创建CTE计算各个阶段的用户数量
--    - 使用UNION ALL组合四个查询结果
--    - 每个查询统计特定活动类型的用户数量
-- 2. 在主查询中使用LAG窗口函数获取上一阶段的用户数量
-- 3. 计算转化率： 当前阶段用户数 / 上一阶段用户数 * 100
-- 4. 使用CASE表达式处理第一个阶段没有上一阶段的情况
-- 5. 按阶段顺序排列结果


-- 题目22：RFM客户分析
-- 业务场景：营销团队需要基于最近购买时间(Recency)、购买频率(Frequency)和消费金额(Monetary)对客户进行分类。
-- 表结构：users, orders, order_items
-- 问题：编写SQL查询，计算每个用户的最后购买日期、购买次数和总消费金额，然后根据这三个维度将用户分为"高价值"、"中价值"和"低价值"三组。返回用户ID、用户名、三个维度的值和最终分类。

-- 正确答案：
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
    WHERE o.status = '已完成'
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
        WHEN (r_score + f_score + m_score) >= 8 THEN '高价值'
        WHEN (r_score + f_score + m_score) >= 5 THEN '中价值'
        ELSE '低价值'
    END AS customer_segment
FROM rfm_scores
ORDER BY (r_score + f_score + m_score) DESC, user_id;

-- 解析：
-- 1. 创建CTE user_rfm 计算每个用户的RFM指标
--    - recency: 当前日期与最后购买日期的差值（天数）
--    - frequency: 购买次数（唯一订单数）
--    - monetary: 总消费金额
-- 2. 创建CTE rfm_scores 为每个维度分配分数
--    - r_score: 基于最近购买时间的分数（越近越高）
--    - f_score: 基于购买频率的分数（越频繁越高）
--    - m_score: 基于消费金额的分数（越多越高）
-- 3. 在主查询中基于三个维度的总分对客户进行分类
-- 4. 按总分降序和用户ID排序返回结果


-- 题目23：同比/环比增长分析
-- 业务场景：财务部门需要分析产品类别的同比和环比销售增长。
-- 表结构：orders, order_items, products, product_categories
-- 问题：编写SQL查询，计算2023年每个季度各产品类别的销售额，以及与上一季度和去年同期相比的增长率。返回年份、季度、类别名称、销售额、环比增长率和同比增长率。

-- 正确答案：
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

-- 解析：
-- 1. 创建CTE计算2022年和2023年每个季度各产品类别的销售额
-- 2. 通过自连接获取：
--    - 上一季度销售额(prev_q)
--    - 去年同期销售额(prev_y)
-- 3. 计算环比增长率： (当前销售额 - 上季度销售额) / 上季度销售额 * 100
-- 4. 计算同比增长率： (当前销售额 - 去年同期销售额) / 去年同期销售额 * 100
-- 5. 使用CASE表达式处理上一期没有数据或销售额为0的情况
-- 6. 筛选2023年的数据并按季度和类别名称排序


-- 题目24：用户留存率分析
-- 业务场景：产品团队需要分析用户在首次使用后的留存情况。
-- 表结构：users, user_activity_logs
-- 问题：编写SQL查询，计算2023年1月新注册用户在接下来5个月内的每月留存率。返回用户注册月份、后续每个月份和相应的留存率百分比。

-- 正确答案：
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

-- 解析：
-- 1. 创建CTE new_users 获取2023年1月新注册的用户
-- 2. 创建CTE monthly_active_users 统计这些用户在1-6月的活跃情况
-- 3. 创建CTE retention_data 按月份统计活跃用户数
-- 4. 使用FIRST_VALUE窗口函数获取第一个月的活跃用户数作为基准
-- 5. 计算留存率： 当月活跃用户数 / 第一个月活跃用户数 * 100
-- 6. 按月份排序返回结果


-- 题目25：商品组合分析
-- 业务场景：营销团队想了解哪些产品经常一起购买，以便进行捆绑销售。
-- 表结构：orders, order_items, products
-- 问题：编写SQL查询，找出在同一订单中最常一起购买的产品对。返回第一个产品名称、第二个产品名称和共同出现的次数，按共同出现次数降序排列，限制前20条结果。

-- 正确答案：
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

-- 解析：
-- 1. 创建CTE生成产品对
--    - 自连接order_items表找出同一订单中的不同产品
--    - 使用条件o1.product_id < o2.product_id确保每对产品只被计算一次
--    - 连接products表获取产品名称
-- 2. 按产品对分组计算共同出现次数
-- 3. 按共同出现次数降序排序
-- 4. 限制返回前20条结果 