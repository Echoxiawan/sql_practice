-- MySQL Retail Analytics Database - Contains table structure and sample data
-- First run this file to create the database structure
-- Then run sql_practice_sample_data.sql and sql_practice_sample_data2.sql to import data

-- Create database
DROP DATABASE IF EXISTS retail_analytics;
CREATE DATABASE retail_analytics;
USE retail_analytics;

-- Users table
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT COMMENT 'User ID',
    username VARCHAR(50) NOT NULL COMMENT 'Username',
    email VARCHAR(100) UNIQUE NOT NULL COMMENT 'Email address',
    phone VARCHAR(20) COMMENT 'Phone number',
    register_date DATE NOT NULL COMMENT 'Registration date',
    last_login DATETIME COMMENT 'Last login time',
    is_active BOOLEAN DEFAULT TRUE COMMENT 'Whether active',
    user_level ENUM('Regular', 'Silver', 'Gold', 'Diamond') DEFAULT 'Regular' COMMENT 'User level'
) COMMENT 'User information table';

-- Product Categories table
CREATE TABLE product_categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Category ID',
    category_name VARCHAR(50) NOT NULL COMMENT 'Category name',
    parent_category_id INT COMMENT 'Parent category ID',
    description TEXT COMMENT 'Category description',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time',
    FOREIGN KEY (parent_category_id) REFERENCES product_categories(category_id) ON DELETE SET NULL
) COMMENT 'Product categories table';

-- Products table
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Product ID',
    product_name VARCHAR(100) NOT NULL COMMENT 'Product name',
    category_id INT COMMENT 'Category ID',
    unit_price DECIMAL(10, 2) NOT NULL COMMENT 'Unit price',
    stock_quantity INT NOT NULL DEFAULT 0 COMMENT 'Stock quantity',
    supplier_id INT COMMENT 'Supplier ID',
    is_discontinued BOOLEAN DEFAULT FALSE COMMENT 'Whether discontinued',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
    FOREIGN KEY (category_id) REFERENCES product_categories(category_id) ON DELETE SET NULL
) COMMENT 'Product information table';

-- Create suppliers table
CREATE TABLE suppliers (
    supplier_id INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Supplier ID',
    supplier_name VARCHAR(100) NOT NULL COMMENT 'Supplier name',
    contact_name VARCHAR(50) COMMENT 'Contact name',
    contact_email VARCHAR(100) COMMENT 'Contact email',
    contact_phone VARCHAR(20) COMMENT 'Contact phone',
    address TEXT COMMENT 'Address',
    city VARCHAR(50) COMMENT 'City',
    country VARCHAR(50) COMMENT 'Country',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time'
) COMMENT 'Supplier information table';

-- Add foreign key relationship
ALTER TABLE products
ADD CONSTRAINT fk_supplier
FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id) ON DELETE SET NULL;

-- Orders table
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Order ID',
    user_id INT COMMENT 'User ID',
    order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Order date',
    required_date DATE COMMENT 'Required delivery date',
    shipped_date DATE COMMENT 'Actual shipping date',
    status ENUM('Pending Payment', 'Paid', 'Shipping', 'Completed', 'Cancelled') DEFAULT 'Pending Payment' COMMENT 'Order status',
    shipping_fee DECIMAL(8, 2) DEFAULT 0.00 COMMENT 'Shipping fee',
    payment_method ENUM('Alipay', 'WeChat Pay', 'Bank Card', 'Cash on Delivery') NOT NULL COMMENT 'Payment method',
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL
) COMMENT 'Order information table';

-- Order items table
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Order item ID',
    order_id INT NOT NULL COMMENT 'Order ID',
    product_id INT NOT NULL COMMENT 'Product ID',
    quantity INT NOT NULL COMMENT 'Purchase quantity',
    unit_price DECIMAL(10, 2) NOT NULL COMMENT 'Unit price',
    discount DECIMAL(4, 2) DEFAULT 0.00 COMMENT 'Discount rate',
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
) COMMENT 'Order details table';

-- Warehouses table
CREATE TABLE warehouses (
    warehouse_id INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Warehouse ID',
    warehouse_name VARCHAR(100) NOT NULL COMMENT 'Warehouse name',
    location VARCHAR(255) COMMENT 'Warehouse location',
    capacity INT COMMENT 'Warehouse capacity',
    manager_name VARCHAR(100) COMMENT 'Warehouse manager name'
) COMMENT 'Warehouse information table';

-- Inventory table
CREATE TABLE inventory (
    inventory_id INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Inventory record ID',
    product_id INT NOT NULL COMMENT 'Product ID',
    warehouse_id INT NOT NULL COMMENT 'Warehouse ID',
    quantity INT NOT NULL DEFAULT 0 COMMENT 'Inventory quantity',
    last_check_date DATE COMMENT 'Last inventory check date',
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
    FOREIGN KEY (warehouse_id) REFERENCES warehouses(warehouse_id) ON DELETE CASCADE,
    UNIQUE KEY (product_id, warehouse_id)
) COMMENT 'Inventory information table';

