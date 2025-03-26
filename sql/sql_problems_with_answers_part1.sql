-- MySQL SQL练习题 - 问题与答案（第1部分：题目1-10）

-- 1. 复杂查询 - 子查询
-- 题目1：子查询基础
-- 业务场景：电商平台需要找出所有购买过价格高于平均产品价格的产品的用户。
-- 表结构：users, orders, order_items, products
-- 问题：编写SQL查询，返回购买过价格高于平均产品价格的产品的用户名和邮箱，结果不能重复。

-- 正确答案：
SELECT DISTINCT u.username, u.email
FROM users u
JOIN orders o ON u.user_id = o.user_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE p.unit_price > (SELECT AVG(unit_price) FROM products)
ORDER BY u.username;

-- 解析：
-- 1. 首先，我们使用子查询计算所有产品的平均价格 (SELECT AVG(unit_price) FROM products)
-- 2. 然后，通过多表连接找出购买了价格高于平均价格产品的用户：
--    - users 表与 orders 表通过 user_id 关联
--    - orders 表与 order_items 表通过 order_id 关联
--    - order_items 表与 products 表通过 product_id 关联
-- 3. 使用 DISTINCT 关键字去除重复的用户
-- 4. 最后按用户名排序返回结果


-- 题目2：相关子查询
-- 业务场景：营销团队需要识别那些购买频率高于平均水平的高价值用户。
-- 表结构：users, orders
-- 问题：编写SQL查询，找出下单次数超过所有用户平均下单次数的用户，返回用户名、邮箱和下单次数，按下单次数降序排列。

-- 正确答案：
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

-- 解析：
-- 1. 使用通用表表达式(CTE) user_order_counts 计算每个用户的订单数
-- 2. 在CTE中，通过LEFT JOIN确保包含没有订单的用户，其订单数为0
-- 3. 在主查询中，使用子查询计算所有用户的平均订单数
-- 4. 筛选出订单数高于平均值的用户
-- 5. 最后按订单数降序排列


-- 题目3：EXISTS子查询
-- 业务场景：销售团队需要找出至少购买过一次但从未进行过退货的用户。
-- 表结构：users, orders, returns
-- 问题：编写SQL查询，返回至少有一个订单但没有任何退货记录的用户的用户名、邮箱和注册日期。

-- 正确答案：
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

-- 解析：
-- 1. 使用 EXISTS 子查询检查用户是否有订单
-- 2. 使用 NOT EXISTS 子查询检查用户是否没有退货记录
--    - 这里通过连接 orders 和 returns 表，查找用户相关的退货记录
-- 3. 两个条件结合，找出有订单但无退货的用户
-- 4. 最后按注册日期排序


-- 题目4：多层嵌套子查询
-- 业务场景：产品团队想分析高价值订单中最受欢迎的产品类别。
-- 表结构：orders, order_items, products, product_categories
-- 问题：编写SQL查询，找出在总金额超过1000元的订单中，出现频率最高的三个产品类别。返回类别名称和出现次数，按出现次数降序排列。

-- 正确答案：
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

-- 解析：
-- 1. 创建CTE high_value_orders 找出总金额超过1000元的订单
--    - 计算订单总金额时考虑了数量、单价和折扣
-- 2. 连接 high_value_orders、order_items、products 和 product_categories 表
-- 3. 按产品类别分组计算每个类别在高价值订单中出现的次数
-- 4. 按出现次数降序排序并限制返回前三个结果


-- 题目5：子查询与聚合函数结合
-- 业务场景：财务部门需要分析每月的销售情况与年度平均销售额的比较。
-- 表结构：orders, order_items
-- 问题：编写SQL查询，计算2023年每个月的总销售额，并与该年度的月平均销售额进行比较。返回月份、月销售额、年度月平均销售额和差异百分比，按月份排序。

-- 正确答案：
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

-- 解析：
-- 1. 创建CTE monthly_sales 计算2023年每个月的销售总额
-- 2. 创建CTE yearly_average 计算2023年月平均销售额
-- 3. 在主查询中连接这两个CTE
-- 4. 计算每月销售额与月平均值的差异百分比
-- 5. 按月份排序返回结果


-- 2. 多表关联
-- 题目6：内连接（INNER JOIN）
-- 业务场景：销售团队需要分析各产品类别的销售表现。
-- 表结构：product_categories, products, order_items, orders
-- 问题：编写SQL查询，统计每个产品类别的总销售额，返回类别名称和销售总额，按销售总额降序排列，只显示销售额大于10000的类别。

-- 正确答案：
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

