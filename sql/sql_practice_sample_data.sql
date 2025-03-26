USE retail_analytics;

-- 插入用户数据
INSERT INTO users (username, email, phone, register_date, last_login, is_active, user_level) VALUES
('张三', 'zhangsan@example.com', '13800138001', '2020-01-15', '2023-05-20 14:30:00', TRUE, '钻石'),
('李四', 'lisi@example.com', '13800138002', '2020-02-20', '2023-05-19 10:15:00', TRUE, '金卡'),
('王五', 'wangwu@example.com', '13800138003', '2020-03-10', '2023-05-18 16:45:00', TRUE, '银卡'),
('赵六', 'zhaoliu@example.com', '13800138004', '2020-04-05', '2023-05-17 09:20:00', TRUE, '普通'),
('钱七', 'qianqi@example.com', '13800138005', '2020-05-12', '2023-05-16 11:30:00', TRUE, '普通'),
('孙八', 'sunba@example.com', '13800138006', '2020-06-18', '2023-05-15 13:40:00', TRUE, '银卡'),
('周九', 'zhoujiu@example.com', '13800138007', '2020-07-22', '2023-05-14 15:50:00', FALSE, '普通'),
('吴十', 'wushi@example.com', '13800138008', '2020-08-30', '2023-05-13 17:10:00', TRUE, '金卡'),
('郑十一', 'zheng11@example.com', '13800138009', '2020-09-14', '2023-05-12 08:25:00', TRUE, '钻石'),
('王十二', 'wang12@example.com', '13800138010', '2020-10-25', '2023-05-11 12:35:00', TRUE, '普通'),
('李十三', 'li13@example.com', '13800138011', '2020-11-05', '2023-05-10 14:45:00', TRUE, '普通'),
('张十四', 'zhang14@example.com', '13800138012', '2020-12-15', '2023-05-09 16:55:00', TRUE, '银卡'),
('刘十五', 'liu15@example.com', '13800138013', '2021-01-20', '2023-05-08 18:05:00', FALSE, '普通'),
('陈十六', 'chen16@example.com', '13800138014', '2021-02-10', '2023-05-07 09:15:00', TRUE, '金卡'),
('杨十七', 'yang17@example.com', '13800138015', '2021-03-05', '2023-05-06 10:25:00', TRUE, '钻石');

-- 插入产品类别数据
INSERT INTO product_categories (category_name, parent_category_id, description) VALUES
('电子产品', NULL, '各类电子设备和配件'),
('服装', NULL, '各类服装和配饰'),
('家居', NULL, '家居用品和装饰'),
('食品饮料', NULL, '各类食品和饮料'),
('图书', NULL, '各类书籍和出版物'),
('智能手机', 1, '各品牌智能手机'),
('电脑', 1, '台式电脑和笔记本电脑'),
('配件', 1, '电子产品配件'),
('男装', 2, '男士服装'),
('女装', 2, '女士服装'),
('儿童服装', 2, '儿童服装'),
('厨房用品', 3, '厨房相关用品'),
('卧室用品', 3, '卧室相关用品'),
('零食', 4, '各类零食小吃'),
('饮料', 4, '各类饮料'),
('文学', 5, '文学类书籍'),
('科技', 5, '科技类书籍');

-- 插入供应商数据
INSERT INTO suppliers (supplier_name, contact_name, contact_email, contact_phone, address, city, country) VALUES
('科技电子有限公司', '陈经理', 'chenjl@keji.com', '13900139001', '科技园路88号', '深圳', '中国'),
('时尚服饰集团', '王总监', 'wangzj@fashion.com', '13900139002', '时尚大道66号', '广州', '中国'),
('家和家居用品公司', '李经理', 'lijl@jiahu.com', '13900139003', '家居路33号', '佛山', '中国'),
('美味食品饮料有限公司', '张董事', 'zhangds@food.com', '13900139004', '食品街99号', '上海', '中国'),
('知识出版社', '刘编辑', 'liubj@zhishi.com', '13900139005', '知识路55号', '北京', '中国'),
('电子科技有限公司', '赵经理', 'zhaojl@tech.com', '13900139006', '电子路77号', '杭州', '中国'),
('时尚潮流公司', '钱设计师', 'qiansjs@trend.com', '13900139007', '潮流街22号', '上海', '中国'),
('家居之家有限公司', '孙经理', 'sunjl@homehome.com', '13900139008', '家居大道44号', '东莞', '中国'),
('食品天堂集团', '周总监', 'zhouzj@foodparadise.com', '13900139009', '食品城11号', '成都', '中国'),
('书海出版社', '吴编辑', 'wubj@bookcean.com', '13900139010', '书海路66号', '南京', '中国');

