-- Dữ liệu
create database shop_db;

create table products (
    product_id serial primary key,
    product_name varchar(100),
    category varchar(50)
);

create table orders (
    order_id serial primary key,
    product_id int,
    quantity int,
    total_price int,
    foreign key (product_id) references products(product_id)
);

insert into products (product_id, product_name, category) values
(1, 'laptop dell', 'electronics'),
(2, 'iphone 15', 'electronics'),
(3, 'bàn học gỗ', 'furniture'),
(4, 'ghế xoay', 'furniture');

insert into orders (order_id, product_id, quantity, total_price) values
(101, 1, 2, 2200),
(102, 2, 3, 3300),
(103, 3, 5, 2500),
(104, 4, 4, 1600),
(105, 1, 1, 1100);

-- Yêu cầu:
--1. Viết truy vấn hiển thị tổng doanh thu (SUM(total_price)) và số lượng sản phẩm bán được (SUM(quantity)) cho từng nhóm danh mục (category)
	--Đặt bí danh cột như sau:
		--total_sales cho tổng doanh thu
		-- total_quantity cho tổng số lượng
select 
    p.category,
    sum(o.total_price) as total_sales,
    sum(o.quantity) as total_quantity
from orders o
join products p on o.product_id = p.product_id
group by p.category;
		
--2. Chỉ hiển thị những nhóm có tổng doanh thu lớn hơn 2000
select 
    p.category,
    sum(o.total_price) as total_sales,
    sum(o.quantity) as total_quantity
from orders o
join products p on o.product_id = p.product_id
group by p.category
having sum(o.total_price) > 2000;

--3. Sắp xếp kết quả theo tổng doanh thu giảm dần
select 
    p.category,
    sum(o.total_price) as total_sales,
    sum(o.quantity) as total_quantity
from orders o
join products p on o.product_id = p.product_id
group by p.category
having sum(o.total_price) > 2000
order by total_sales desc;