-- MySQL SQL练习题 - 问题与答案（第2部分：题目11-20）

-- 题目11：多表连接
-- 业务场景：全面的订单分析报告，包含用户、产品和支付信息。
-- 表结构：users, orders, order_items, products, financial_transactions
-- 问题：编写SQL查询，生成一个详细的订单报告，包含用户信息、订单日期、产品详情、支付金额和支付方式。限制结果为2023年5月的订单，按订单日期排序。

-- 正确答案：
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
LEFT JOIN financial_transactions ft ON o.order_id = ft.order_id AND ft.transaction_type = '收入'
WHERE YEAR(o.order_date) = 2023 AND MONTH(o.order_date) = 5
ORDER BY o.order_date, o.order_id, p.product_name;

-- 解析：
-- 1. 连接多个相关表获取完整的订单信息：
--    - orders 表与 users 表通过 user_id 关联
--    - orders 表与 order_items 表通过 order_id 关联
--    - order_items 表与 products 表通过 product_id 关联
--    - orders 表与 financial_transactions 表通过 order_id 关联，并限定交易类型为"收入"
-- 2. 计算每个订单项的总金额(item_total)
-- 3. 使用WHERE子句筛选2023年5月的订单
-- 4. 按订单日期、订单ID和产品名称排序


-- 3. 数据聚合
-- 题目12：基础聚合与分组
-- 业务场景：销售部门需要按季度和产品类别分析销售趋势。
-- 表结构：orders, order_items, products, product_categories
-- 问题：编写SQL查询，按季度和产品类别统计2023年的销售额，返回年份、季度、类别名称和销售总额，按季度和销售额降序排列。

-- 正确答案：
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

-- 解析：
-- 1. 使用QUARTER()函数获取订单日期的季度
-- 2. 连接相关表获取订单、产品和类别信息
-- 3. 使用WHERE筛选2023年的订单
-- 4. 按季度和产品类别分组计算销售总额
-- 5. 按季度和销售总额降序排序


-- 题目13：HAVING子句
-- 业务场景：识别高消费但评价较低的产品，可能需要质量改进。
-- 表结构：products, order_items, reviews
-- 问题：编写SQL查询，找出销售额超过10000但平均评分低于4的产品。返回产品名称、销售总额、评价数量和平均评分，按平均评分升序排列。

-- 正确答案：
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

-- 解析：
-- 1. 连接products、order_items表计算销售额
-- 2. 使用LEFT JOIN连接reviews表获取评价信息（确保包含没有评价的产品）
-- 3. 按产品分组计算总销售额、评价数和平均评分
-- 4. 使用HAVING筛选销售额超过10000且平均评分低于4的产品
-- 5. 按平均评分升序排列


-- 题目14：复杂分组与聚合
-- 业务场景：分析不同用户等级在不同季节的消费模式。
-- 表结构：users, orders, order_items
-- 问题：编写SQL查询，按用户等级和季节统计消费金额。返回用户等级、季节（春、夏、秋、冬）、订单数量和总消费金额，按用户等级和总消费金额降序排列。

-- 正确答案：
SELECT 
    u.user_level,
    CASE 
        WHEN MONTH(o.order_date) IN (3, 4, 5) THEN '春'
        WHEN MONTH(o.order_date) IN (6, 7, 8) THEN '夏'
        WHEN MONTH(o.order_date) IN (9, 10, 11) THEN '秋'
        ELSE '冬'
    END AS season,
    COUNT(DISTINCT o.order_id) AS order_count,
    SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) AS total_amount
FROM users u
JOIN orders o ON u.user_id = o.user_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY u.user_level, season
ORDER BY u.user_level, total_amount DESC;

-- 解析：
-- 1. 连接users、orders和order_items表获取完整的订单信息
-- 2. 使用CASE表达式根据订单月份确定季节
--    - 3-5月为春季
--    - 6-8月为夏季
--    - 9-11月为秋季
--    - 12、1、2月为冬季
-- 3. 按用户等级和季节分组计算订单数量和总消费金额
-- 4. 使用COUNT(DISTINCT order_id)确保正确计算订单数量
-- 5. 按用户等级和总消费金额降序排序


-- 题目15：聚合函数与CASE表达式
-- 业务场景：分析产品在不同价格段的销售表现。
-- 表结构：products, order_items
-- 问题：编写SQL查询，将产品按价格分为"低价"（<100）、"中价"（100-1000）和"高价"（>1000）三组，统计每组的产品数量、销售总额和平均销售单价，按价格组升序排列。