-- 插入产品数据
INSERT INTO products (product_name, category_id, unit_price, stock_quantity, supplier_id, is_discontinued) VALUES
('iPhone 13', 6, 5999.00, 200, 1, FALSE),
('华为 P40', 6, 4999.00, 150, 1, FALSE),
('小米 11', 6, 3999.00, 180, 1, FALSE),
('OPPO Find X3', 6, 4499.00, 120, 1, FALSE),
('vivo X60', 6, 3799.00, 160, 1, FALSE),
('MacBook Pro', 7, 12999.00, 80, 1, FALSE),
('联想 ThinkPad', 7, 8999.00, 100, 1, FALSE),
('华硕 ROG', 7, 9999.00, 60, 1, FALSE),
('戴尔 XPS', 7, 10999.00, 70, 6, FALSE),
('惠普 Spectre', 7, 9599.00, 90, 6, FALSE),
('AirPods Pro', 8, 1999.00, 300, 1, FALSE),
('蓝牙鼠标', 8, 199.00, 500, 6, FALSE),
('机械键盘', 8, 599.00, 400, 6, FALSE),
('显示器', 8, 1599.00, 200, 6, FALSE),
('移动硬盘', 8, 499.00, 350, 6, FALSE),
('男士T恤', 9, 199.00, 1000, 2, FALSE),
('男士牛仔裤', 9, 299.00, 800, 2, FALSE),
('男士衬衫', 9, 249.00, 900, 2, FALSE),
('男士夹克', 9, 399.00, 600, 2, FALSE),
('男士西装', 9, 999.00, 400, 2, FALSE),
('女士连衣裙', 10, 299.00, 1200, 2, FALSE),
('女士T恤', 10, 189.00, 1500, 2, FALSE),
('女士牛仔裤', 10, 289.00, 1000, 2, FALSE),
('女士风衣', 10, 599.00, 800, 7, FALSE),
('女士毛衣', 10, 329.00, 900, 7, FALSE),
('儿童T恤', 11, 129.00, 1500, 2, FALSE),
('儿童牛仔裤', 11, 189.00, 1200, 2, FALSE),
('儿童卫衣', 11, 219.00, 1000, 2, FALSE),
('儿童外套', 11, 299.00, 800, 2, FALSE),
('儿童睡衣', 11, 159.00, 1300, 7, FALSE),
('锅具套装', 12, 1299.00, 300, 3, FALSE),
('刀具套装', 12, 699.00, 400, 3, FALSE),
('餐具套装', 12, 599.00, 500, 3, FALSE),
('电饭煲', 12, 399.00, 600, 3, FALSE),
('微波炉', 12, 899.00, 350, 3, FALSE),
('被子', 13, 699.00, 400, 3, FALSE),
('枕头', 13, 199.00, 800, 3, FALSE),
('床单', 13, 299.00, 700, 3, FALSE),
('窗帘', 13, 399.00, 500, 8, FALSE),
('地毯', 13, 599.00, 300, 8, FALSE),
('薯片', 14, 9.90, 2000, 4, FALSE),
('巧克力', 14, 19.90, 1800, 4, FALSE),
('饼干', 14, 14.90, 2200, 4, FALSE),
('糖果', 14, 12.90, 2500, 4, FALSE),
('坚果', 14, 29.90, 1600, 4, FALSE),
('矿泉水', 15, 2.90, 5000, 4, FALSE),
('可乐', 15, 4.90, 4000, 4, FALSE),
('果汁', 15, 6.90, 3500, 9, FALSE),
('茶饮', 15, 5.90, 3800, 9, FALSE),
('咖啡', 15, 8.90, 3000, 9, FALSE),
('小说', 16, 39.90, 1000, 5, FALSE),
('诗集', 16, 29.90, 800, 5, FALSE),
('散文集', 16, 35.90, 900, 5, FALSE),
('传记', 16, 45.90, 700, 5, FALSE),
('科普读物', 17, 49.90, 1200, 5, FALSE),
('编程书籍', 17, 79.90, 1000, 5, FALSE),
('人工智能', 17, 89.90, 800, 10, FALSE),
('计算机基础', 17, 69.90, 1100, 10, FALSE),
('数据科学', 17, 99.90, 900, 10, FALSE),
('小米12', 4, 3999.00, 150, 1, FALSE),
('戴尔XPS', 5, 9999.00, 100, 1, FALSE);

-- 插入仓库数据
INSERT INTO warehouses (warehouse_name, location, capacity, manager_name) VALUES
('北京主仓库', '北京市海淀区仓储路100号', 10000, '王仓管'),
('上海分仓库', '上海市浦东新区物流大道88号', 8000, '李仓管'),
('广州分仓库', '广州市白云区仓储中心66号', 7000, '张仓管'),
('深圳分仓库', '深圳市南山区物流园区55号', 6000, '刘仓管'),
('成都分仓库', '成都市青羊区仓储中心33号', 5000, '陈仓管');

