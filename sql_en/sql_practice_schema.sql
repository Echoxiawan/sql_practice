-- MySQL Practice Database
DROP DATABASE IF EXISTS retail_analytics;
CREATE DATABASE retail_analytics;
USE retail_analytics;

-- Users Table
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    register_date DATE NOT NULL,
    last_login DATETIME,
    is_active BOOLEAN DEFAULT TRUE,
    user_level ENUM('Regular', 'Silver', 'Gold', 'Diamond') DEFAULT 'Regular'
);

-- Product Categories Table
CREATE TABLE product_categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50) NOT NULL,
    parent_category_id INT,
    description TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (parent_category_id) REFERENCES product_categories(category_id) ON DELETE SET NULL
);

-- Products Table
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    category_id INT,
    unit_price DECIMAL(10, 2) NOT NULL,
    stock_quantity INT NOT NULL DEFAULT 0,
    supplier_id INT,
    is_discontinued BOOLEAN DEFAULT FALSE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES product_categories(category_id) ON DELETE SET NULL
);

-- Suppliers Table
CREATE TABLE suppliers (
    supplier_id INT PRIMARY KEY AUTO_INCREMENT,
    supplier_name VARCHAR(100) NOT NULL,
    contact_name VARCHAR(50),
    contact_email VARCHAR(100),
    contact_phone VARCHAR(20),
    address TEXT,
    city VARCHAR(50),
    country VARCHAR(50),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Add Foreign Key Constraint
ALTER TABLE products
ADD CONSTRAINT fk_supplier
FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id) ON DELETE SET NULL;

-- Orders Table
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    required_date DATE,
    shipped_date DATE,
    status ENUM('Pending Payment', 'Paid', 'Shipping', 'Completed', 'Cancelled') DEFAULT 'Pending Payment',
    shipping_fee DECIMAL(8, 2) DEFAULT 0.00,
    payment_method ENUM('Alipay', 'WeChat', 'Bank Card', 'Cash on Delivery') NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL
);

-- Order Items Table
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    discount DECIMAL(4, 2) DEFAULT 0.00,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

-- Warehouses Table
CREATE TABLE warehouses (
    warehouse_id INT PRIMARY KEY AUTO_INCREMENT,
    warehouse_name VARCHAR(100) NOT NULL,
    location VARCHAR(255),
    capacity INT,
    manager_name VARCHAR(100)
);

-- Inventory Table
CREATE TABLE inventory (
    inventory_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    warehouse_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 0,
    last_check_date DATE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
    FOREIGN KEY (warehouse_id) REFERENCES warehouses(warehouse_id) ON DELETE CASCADE,
    UNIQUE KEY (product_id, warehouse_id)
);

-- Employees Table
CREATE TABLE employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    title VARCHAR(100),
    birth_date DATE,
    hire_date DATE NOT NULL,
    report_to INT,
    department VARCHAR(50),
    salary DECIMAL(10, 2),
    FOREIGN KEY (report_to) REFERENCES employees(employee_id) ON DELETE SET NULL
);

-- Sales Table
CREATE TABLE sales (
    sale_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT,
    order_id INT NOT NULL,
    sale_date DATE NOT NULL,
    commission DECIMAL(8, 2),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE SET NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE
);

-- Promotions Table
CREATE TABLE promotions (
    promotion_id INT PRIMARY KEY AUTO_INCREMENT,
    promotion_name VARCHAR(100) NOT NULL,
    description TEXT,
    discount_type ENUM('Fixed Amount', 'Percentage') NOT NULL,
    discount_value DECIMAL(10, 2) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    min_purchase DECIMAL(10, 2) DEFAULT 0.00,
    is_active BOOLEAN DEFAULT TRUE
);

-- Product Promotions Relation Table
CREATE TABLE product_promotions (
    product_promotion_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    promotion_id INT NOT NULL,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
    FOREIGN KEY (promotion_id) REFERENCES promotions(promotion_id) ON DELETE CASCADE,
    UNIQUE KEY (product_id, promotion_id)
);

-- Reviews Table
CREATE TABLE reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    user_id INT NOT NULL,
    rating TINYINT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    review_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Returns Table
CREATE TABLE returns (
    return_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    return_date DATE NOT NULL,
    reason TEXT,
    status ENUM('Pending', 'Approved', 'Rejected', 'Completed') DEFAULT 'Pending',
    refund_amount DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE
);

-- Return Items Table
CREATE TABLE return_items (
    return_item_id INT PRIMARY KEY AUTO_INCREMENT,
    return_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (return_id) REFERENCES returns(return_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

-- Financial Transactions Table
CREATE TABLE financial_transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    return_id INT,
    transaction_type ENUM('Income', 'Refund', 'Expense', 'Other') NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    transaction_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    description VARCHAR(255),
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE SET NULL,
    FOREIGN KEY (return_id) REFERENCES returns(return_id) ON DELETE SET NULL
);

-- User Activity Logs Table
CREATE TABLE user_activity_logs (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    activity_type VARCHAR(50) NOT NULL,
    activity_details TEXT,
    ip_address VARCHAR(45),
    user_agent VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
); 