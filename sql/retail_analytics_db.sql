-- MySQL 零售分析数据库 - 包含表结构和示例数据
-- 先运行此文件创建数据库结构
-- 然后运行 sql_practice_sample_data.sql 和 sql_practice_sample_data2.sql 导入数据

-- 创建数据库
DROP DATABASE IF EXISTS retail_analytics;
CREATE DATABASE retail_analytics;
USE retail_analytics;

-- 用户表
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '用户ID',
    username VARCHAR(50) NOT NULL COMMENT '用户名',
    email VARCHAR(100) UNIQUE NOT NULL COMMENT '电子邮箱',
    phone VARCHAR(20) COMMENT '手机号码',
    register_date DATE NOT NULL COMMENT '注册日期',
    last_login DATETIME COMMENT '最后登录时间',
    is_active BOOLEAN DEFAULT TRUE COMMENT '是否活跃',
    user_level ENUM('普通', '银卡', '金卡', '钻石') DEFAULT '普通' COMMENT '用户等级'
) COMMENT '用户信息表';

-- 产品类别表
CREATE TABLE product_categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '类别ID',
    category_name VARCHAR(50) NOT NULL COMMENT '类别名称',
    parent_category_id INT COMMENT '父类别ID',
    description TEXT COMMENT '类别描述',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    FOREIGN KEY (parent_category_id) REFERENCES product_categories(category_id) ON DELETE SET NULL
) COMMENT '产品类别表';

-- 产品表
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '产品ID',
    product_name VARCHAR(100) NOT NULL COMMENT '产品名称',
    category_id INT COMMENT '类别ID',
    unit_price DECIMAL(10, 2) NOT NULL COMMENT '单价',
    stock_quantity INT NOT NULL DEFAULT 0 COMMENT '库存数量',
    supplier_id INT COMMENT '供应商ID',
    is_discontinued BOOLEAN DEFAULT FALSE COMMENT '是否停产',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    FOREIGN KEY (category_id) REFERENCES product_categories(category_id) ON DELETE SET NULL
) COMMENT '产品信息表';

-- 创建供应商表
CREATE TABLE suppliers (
    supplier_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '供应商ID',
    supplier_name VARCHAR(100) NOT NULL COMMENT '供应商名称',
    contact_name VARCHAR(50) COMMENT '联系人姓名',
    contact_email VARCHAR(100) COMMENT '联系人邮箱',
    contact_phone VARCHAR(20) COMMENT '联系人电话',
    address TEXT COMMENT '地址',
    city VARCHAR(50) COMMENT '城市',
    country VARCHAR(50) COMMENT '国家',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) COMMENT '供应商信息表';

-- 添加外键关联
ALTER TABLE products
ADD CONSTRAINT fk_supplier
FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id) ON DELETE SET NULL;

-- 订单表
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '订单ID',
    user_id INT COMMENT '用户ID',
    order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '下单时间',
    required_date DATE COMMENT '要求送达日期',
    shipped_date DATE COMMENT '实际发货日期',
    status ENUM('待支付', '已支付', '配送中', '已完成', '已取消') DEFAULT '待支付' COMMENT '订单状态',
    shipping_fee DECIMAL(8, 2) DEFAULT 0.00 COMMENT '运费',
    payment_method ENUM('支付宝', '微信', '银行卡', '货到付款') NOT NULL COMMENT '支付方式',
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL
) COMMENT '订单信息表';

-- 订单明细表
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '订单项ID',
    order_id INT NOT NULL COMMENT '订单ID',
    product_id INT NOT NULL COMMENT '产品ID',
    quantity INT NOT NULL COMMENT '购买数量',
    unit_price DECIMAL(10, 2) NOT NULL COMMENT '单价',
    discount DECIMAL(4, 2) DEFAULT 0.00 COMMENT '折扣率',
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
) COMMENT '订单明细表';

-- 仓库表
CREATE TABLE warehouses (
    warehouse_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '仓库ID',
    warehouse_name VARCHAR(100) NOT NULL COMMENT '仓库名称',
    location VARCHAR(255) COMMENT '仓库位置',
    capacity INT COMMENT '仓库容量',
    manager_name VARCHAR(100) COMMENT '仓库管理员姓名'
) COMMENT '仓库信息表';

-- 库存表
CREATE TABLE inventory (
    inventory_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '库存记录ID',
    product_id INT NOT NULL COMMENT '产品ID',
    warehouse_id INT NOT NULL COMMENT '仓库ID',
    quantity INT NOT NULL DEFAULT 0 COMMENT '库存数量',
    last_check_date DATE COMMENT '最后盘点日期',
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
    FOREIGN KEY (warehouse_id) REFERENCES warehouses(warehouse_id) ON DELETE CASCADE,
    UNIQUE KEY (product_id, warehouse_id)
) COMMENT '库存信息表';