-- 插入库存数据 (部分示例)
INSERT INTO inventory (product_id, warehouse_id, quantity, last_check_date) VALUES
(1, 1, 50, '2023-05-15'),
(1, 2, 50, '2023-05-15'),
(1, 3, 50, '2023-05-15'),
(1, 4, 50, '2023-05-15'),
(2, 1, 40, '2023-05-15'),
(2, 2, 40, '2023-05-15'),
(2, 3, 35, '2023-05-15'),
(2, 4, 35, '2023-05-15'),
(3, 1, 45, '2023-05-15'),
(3, 2, 45, '2023-05-15'),
(3, 3, 45, '2023-05-15'),
(3, 4, 45, '2023-05-15'),
(4, 1, 30, '2023-05-15'),
(4, 2, 30, '2023-05-15'),
(4, 3, 30, '2023-05-15'),
(4, 4, 30, '2023-05-15'),
(5, 1, 40, '2023-05-15'),
(5, 2, 40, '2023-05-15'),
(5, 3, 40, '2023-05-15'),
(5, 4, 40, '2023-05-15'),
(6, 1, 20, '2023-05-15'),
(6, 2, 20, '2023-05-15'),
(6, 3, 20, '2023-05-15'),
(6, 4, 20, '2023-05-15');

-- 插入员工数据
INSERT INTO employees (first_name, last_name, title, birth_date, hire_date, report_to, department, salary) VALUES
('张', '总经理', '总经理', '1975-05-15', '2010-01-10', NULL, '管理层', 50000.00),
('王', '销售总监', '销售总监', '1980-08-20', '2012-03-15', 1, '销售部', 30000.00),
('李', '市场总监', '市场总监', '1982-04-10', '2013-05-20', 1, '市场部', 28000.00),
('刘', '财务总监', '财务总监', '1978-11-25', '2011-07-18', 1, '财务部', 32000.00),
('陈', '技术总监', '技术总监', '1985-02-28', '2014-09-25', 1, '技术部', 35000.00),
('赵', '销售经理', '销售经理', '1988-06-12', '2015-04-10', 2, '销售部', 20000.00),
('钱', '销售代表', '销售代表', '1990-09-30', '2016-08-15', 6, '销售部', 15000.00),
('孙', '销售代表', '销售代表', '1992-12-05', '2017-10-20', 6, '销售部', 15000.00),
('周', '市场经理', '市场经理', '1987-07-18', '2015-03-05', 3, '市场部', 18000.00),
('吴', '市场专员', '市场专员', '1991-04-22', '2016-06-12', 9, '市场部', 14000.00),
('郑', '财务经理', '财务经理', '1986-03-15', '2014-11-08', 4, '财务部', 22000.00),
('王', '会计', '会计', '1989-08-28', '2016-02-15', 11, '财务部', 16000.00),
('李', '技术经理', '技术经理', '1983-10-10', '2013-12-15', 5, '技术部', 25000.00),
('张', '程序员', '程序员', '1990-05-20', '2016-09-10', 13, '技术部', 18000.00),
('刘', '程序员', '程序员', '1993-02-15', '2018-04-25', 13, '技术部', 18000.00);