-- 正确答案：
SELECT 
    CASE 
        WHEN p.unit_price < 100 THEN '低价'
        WHEN p.unit_price BETWEEN 100 AND 1000 THEN '中价'
        ELSE '高价'
    END AS price_category,
    COUNT(DISTINCT p.product_id) AS product_count,
    SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) AS total_sales,
    AVG(oi.unit_price) AS avg_selling_price
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY price_category
ORDER BY 
    CASE 
        WHEN price_category = '低价' THEN 1
        WHEN price_category = '中价' THEN 2
        ELSE 3
    END;

-- 解析：
-- 1. 使用CASE表达式将产品按单价分为三个价格组
-- 2. 使用LEFT JOIN连接products和order_items表，确保包含没有销售记录的产品
-- 3. 按价格组分组，计算每组的产品数量、销售总额和平均销售单价
-- 4. 使用嵌套的CASE表达式确保价格组按"低价"、"中价"、"高价"的顺序排列


-- 题目16：窗口函数基础
-- 业务场景：销售团队需要分析产品销售的环比增长情况。
-- 表结构：orders, order_items, products
-- 问题：编写SQL查询，计算2023年每个月的总销售额以及与上个月相比的增长百分比。返回年月、销售额和环比增长率，按年月排序。

-- 正确答案：
WITH monthly_sales AS (
    SELECT 
        DATE_FORMAT(o.order_date, '%Y-%m') AS order_month,  -- 避免 year_month 作为关键字
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


-- 解析：
-- 1. 使用CTE计算2023年每个月的销售总额
-- 2. 在主查询中使用LAG窗口函数获取上个月的销售额
-- 3. 计算环比增长率： (当月销售额 - 上月销售额) / 上月销售额 * 100
-- 4. 使用CASE表达式处理第一个月没有上月销售额的情况
-- 5. 按年月排序


-- 题目17：窗口函数与排名
-- 业务场景：识别每个类别中最畅销的产品。
-- 表结构：products, order_items, product_categories
-- 问题：编写SQL查询，找出每个产品类别中销售额排名前3的产品。返回类别名称、产品名称、销售额和类别内排名，按类别名称和排名排序。

-- 正确答案：
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

-- 解析：
-- 1. 创建CTE计算每个产品的销售额
-- 2. 使用DENSE_RANK窗口函数按类别对产品进行排名
--    - PARTITION BY category_id 确保在每个类别内单独排名
--    - ORDER BY SUM(...) DESC 确保按销售额降序排名
-- 3. 在主查询中筛选出排名前3的产品
-- 4. 按类别名称和排名排序


-- 题目18：累积求和窗口函数
-- 业务场景：财务团队需要分析累积销售额达成情况。
-- 表结构：orders, order_items
-- 问题：编写SQL查询，计算2023年每天的销售额和累积销售额。返回日期、当日销售额和累积销售额，按日期排序。

-- 正确答案：
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

-- 解析：
-- 1. 创建CTE计算2023年每天的销售总额
-- 2. 使用SUM窗口函数计算累积销售额
--    - OVER (ORDER BY sale_date) 确保累积求和按日期顺序进行
-- 3. 按日期排序返回结果


-- 题目19：移动平均窗口函数
-- 业务场景：销售趋势分析，平滑短期波动。
-- 表结构：orders, order_items
-- 问题：编写SQL查询，计算2023年每天的销售额和7天移动平均销售额。返回日期、当日销售额和7天移动平均值，按日期排序。

-- 正确答案：
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

-- 解析：
-- 1. 创建CTE计算2023年每天的销售总额
-- 2. 使用AVG窗口函数计算7天移动平均值
--    - ROWS BETWEEN 6 PRECEDING AND CURRENT ROW 定义窗口范围为当前行和前6行（共7天）
-- 3. 按日期排序返回结果


-- 题目20：窗口函数与分区比较
-- 业务场景：比较每个产品的销售额与其所属类别平均销售额的差异。
-- 表结构：products, order_items, product_categories
-- 问题：编写SQL查询，计算每个产品的销售额、所属类别的平均销售额以及与类别平均值的偏差百分比。返回产品名称、产品销售额、类别平均销售额和偏差百分比，按偏差百分比降序排列。

-- 正确答案：
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

-- 解析：
-- 1. 创建CTE计算每个产品的销售总额
-- 2. 使用AVG窗口函数计算每个类别的平均销售额
--    - PARTITION BY category_id 确保在每个类别内计算平均值
-- 3. 计算偏差百分比： (产品销售额 - 类别平均销售额) / 类别平均销售额 * 100
-- 4. 按偏差百分比降序排列结果 