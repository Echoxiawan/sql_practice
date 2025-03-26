# 零售分析SQL练习项目 / Retail Analytics SQL Practice Project

## 项目简介 / Project Introduction

这个项目提供了一套完整的SQL练习环境，专注于零售数据分析领域。通过一系列结构化的SQL练习题，从基础查询到复杂的数据分析，帮助用户提升SQL技能和数据分析能力。

This project provides a comprehensive SQL practice environment focused on retail analytics. Through a series of structured SQL exercises, ranging from basic queries to complex data analysis, it helps users improve their SQL skills and data analysis capabilities.

## 数据库结构 / Database Structure

零售分析数据库包含以下主要表：

The retail analytics database includes the following main tables:

- `users` - 用户信息 / User information
- `product_categories` - 产品类别 / Product categories
- `products` - 产品信息 / Product information
- `suppliers` - 供应商信息 / Supplier information
- `orders` - 订单信息 / Order information
- `order_items` - 订单明细 / Order items
- `warehouses` - 仓库信息 / Warehouse information
- `inventory` - 库存信息 / Inventory information
- `employees` - 员工信息 / Employee information
- `sales` - 销售信息 / Sales information
- `reviews` - 产品评价 / Product reviews
- `user_activity_logs` - 用户活动日志 / User activity logs

## 文件说明 / Files Description

- `retail_analytics_db.sql` - 数据库结构定义 / Database schema definition
- `sql_practice_sample_data.sql` - 示例数据 / Sample data
- `sql_problems.sql` - SQL练习题 / SQL practice problems
- `sql_problems_with_answers_part1.sql` - 练习题1-10答案 / Answers for problems 1-10
- `sql_problems_with_answers_part2.sql` - 练习题11-20答案 / Answers for problems 11-20
- `sql_problems_with_answers_part3.sql` - 练习题21-25答案 / Answers for problems 21-25

## 练习题覆盖的主题 / Topics Covered

- 基础查询与过滤 / Basic queries and filtering
- 多表连接 / Multi-table joins
- 数据聚合与分组 / Data aggregation and grouping
- 窗口函数 / Window functions
- 子查询与公共表表达式(CTE) / Subqueries and Common Table Expressions (CTEs)
- 高级数据分析案例 / Advanced data analysis cases:
  - 销售趋势分析 / Sales trend analysis
  - RFM客户分析 / RFM customer analysis
  - 销售漏斗分析 / Sales funnel analysis
  - 用户留存率分析 / User retention analysis
  - 商品组合分析 / Product combination analysis

## 如何使用 / How to Use

1. 创建数据库 / Create the database:
```sql
CREATE DATABASE retail_analytics;
USE retail_analytics;
```

2. 运行数据库结构脚本 / Run the database schema script:
```
source retail_analytics_db.sql
```

3. 导入示例数据 / Import sample data:
```
source sql_practice_sample_data.sql
```

4. 开始练习 / Start practicing:
   - 打开`sql_problems.sql`文件，尝试解答问题 / Open `sql_problems.sql` file and try to solve the problems
   - 需要参考答案时，查看对应的答案文件 / Check the answer files when you need reference

## 练习题示例 / Sample Problems

### 基础查询 / Basic Query
```sql
-- 查找价格高于5000元的产品
-- Find products with a price higher than 5000
SELECT product_name, unit_price
FROM products
WHERE unit_price > 5000
ORDER BY unit_price DESC;
```

### 多表连接 / Multi-table Join
```sql
-- 查找每个类别的产品数量
-- Find the number of products in each category
SELECT pc.category_name, COUNT(p.product_id) AS product_count
FROM product_categories pc
LEFT JOIN products p ON pc.category_id = p.category_id
GROUP BY pc.category_id, pc.category_name
ORDER BY product_count DESC;
```

### 高级分析 / Advanced Analysis
```sql
-- RFM客户分析
-- RFM Customer Analysis
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
ORDER BY (r_score + f_score + m_score) DESC;
```

## 学习目标 / Learning Objectives

通过本项目，您将能够：
- 掌握从基础到高级的SQL查询技能
- 学习真实业务场景中的数据分析方法
- 理解零售分析中常见的数据模型和分析指标
- 提升解决复杂数据问题的能力

By completing this project, you will be able to:
- Master SQL query skills from basic to advanced levels
- Learn data analysis methods in real business scenarios
- Understand common data models and analysis metrics in retail analytics
- Enhance your ability to solve complex data problems

## 许可 / License

MIT

## 联系方式 / Contact Information

如果你有任何问题或建议，欢迎联系我：

If you have any questions or suggestions, feel free to contact me:

<img src="contact.jpg" alt="联系方式二维码" width="300"/>

扫一扫上面的二维码图案，加我为好友。

Scan the QR code above to add me as a friend. 