-- 插入订单数据
INSERT INTO orders (order_id, user_id, order_date, required_date, shipped_date, status, shipping_fee, payment_method) VALUES
(1, 1, '2023-01-15', '2023-01-20', '2023-01-18', '已完成', 10.00, '支付宝'),
(2, 2, '2023-02-10', '2023-02-15', '2023-02-12', '已完成', 10.00, '微信'),
(3, 3, '2023-03-05', '2023-03-10', '2023-03-07', '已完成', 10.00, '银行卡'),
(4, 4, '2023-04-20', '2023-04-25', '2023-04-22', '已完成', 10.00, '支付宝'),
(5, 5, '2023-05-15', '2023-05-20', '2023-05-17', '已完成', 10.00, '微信'),
(6, 6, '2023-06-10', '2023-06-15', '2023-06-12', '已完成', 10.00, '银行卡'),
(7, 7, '2023-07-05', '2023-07-10', '2023-07-07', '已完成', 10.00, '支付宝'),
(8, 8, '2023-08-20', '2023-08-25', '2023-08-22', '已完成', 10.00, '微信'),
(9, 9, '2023-09-15', '2023-09-20', '2023-09-17', '已完成', 10.00, '银行卡'),
(10, 10, '2023-10-10', '2023-10-15', '2023-10-12', '已完成', 10.00, '支付宝'),
(11, 11, '2023-11-05', '2023-11-10', '2023-11-07', '已完成', 10.00, '微信'),
(12, 12, '2023-12-20', '2023-12-25', '2023-12-22', '已完成', 10.00, '银行卡'),
(13, 1, '2023-01-05', '2023-01-10', '2023-01-07', '已完成', 15.00, '支付宝'),
(14, 1, '2023-02-06', '2023-02-11', '2023-02-08', '已完成', 15.00, '微信'),
(15, 1, '2023-03-07', '2023-03-12', '2023-03-09', '已完成', 15.00, '银行卡'),
(16, 1, '2023-04-08', '2023-04-13', '2023-04-10', '已完成', 15.00, '支付宝'),
(17, 1, '2023-05-09', '2023-05-14', '2023-05-11', '已完成', 15.00, '微信'),
(18, 1, '2023-05-20', '2023-05-25', '2023-05-22', '已完成', 15.00, '支付宝'),
(19, 2, '2023-01-12', '2023-01-17', '2023-01-14', '已完成', 12.00, '支付宝'),
(20, 2, '2023-02-13', '2023-02-18', '2023-02-15', '已完成', 12.00, '微信'),
(21, 2, '2023-03-14', '2023-03-19', '2023-03-16', '已完成', 12.00, '银行卡'),
(22, 2, '2023-04-15', '2023-04-20', '2023-04-17', '已完成', 12.00, '支付宝'),
(23, 2, '2023-05-23', '2023-05-28', '2023-05-25', '已完成', 12.00, '微信'),
(24, 3, '2023-01-22', '2023-01-27', '2023-01-24', '已完成', 20.00, '支付宝'),
(25, 3, '2023-03-23', '2023-03-28', '2023-03-25', '已完成', 20.00, '微信'),
(26, 3, '2023-05-24', '2023-05-29', '2023-05-26', '已完成', 20.00, '银行卡'),
(27, 5, '2023-01-10', '2023-01-15', '2023-01-12', '已完成', 10.00, '支付宝'),
(28, 6, '2023-01-15', '2023-01-20', '2023-01-17', '已完成', 10.00, '微信'),
(29, 7, '2023-01-20', '2023-01-25', '2023-01-22', '已完成', 10.00, '银行卡'),
(30, 8, '2023-01-25', '2023-01-30', '2023-01-27', '已完成', 10.00, '支付宝'),
(31, 9, '2023-02-01', '2023-02-06', '2023-02-03', '已完成', 10.00, '微信'),
(32, 10, '2023-02-05', '2023-02-10', '2023-02-07', '已完成', 10.00, '银行卡'),
(33, 11, '2023-02-10', '2023-02-15', '2023-02-12', '已完成', 10.00, '支付宝'),
(34, 12, '2023-02-15', '2023-02-20', '2023-02-17', '已完成', 10.00, '微信'),
(35, 13, '2023-02-20', '2023-02-25', '2023-02-22', '已完成', 10.00, '银行卡'),
(36, 14, '2023-02-25', '2023-03-02', '2023-02-27', '已完成', 10.00, '支付宝'),
(37, 15, '2023-03-01', '2023-03-06', '2023-03-03', '已完成', 10.00, '微信'),
(38, 1, '2023-03-05', '2023-03-10', '2023-03-07', '已完成', 10.00, '银行卡'),
(39, 2, '2023-03-10', '2023-03-15', '2023-03-12', '已完成', 10.00, '支付宝'),
(40, 3, '2023-03-15', '2023-03-20', '2023-03-17', '已完成', 10.00, '微信'),
(41, 1, '2023-04-01', '2023-04-06', '2023-04-03', '已完成', 10.00, '支付宝'),
(42, 2, '2023-04-05', '2023-04-10', '2023-04-07', '已完成', 10.00, '微信'),
(43, 3, '2023-04-10', '2023-04-15', '2023-04-12', '已完成', 10.00, '银行卡'),
(44, 4, '2023-04-15', '2023-04-20', '2023-04-17', '已完成', 10.00, '支付宝'),
(45, 5, '2023-04-20', '2023-04-25', '2023-04-22', '已完成', 10.00, '微信'),
(46, 6, '2023-04-25', '2023-04-30', '2023-04-27', '已完成', 10.00, '支付宝'),
(47, 7, '2023-04-28', '2023-05-03', '2023-04-30', '已完成', 10.00, '微信'),
(48, 8, '2023-05-01', '2023-05-06', '2023-05-03', '已完成', 10.00, '银行卡');