-- 解析：
-- 1. 使用INNER JOIN连接所有相关表：
--    - product_categories 表与 products 表通过 category_id 关联
--    - products 表与 order_items 表通过 product_id 关联
--    - order_items 表与 orders 表通过 order_id 关联
-- 2. 计算每个产品类别的销售总额，考虑数量、单价和折扣
-- 3. 使用HAVING子句筛选销售额大于10000的类别
-- 4. 按销售总额降序排列结果


-- 题目7：左连接（LEFT JOIN）
-- 业务场景：库存管理团队需要分析产品库存与销售的关系。
-- 表结构：products, order_items, inventory
-- 问题：编写SQL查询，找出所有产品的销售量和当前库存比例。返回产品名称、总销售量、当前总库存量和销售/库存比例，包括没有任何销售记录的产品。

-- 正确答案：
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

-- 解析：
-- 1. 创建CTE product_sales 计算每个产品的总销售量
--    - 使用LEFT JOIN确保包含没有销售记录的产品
--    - 使用COALESCE函数将NULL值转换为0
-- 2. 创建CTE product_inventory 计算每个产品的总库存量
-- 3. 连接两个CTE并计算销售/库存比例
-- 4. 使用CASE语句处理库存为0的情况
-- 5. 按销售/库存比例降序排列，将NULL值放在最后


-- 题目8：右连接（RIGHT JOIN）
-- 业务场景：员工绩效评估，分析销售人员的业绩。
-- 表结构：employees, sales
-- 问题：编写SQL查询，分析销售部门所有员工（包括没有任何销售记录的员工）的销售业绩。返回员工姓名、职位、总销售额和平均佣金，按总销售额降序排列。

-- 正确答案：
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
WHERE e.department = '销售部'
GROUP BY e.employee_id, employee_name, e.title
ORDER BY total_sales DESC;

-- 解析：
-- 1. 使用LEFT JOIN连接employees和sales表
--    - 题目要求使用RIGHT JOIN，但实际上LEFT JOIN更直观，效果相同
-- 2. 筛选销售部门的员工
-- 3. 使用CONCAT函数组合姓和名
-- 4. 计算每个员工的总销售额和平均佣金
-- 5. 使用CASE语句处理没有销售记录的员工的平均佣金
-- 6. 按总销售额降序排列结果


-- 题目9：全连接（使用LEFT JOIN + UNION + RIGHT JOIN模拟）
-- 业务场景：市场团队需要全面了解用户活动和订单之间的关系。
-- 表结构：users, orders, user_activity_logs
-- 问题：编写SQL查询，获取所有用户的活动和订单统计，包括没有活动记录的用户和没有订单的用户。返回用户名、活动次数、订单次数和最后活动日期。

-- 正确答案：
-- MySQL不直接支持FULL JOIN，需要使用UNION模拟
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

-- 解析：
-- 1. MySQL不直接支持FULL JOIN，所以使用LEFT JOIN和RIGHT JOIN的UNION来模拟
-- 2. 第一个查询获取所有用户及其活动和订单统计
-- 3. 第二个查询获取在活动日志中没有记录但在用户表中存在的用户
-- 4. 两个结果集合并，确保捕获所有用户
-- 5. 使用COALESCE函数将NULL值转换为0
-- 6. 最后按用户名排序


-- 题目10：自连接（SELF JOIN）
-- 业务场景：人力资源部门需要生成公司的组织结构报表。
-- 表结构：employees
-- 问题：编写SQL查询，生成一个显示每个员工及其直接上级的报表。返回员工姓名、员工职位、上级姓名和上级职位。对于没有上级的员工，上级信息显示为"顶级管理者"。

-- 正确答案：
SELECT 
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    e.title AS employee_title,
    COALESCE(CONCAT(m.first_name, ' ', m.last_name), '顶级管理者') AS manager_name,
    COALESCE(m.title, '顶级管理者') AS manager_title
FROM employees e
LEFT JOIN employees m ON e.report_to = m.employee_id
ORDER BY 
    CASE WHEN e.report_to IS NULL THEN 0 ELSE 1 END,
    employee_name;

-- 解析：
-- 1. 使用SELF JOIN（自连接）连接employees表两次
--    - 第一次代表员工(e)
--    - 第二次代表上级(m)
-- 2. 使用LEFT JOIN确保包含没有上级的员工
-- 3. 使用CONCAT函数合并姓名
-- 4. 使用COALESCE函数为没有上级的员工设置"顶级管理者"
-- 5. 使用ORDER BY的CASE表达式确保顶级管理者排在前面 