-- Employees table
CREATE TABLE employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Employee ID',
    first_name VARCHAR(50) NOT NULL COMMENT 'First name',
    last_name VARCHAR(50) NOT NULL COMMENT 'Last name',
    title VARCHAR(100) COMMENT 'Job title',
    birth_date DATE COMMENT 'Birth date',
    hire_date DATE NOT NULL COMMENT 'Hire date',
    report_to INT COMMENT 'Manager ID',
    department VARCHAR(50) COMMENT 'Department',
    salary DECIMAL(10, 2) COMMENT 'Salary',
    FOREIGN KEY (report_to) REFERENCES employees(employee_id) ON DELETE SET NULL
) COMMENT 'Employee information table';

-- Sales table
CREATE TABLE sales (
    sale_id INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Sales record ID',
    employee_id INT COMMENT 'Employee ID',
    order_id INT NOT NULL COMMENT 'Order ID',
    sale_date DATE NOT NULL COMMENT 'Sale date',
    commission DECIMAL(8, 2) COMMENT 'Commission',
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE SET NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE
) COMMENT 'Sales record table';

-- Create promotions table
CREATE TABLE promotions (
    promotion_id INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Promotion ID',
    promotion_name VARCHAR(100) NOT NULL COMMENT 'Promotion name',
    description TEXT COMMENT 'Promotion description',
    discount_type ENUM('Fixed Amount', 'Percentage') NOT NULL COMMENT 'Discount type',
    discount_value DECIMAL(10, 2) NOT NULL COMMENT 'Discount value',
    start_date DATE NOT NULL COMMENT 'Start date',
    end_date DATE NOT NULL COMMENT 'End date',
    min_purchase DECIMAL(10, 2) DEFAULT 0.00 COMMENT 'Minimum purchase amount',
    is_active BOOLEAN DEFAULT TRUE COMMENT 'Whether active'
) COMMENT 'Promotions table';

-- Create product promotions relation table
CREATE TABLE product_promotions (
    product_promotion_id INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Product promotion relation ID',
    product_id INT NOT NULL COMMENT 'Product ID',
    promotion_id INT NOT NULL COMMENT 'Promotion ID',
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
    FOREIGN KEY (promotion_id) REFERENCES promotions(promotion_id) ON DELETE CASCADE,
    UNIQUE KEY (product_id, promotion_id)
) COMMENT 'Product promotions relation table';

-- Create customer reviews table
CREATE TABLE reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Review ID',
    product_id INT NOT NULL COMMENT 'Product ID',
    user_id INT NOT NULL COMMENT 'User ID',
    rating TINYINT NOT NULL CHECK (rating BETWEEN 1 AND 5) COMMENT 'Rating (1-5)',
    comment TEXT COMMENT 'Review content',
    review_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Review time',
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) COMMENT 'Customer reviews table';

-- Create returns table
CREATE TABLE returns (
    return_id INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Return ID',
    order_id INT NOT NULL COMMENT 'Order ID',
    return_date DATE NOT NULL COMMENT 'Return date',
    reason TEXT COMMENT 'Return reason',
    status ENUM('Pending', 'Approved', 'Rejected', 'Completed') DEFAULT 'Pending' COMMENT 'Return status',
    refund_amount DECIMAL(10, 2) COMMENT 'Refund amount',
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE
) COMMENT 'Returns information table';

-- Create return items table
CREATE TABLE return_items (
    return_item_id INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Return item ID',
    return_id INT NOT NULL COMMENT 'Return ID',
    product_id INT NOT NULL COMMENT 'Product ID',
    quantity INT NOT NULL COMMENT 'Return quantity',
    FOREIGN KEY (return_id) REFERENCES returns(return_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
) COMMENT 'Return details table';

-- Create financial transactions table
CREATE TABLE financial_transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Transaction ID',
    order_id INT COMMENT 'Order ID',
    return_id INT COMMENT 'Return ID',
    transaction_type ENUM('Income', 'Refund', 'Expense', 'Other') NOT NULL COMMENT 'Transaction type',
    amount DECIMAL(10, 2) NOT NULL COMMENT 'Transaction amount',
    transaction_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Transaction time',
    description VARCHAR(255) COMMENT 'Transaction description',
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE SET NULL,
    FOREIGN KEY (return_id) REFERENCES returns(return_id) ON DELETE SET NULL
) COMMENT 'Financial transactions table';

-- User activity logs table
CREATE TABLE user_activity_logs (
    log_id INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Log ID',
    user_id INT NOT NULL COMMENT 'User ID',
    activity_type VARCHAR(50) NOT NULL COMMENT 'Activity type',
    activity_details TEXT COMMENT 'Activity details',
    ip_address VARCHAR(45) COMMENT 'IP address',
    user_agent VARCHAR(255) COMMENT 'User agent',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time',
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) COMMENT 'User activity logs table'; 