-- 插入订单明细数据
INSERT INTO order_items (order_item_id, order_id, product_id, quantity, unit_price, discount) VALUES
(1, 1, 1, 2, 100.00, 0.10),
(2, 2, 2, 1, 200.00, 0.05),
(3, 3, 3, 3, 150.00, 0.00),
(4, 4, 4, 1, 300.00, 0.15),
(5, 5, 5, 2, 250.00, 0.20),
(6, 6, 6, 1, 400.00, 0.10),
(7, 7, 7, 2, 350.00, 0.05),
(8, 8, 8, 3, 450.00, 0.00),
(9, 9, 9, 1, 500.00, 0.10),
(10, 10, 10, 2, 550.00, 0.15),
(11, 11, 11, 1, 600.00, 0.20),
(12, 12, 12, 3, 650.00, 0.00),
(13, 13, 6, 1, 12999.00, 0.05),
(14, 14, 9, 1, 10999.00, 0.05),
(15, 15, 8, 1, 9999.00, 0.05),
(16, 16, 6, 1, 12999.00, 0.05),
(17, 17, 7, 1, 8999.00, 0.05),
(18, 17, 14, 1, 1599.00, 0.05),
(19, 18, 11, 2, 1999.00, 0.05),
(20, 19, 19, 2, 399.00, 0.00),
(21, 19, 16, 3, 199.00, 0.00),
(22, 20, 21, 2, 299.00, 0.00),
(23, 20, 22, 3, 189.00, 0.00),
(24, 21, 17, 2, 299.00, 0.00),
(25, 21, 23, 2, 289.00, 0.00),
(26, 22, 24, 1, 599.00, 0.00),
(27, 22, 20, 1, 999.00, 0.00),
(28, 23, 25, 2, 329.00, 0.00),
(29, 24, 6, 1, 12999.00, 0.10),
(30, 24, 11, 2, 1999.00, 0.10),
(31, 25, 9, 1, 10999.00, 0.10),
(32, 25, 13, 1, 599.00, 0.00),
(33, 26, 8, 1, 9999.00, 0.10),
(34, 26, 14, 2, 1599.00, 0.00),
(35, 27, 1, 1, 5999.00, 0.00),
(36, 27, 11, 1, 1999.00, 0.00),
(37, 31, 1, 1, 5999.00, 0.00),
(38, 31, 11, 1, 1999.00, 0.00),
(39, 34, 1, 1, 5999.00, 0.00),
(40, 34, 11, 1, 1999.00, 0.00),
(41, 36, 1, 1, 5999.00, 0.00),
(42, 36, 11, 1, 1999.00, 0.00),
(43, 38, 1, 1, 5999.00, 0.00),
(44, 38, 11, 1, 1999.00, 0.00),
(45, 40, 1, 1, 5999.00, 0.00),
(46, 40, 11, 1, 1999.00, 0.00),
(47, 28, 6, 1, 12999.00, 0.00),
(48, 28, 13, 1, 599.00, 0.00),
(49, 32, 6, 1, 12999.00, 0.00),
(50, 32, 13, 1, 599.00, 0.00),
(51, 35, 6, 1, 12999.00, 0.00),
(52, 35, 13, 1, 599.00, 0.00),
(53, 37, 6, 1, 12999.00, 0.00),
(54, 37, 13, 1, 599.00, 0.00),
(55, 39, 6, 1, 12999.00, 0.00),
(56, 39, 13, 1, 599.00, 0.00),
(57, 29, 16, 1, 199.00, 0.00),
(58, 29, 17, 1, 299.00, 0.00),
(59, 33, 16, 1, 199.00, 0.00),
(60, 33, 17, 1, 299.00, 0.00),
(61, 37, 16, 1, 199.00, 0.00),
(62, 37, 17, 1, 299.00, 0.00),
(63, 40, 16, 1, 199.00, 0.00),
(64, 40, 17, 1, 299.00, 0.00),
(65, 30, 12, 1, 199.00, 0.00),
(66, 30, 14, 1, 1599.00, 0.00),
(67, 36, 12, 1, 199.00, 0.00),
(68, 36, 14, 1, 1599.00, 0.00),
(69, 39, 12, 1, 199.00, 0.00),
(70, 39, 14, 1, 1599.00, 0.00),
(71, 30, 11, 1, 1999.00, 0.00),
(72, 31, 6, 1, 12999.00, 0.00),
(73, 32, 16, 1, 199.00, 0.00),
(74, 33, 12, 1, 199.00, 0.00),
(75, 34, 14, 1, 1599.00, 0.00),
(76, 35, 17, 1, 299.00, 0.00),
(77, 38, 14, 1, 1599.00, 0.00),
(78, 41, 1, 1, 5999.00, 0.00),
(79, 41, 11, 1, 1999.00, 0.00),
(80, 42, 1, 1, 5999.00, 0.00),
(81, 42, 11, 1, 1999.00, 0.00),
(82, 43, 1, 1, 5999.00, 0.00),
(83, 43, 11, 1, 1999.00, 0.00),
(84, 44, 6, 1, 12999.00, 0.00),
(85, 44, 13, 1, 599.00, 0.00),
(86, 45, 6, 1, 12999.00, 0.00),
(87, 45, 13, 1, 599.00, 0.00),
(88, 41, 16, 1, 199.00, 0.00),
(89, 41, 17, 1, 299.00, 0.00),
(90, 45, 16, 1, 199.00, 0.00),
(91, 45, 17, 1, 299.00, 0.00),
(92, 43, 12, 1, 199.00, 0.00),
(93, 46, 12, 1, 199.00, 0.00),
(94, 46, 14, 1, 1599.00, 0.00),
(95, 47, 12, 1, 199.00, 0.00),
(96, 47, 14, 1, 1599.00, 0.00),
(97, 48, 12, 1, 199.00, 0.00),
(98, 48, 14, 1, 1599.00, 0.00);

