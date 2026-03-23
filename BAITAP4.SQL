-- Dữ liệu
create database qlshop_db;

create table customers (
    customer_id serial primary key,
    customer_name varchar(100) not null,
    city varchar(50) not null
);
create table orders (
    order_id serial primary key,
    customer_id int not null references customers(customer_id),
    order_date date not null,
    total_amount numeric(10,2) not null
);
create table order_items (
    item_id serial primary key,
    order_id int not null references orders(order_id),
    product_name varchar(100) not null,
    quantity int not null check (quantity > 0),
    price numeric(10,2) not null
);
insert into customers (customer_name, city) values
('nguyễn văn a', 'hà nội'),
('trần thị b', 'đà nẵng'),
('lê văn c', 'hồ chí minh'),
('phạm thị d', 'hà nội');
insert into orders (customer_id, order_date, total_amount) values
(1, '2024-12-20', 3000),
(2, '2025-01-05', 1500),
(1, '2025-02-10', 2500),
(3, '2025-02-15', 4000),
(4, '2025-03-01', 800);
insert into order_items (order_id, product_name, quantity, price) values
(1, 'laptop dell', 2, 1500),
(2, 'iphone 15', 1, 1500),
(3, 'bàn học gỗ', 5, 500),
(4, 'iphone 15', 4, 1000);

select * from order_items

-- Yêu cầu
-- 1. alias:
-- a. hiển thị danh sách tất cả các đơn hàng với các cột:
--    i. tên khách (customer_name)
--    ii. ngày đặt hàng (order_date)
--    iii. tổng tiền (total_amount)
select 
    c.customer_name as customer_name,
    o.order_date as order_date,
    o.total_amount as total_amount
from orders o
join customers c on o.customer_id = c.customer_id;

-- 2. aggregate functions:
-- a. tính các thông tin tổng hợp:
--    i. tổng doanh thu (sum(total_amount))
--    ii. trung bình giá trị đơn hàng (avg(total_amount))
--    iii. đơn hàng lớn nhất (max(total_amount))
--    iv. đơn hàng nhỏ nhất (min(total_amount))
--    v. số lượng đơn hàng (count(order_id))
select 
    sum(total_amount) as total_revenue,   -- tổng doanh thu
    avg(total_amount) as avg_order_value, -- trung bình đơn hàng
    max(total_amount) as max_order,       -- đơn lớn nhất
    min(total_amount) as min_order,       -- đơn nhỏ nhất
    count(order_id) as order_count        -- số lượng đơn
from orders;

-- 3. group by / having:
-- a. tính tổng doanh thu theo từng thành phố
-- b. chỉ hiển thị những thành phố có tổng doanh thu lớn hơn 10.000
select 
    c.city,
    sum(o.total_amount) as total_revenue
from customers c
join orders o on c.customer_id = o.customer_id
group by c.city
having sum(o.total_amount) > 10000;

-- 4. join:
-- a. liệt kê tất cả các sản phẩm đã bán, kèm:
--    i. tên khách hàng
--    ii. ngày đặt hàng
--    iii. số lượng và giá
--    iv. (join 3 bảng customers, orders, order_items)
select 
    c.customer_name,
    o.order_date,
    oi.quantity,
    oi.price
from customers c
join orders o on c.customer_id = o.customer_id
join order_items oi on o.order_id = oi.order_id;

-- 5. subquery:
-- a. tìm tên khách hàng có tổng doanh thu cao nhất
-- b. gợi ý: dùng sum(total_amount) trong subquery để tìm max
select 
    c.customer_name,
    sum(o.total_amount) as total_revenue
from customers c
join orders o on c.customer_id = o.customer_id
group by c.customer_id, c.customer_name
having sum(o.total_amount) = (
    select max(total_revenue)
    from (
        select sum(total_amount) as total_revenue
        from orders
        group by customer_id
    ) as sub
);

-- 6. union và intersect:
-- a. dùng union để hiển thị danh sách tất cả thành phố có khách hàng hoặc có đơn hàng
select city from customers
union
select c.city
from orders o
join customers c on o.customer_id = c.customer_id;

-- b. dùng intersect để hiển thị các thành phố vừa có khách hàng vừa có đơn hàng
select city from customers
intersect
select c.city
from orders o
join customers c on o.customer_id = c.customer_id;