-- 员工表
CREATE TABLE employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '员工ID',
    first_name VARCHAR(50) NOT NULL COMMENT '名字',
    last_name VARCHAR(50) NOT NULL COMMENT '姓氏',
    title VARCHAR(100) COMMENT '职位',
    birth_date DATE COMMENT '出生日期',
    hire_date DATE NOT NULL COMMENT '入职日期',
    report_to INT COMMENT '上级ID',
    department VARCHAR(50) COMMENT '部门',
    salary DECIMAL(10, 2) COMMENT '薪资',
    FOREIGN KEY (report_to) REFERENCES employees(employee_id) ON DELETE SET NULL
) COMMENT '员工信息表';

-- 销售表
CREATE TABLE sales (
    sale_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '销售记录ID',
    employee_id INT COMMENT '员工ID',
    order_id INT NOT NULL COMMENT '订单ID',
    sale_date DATE NOT NULL COMMENT '销售日期',
    commission DECIMAL(8, 2) COMMENT '佣金',
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE SET NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE
) COMMENT '销售记录表';

-- 创建促销活动表
CREATE TABLE promotions (
    promotion_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '促销活动ID',
    promotion_name VARCHAR(100) NOT NULL COMMENT '活动名称',
    description TEXT COMMENT '活动描述',
    discount_type ENUM('固定金额', '百分比') NOT NULL COMMENT '折扣类型',
    discount_value DECIMAL(10, 2) NOT NULL COMMENT '折扣值',
    start_date DATE NOT NULL COMMENT '开始日期',
    end_date DATE NOT NULL COMMENT '结束日期',
    min_purchase DECIMAL(10, 2) DEFAULT 0.00 COMMENT '最低购买金额',
    is_active BOOLEAN DEFAULT TRUE COMMENT '是否激活'
) COMMENT '促销活动表';

-- 创建产品促销关联表
CREATE TABLE product_promotions (
    product_promotion_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '产品促销关联ID',
    product_id INT NOT NULL COMMENT '产品ID',
    promotion_id INT NOT NULL COMMENT '促销活动ID',
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
    FOREIGN KEY (promotion_id) REFERENCES promotions(promotion_id) ON DELETE CASCADE,
    UNIQUE KEY (product_id, promotion_id)
) COMMENT '产品促销关联表';

-- 创建客户评价表
CREATE TABLE reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '评价ID',
    product_id INT NOT NULL COMMENT '产品ID',
    user_id INT NOT NULL COMMENT '用户ID',
    rating TINYINT NOT NULL CHECK (rating BETWEEN 1 AND 5) COMMENT '评分(1-5)',
    comment TEXT COMMENT '评价内容',
    review_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '评价时间',
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) COMMENT '客户评价表';

-- 创建退货表
CREATE TABLE returns (
    return_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '退货ID',
    order_id INT NOT NULL COMMENT '订单ID',
    return_date DATE NOT NULL COMMENT '退货日期',
    reason TEXT COMMENT '退货原因',
    status ENUM('待处理', '已批准', '已拒绝', '已完成') DEFAULT '待处理' COMMENT '退货状态',
    refund_amount DECIMAL(10, 2) COMMENT '退款金额',
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE
) COMMENT '退货信息表';

-- 创建退货明细表
CREATE TABLE return_items (
    return_item_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '退货项ID',
    return_id INT NOT NULL COMMENT '退货ID',
    product_id INT NOT NULL COMMENT '产品ID',
    quantity INT NOT NULL COMMENT '退货数量',
    FOREIGN KEY (return_id) REFERENCES returns(return_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
) COMMENT '退货明细表';

-- 创建财务交易表
CREATE TABLE financial_transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '交易ID',
    order_id INT COMMENT '订单ID',
    return_id INT COMMENT '退货ID',
    transaction_type ENUM('收入', '退款', '费用', '其他') NOT NULL COMMENT '交易类型',
    amount DECIMAL(10, 2) NOT NULL COMMENT '交易金额',
    transaction_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '交易时间',
    description VARCHAR(255) COMMENT '交易描述',
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE SET NULL,
    FOREIGN KEY (return_id) REFERENCES returns(return_id) ON DELETE SET NULL
) COMMENT '财务交易表';

-- 用户活动日志表
CREATE TABLE user_activity_logs (
    log_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '日志ID',
    user_id INT NOT NULL COMMENT '用户ID',
    activity_type VARCHAR(50) NOT NULL COMMENT '活动类型',
    activity_details TEXT COMMENT '活动详情',
    ip_address VARCHAR(45) COMMENT 'IP地址',
    user_agent VARCHAR(255) COMMENT '用户代理',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) COMMENT '用户活动日志表'; 