-- 插入客户评价数据
INSERT INTO reviews (product_id, user_id, rating, comment, review_date) VALUES
(1, 1, 5, '手机很好用，性能强大', '2023-05-03 10:00:00'),
(1, 2, 4, '整体不错，就是价格有点贵', '2023-05-04 14:30:00'),
(2, 3, 5, '电脑性能很好，做工精细', '2023-05-05 09:15:00'),
(3, 4, 4, 'T恤面料舒适，款式好看', '2023-05-06 16:45:00'),
(4, 5, 5, '连衣裙很漂亮，穿着舒服', '2023-05-07 11:20:00'),
(5, 6, 4, '薯片很好吃，就是有点贵', '2023-05-08 13:40:00'),
(6, 7, 5, '可乐很好喝，价格实惠', '2023-05-09 15:50:00'),
(7, 8, 4, '手机不错，就是电池续航一般', '2023-05-10 17:30:00'),
(13, 1, 3, '小米12发热严重，续航一般', '2023-05-11 10:00:00'),
(13, 2, 2, '小米12系统不稳定，经常卡顿', '2023-05-12 14:30:00'),
(13, 3, 3, '小米12相机效果一般', '2023-05-13 09:15:00'),
(14, 4, 2, '戴尔XPS散热差，风扇噪音大', '2023-05-14 16:45:00'),
(14, 5, 3, '戴尔XPS电池续航短', '2023-05-15 11:20:00'),
(14, 6, 2, '戴尔XPS做工一般，性价比低', '2023-05-16 13:40:00');

-- 插入用户活动日志数据
INSERT INTO user_activity_logs (user_id, activity_type, activity_details, ip_address, user_agent, created_at) VALUES
-- 用户1的活动
(1, '浏览产品', '浏览了iPhone 13产品页面', '192.168.1.101', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', '2023-05-01 10:00:00'),
(1, '添加购物车', '将iPhone 13添加到购物车', '192.168.1.101', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', '2023-05-01 10:05:00'),
(1, '下单', '创建了订单#10001，包含iPhone 13', '192.168.1.101', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', '2023-05-01 10:10:00'),
(1, '支付', '完成了订单#10001的支付，金额5999元', '192.168.1.101', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', '2023-05-01 10:15:00'),
(1, '浏览产品', '浏览了MacBook Pro产品页面', '192.168.1.101', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', '2023-05-05 14:00:00'),
(1, '添加购物车', '将MacBook Pro添加到购物车', '192.168.1.101', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', '2023-05-05 14:05:00'),
(1, '下单', '创建了订单#10002，包含MacBook Pro', '192.168.1.101', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', '2023-05-05 14:10:00'),
(1, '支付', '完成了订单#10002的支付，金额12999元', '192.168.1.101', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', '2023-05-05 14:15:00'),

-- 用户2的活动
(2, '浏览产品', '浏览了小米11产品页面', '192.168.1.102', 'Mozilla/5.0 (iPhone; CPU iPhone OS 14_0)', '2023-05-02 11:00:00'),
(2, '添加购物车', '将小米11添加到购物车', '192.168.1.102', 'Mozilla/5.0 (iPhone; CPU iPhone OS 14_0)', '2023-05-02 11:10:00'),
(2, '下单', '创建了订单#10003，包含小米11', '192.168.1.102', 'Mozilla/5.0 (iPhone; CPU iPhone OS 14_0)', '2023-05-02 11:20:00'),
(2, '支付', '完成了订单#10003的支付，金额3999元', '192.168.1.102', 'Mozilla/5.0 (iPhone; CPU iPhone OS 14_0)', '2023-05-02 11:30:00'),
(2, '浏览产品', '浏览了OPPO Find X3产品页面', '192.168.1.102', 'Mozilla/5.0 (iPhone; CPU iPhone OS 14_0)', '2023-05-10 13:00:00'),
(2, '添加购物车', '将OPPO Find X3添加到购物车', '192.168.1.102', 'Mozilla/5.0 (iPhone; CPU iPhone OS 14_0)', '2023-05-10 13:10:00'),
(2, '下单', '创建了订单#10004，包含OPPO Find X3', '192.168.1.102', 'Mozilla/5.0 (iPhone; CPU iPhone OS 14_0)', '2023-05-10 13:20:00'),

-- 用户3的活动
(3, '浏览产品', '浏览了vivo X60产品页面', '192.168.1.103', 'Mozilla/5.0 (Linux; Android 10)', '2023-05-03 09:00:00'),
(3, '添加购物车', '将vivo X60添加到购物车', '192.168.1.103', 'Mozilla/5.0 (Linux; Android 10)', '2023-05-03 09:05:00'),
(3, '下单', '创建了订单#10005，包含vivo X60', '192.168.1.103', 'Mozilla/5.0 (Linux; Android 10)', '2023-05-03 09:10:00'),
(3, '支付', '完成了订单#10005的支付，金额3799元', '192.168.1.103', 'Mozilla/5.0 (Linux; Android 10)', '2023-05-03 09:15:00'),
(3, '浏览产品', '浏览了AirPods Pro产品页面', '192.168.1.103', 'Mozilla/5.0 (Linux; Android 10)', '2023-05-15 16:00:00'),
(3, '添加购物车', '将AirPods Pro添加到购物车', '192.168.1.103', 'Mozilla/5.0 (Linux; Android 10)', '2023-05-15 16:05:00'),

-- 用户4的活动
(4, '浏览产品', '浏览了蓝牙鼠标产品页面', '192.168.1.104', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', '2023-05-04 15:00:00'),
(4, '添加购物车', '将蓝牙鼠标添加到购物车', '192.168.1.104', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', '2023-05-04 15:10:00'),
(4, '下单', '创建了订单#10006，包含蓝牙鼠标', '192.168.1.104', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', '2023-05-04 15:20:00'),
(4, '支付', '完成了订单#10006的支付，金额199元', '192.168.1.104', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', '2023-05-04 15:30:00'),
(4, '浏览产品', '浏览了机械键盘产品页面', '192.168.1.104', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', '2023-05-20 10:00:00'),

-- 用户5的活动
(5, '浏览产品', '浏览了显示器产品页面', '192.168.1.105', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)', '2023-05-05 12:00:00'),
(5, '添加购物车', '将显示器添加到购物车', '192.168.1.105', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)', '2023-05-05 12:05:00'),
(5, '下单', '创建了订单#10007，包含显示器', '192.168.1.105', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)', '2023-05-05 12:10:00'),
(5, '支付', '完成了订单#10007的支付，金额1599元', '192.168.1.105', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)', '2023-05-05 12:15:00'),

-- 用户6的活动
(6, '浏览产品', '浏览了移动硬盘产品页面', '192.168.1.106', 'Mozilla/5.0 (Linux; Android 11)', '2023-05-06 14:00:00'),
(6, '添加购物车', '将移动硬盘添加到购物车', '192.168.1.106', 'Mozilla/5.0 (Linux; Android 11)', '2023-05-06 14:05:00'),
(6, '下单', '创建了订单#10008，包含移动硬盘', '192.168.1.106', 'Mozilla/5.0 (Linux; Android 11)', '2023-05-06 14:10:00'),
(6, '支付', '完成了订单#10008的支付，金额499元', '192.168.1.106', 'Mozilla/5.0 (Linux; Android 11)', '2023-05-06 14:15:00'),

-- 用户7的活动
(7, '浏览产品', '浏览了男士T恤产品页面', '192.168.1.107', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0)', '2023-05-07 16:00:00'),
(7, '添加购物车', '将男士T恤添加到购物车', '192.168.1.107', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0)', '2023-05-07 16:05:00'),
(7, '下单', '创建了订单#10009，包含男士T恤', '192.168.1.107', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0)', '2023-05-07 16:10:00'),

-- 用户8的活动
(8, '浏览产品', '浏览了男士牛仔裤产品页面', '192.168.1.108', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', '2023-05-08 10:00:00'),
(8, '添加购物车', '将男士牛仔裤添加到购物车', '192.168.1.108', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', '2023-05-08 10:05:00'),

-- 用户9的活动
(9, '浏览产品', '浏览了男士衬衫产品页面', '192.168.1.109', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)', '2023-05-09 11:00:00'),

-- 用户10的活动
(10, '浏览产品', '浏览了男士夹克产品页面', '192.168.1.110', 'Mozilla/5.0 (Linux; Android 12)', '2023-05-10 13:00:00'),
(10, '添加购物车', '将男士夹克添加到购物车', '192.168.1.110', 'Mozilla/5.0 (Linux; Android 12)', '2023-05-10 13:05:00'),
(10, '下单', '创建了订单#10010，包含男士夹克', '192.168.1.110', 'Mozilla/5.0 (Linux; Android 12)', '2023-05-10 13:10:00'),
(10, '支付', '完成了订单#10010的支付，金额399元', '192.168.1.110', 'Mozilla/5.0 (Linux; Android 12)', '2023-05-10 13:15:00');

-- 添加2023年1月注册的新用户
INSERT INTO users (user_id, username, email, phone, register_date, last_login, is_active, user_level) VALUES
(16, '宋一', 'song1@example.com', '13800138016', '2023-01-05', '2023-06-10 12:30:00', TRUE, '普通'),
(17, '钱二', 'qian2@example.com', '13800138017', '2023-01-10', '2023-05-28 15:45:00', TRUE, '银卡'),
(18, '周三', 'zhou3@example.com', '13800138018', '2023-01-15', '2023-04-20 09:30:00', TRUE, '普通'),
(19, '吴四', 'wu4@example.com', '13800138019', '2023-01-20', '2023-03-15 14:20:00', FALSE, '普通'),
(20, '郑五', 'zheng5@example.com', '13800138020', '2023-01-25', '2023-02-28 16:10:00', TRUE, '金卡');

-- 添加这些用户在不同月份的活动记录
INSERT INTO user_activity_logs (user_id, activity_type, activity_details, ip_address, user_agent, created_at) VALUES
-- 1月份活动（全部用户活跃）
(16, '浏览产品', '浏览了iPhone 13产品页面', '192.168.1.116', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', '2023-01-10 10:00:00'),
(16, '添加购物车', '将iPhone 13添加到购物车', '192.168.1.116', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', '2023-01-10 10:05:00'),
(17, '浏览产品', '浏览了华为P40产品页面', '192.168.1.117', 'Mozilla/5.0 (iPhone; CPU iPhone OS 14_0)', '2023-01-12 11:00:00'),
(17, '添加购物车', '将华为P40添加到购物车', '192.168.1.117', 'Mozilla/5.0 (iPhone; CPU iPhone OS 14_0)', '2023-01-12 11:10:00'),
(18, '浏览产品', '浏览了小米11产品页面', '192.168.1.118', 'Mozilla/5.0 (Linux; Android 10)', '2023-01-18 09:00:00'),
(18, '下单', '创建了订单#20001，包含小米11', '192.168.1.118', 'Mozilla/5.0 (Linux; Android 10)', '2023-01-18 09:10:00'),
(19, '浏览产品', '浏览了OPPO Find X3产品页面', '192.168.1.119', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', '2023-01-25 15:00:00'),
(20, '浏览产品', '浏览了vivo X60产品页面', '192.168.1.120', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)', '2023-01-27 12:00:00'),

-- 2月份活动（4/5用户活跃）
(16, '浏览产品', '浏览了MacBook Pro产品页面', '192.168.1.116', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', '2023-02-05 14:00:00'),
(16, '添加购物车', '将MacBook Pro添加到购物车', '192.168.1.116', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', '2023-02-05 14:05:00'),
(17, '浏览产品', '浏览了联想ThinkPad产品页面', '192.168.1.117', 'Mozilla/5.0 (iPhone; CPU iPhone OS 14_0)', '2023-02-08 13:00:00'),
(18, '浏览产品', '浏览了华硕ROG产品页面', '192.168.1.118', 'Mozilla/5.0 (Linux; Android 10)', '2023-02-15 16:00:00'),
(20, '浏览产品', '浏览了戴尔XPS产品页面', '192.168.1.120', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)', '2023-02-20 12:00:00'),
(20, '添加购物车', '将戴尔XPS添加到购物车', '192.168.1.120', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)', '2023-02-20 12:05:00'),

-- 3月份活动（3/5用户活跃）
(16, '浏览产品', '浏览了AirPods Pro产品页面', '192.168.1.116', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', '2023-03-10 10:00:00'),
(16, '添加购物车', '将AirPods Pro添加到购物车', '192.168.1.116', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', '2023-03-10 10:05:00'),
(17, '浏览产品', '浏览了蓝牙鼠标产品页面', '192.168.1.117', 'Mozilla/5.0 (iPhone; CPU iPhone OS 14_0)', '2023-03-15 11:00:00'),
(19, '浏览产品', '浏览了机械键盘产品页面', '192.168.1.119', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', '2023-03-25 15:00:00'),

-- 4月份活动（3/5用户活跃）
(16, '浏览产品', '浏览了显示器产品页面', '192.168.1.116', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', '2023-04-08 10:00:00'),
(18, '浏览产品', '浏览了移动硬盘产品页面', '192.168.1.118', 'Mozilla/5.0 (Linux; Android 10)', '2023-04-12 09:00:00'),
(18, '添加购物车', '将移动硬盘添加到购物车', '192.168.1.118', 'Mozilla/5.0 (Linux; Android 10)', '2023-04-12 09:05:00'),
(20, '浏览产品', '浏览了男士T恤产品页面', '192.168.1.120', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)', '2023-04-20 12:00:00'),

-- 5月份活动（2/5用户活跃）
(16, '浏览产品', '浏览了男士牛仔裤产品页面', '192.168.1.116', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', '2023-05-05 10:00:00'),
(17, '浏览产品', '浏览了男士衬衫产品页面', '192.168.1.117', 'Mozilla/5.0 (iPhone; CPU iPhone OS 14_0)', '2023-05-15 11:00:00'),

-- 6月份活动（1/5用户活跃）
(16, '浏览产品', '浏览了男士夹克产品页面', '192.168.1.116', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', '2023-06-10 10:00:00'); 