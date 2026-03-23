-- Dữ liệu 
create database ql_shop;

create table customers (
    customer_id serial primary key,
    customer_name varchar(100),
    city varchar(100)
);

create table orders (
    order_id serial primary key,
    customer_id int,
    order_date date,
    total_price int,
    foreign key (customer_id) references customers(customer_id)
);

create table order_items (
    item_id serial primary key,
    order_id int,
    product_id int,
    quantity int,
    price int,
    foreign key (order_id) references orders(order_id)
);


insert into customers (customer_name, city) values
('nguyễn văn a', 'hà nội'),
('trần thị b', 'đà nẵng'),
('lê văn c', 'hồ chí minh'),
('phạm thị d', 'hà nội');

insert into orders (customer_id, order_date, total_price) values
(1, '2024-12-20', 3000),
(2, '2025-01-05', 1500),
(1, '2025-02-10', 2500),
(3, '2025-02-15', 4000),
(4, '2025-03-01', 800);

insert into order_items (order_id, product_id, quantity, price) values
(1, 1, 2, 1500),
(2, 2, 1, 1500),
(3, 3, 5, 500),
(4, 2, 4, 1000);

-- Yêu cầu
/*
1. Viết truy vấn hiển thị tổng doanh thu và tổng số đơn hàng của mỗi khách hàng:
	Chỉ hiển thị khách hàng có tổng doanh thu > 2000
	Dùng ALIAS: total_revenue và order_count
*/
select 
    c.customer_name,
    sum(o.total_price) as total_revenue,
    count(o.order_id) as order_count
from customers c
join orders o on c.customer_id = o.customer_id
group by c.customer_id, c.customer_name
having sum(o.total_price) > 2000;

/*
2. Viết truy vấn con (Subquery) để tìm doanh thu trung bình của tất cả khách hàng
	Sau đó hiển thị những khách hàng có doanh thu lớn hơn mức trung bình đó
*/
select 
    c.customer_name,
    sum(o.total_price) as total_revenue
from customers c
join orders o on c.customer_id = o.customer_id
group by c.customer_id, c.customer_name
having sum(o.total_price) > (
    select avg(total_revenue)
    from (
        select sum(total_price) as total_revenue
        from orders
        group by customer_id
    ) as sub
);

/*
3. Dùng HAVING + GROUP BY để lọc ra thành phố có tổng doanh thu cao nhất
*/
select 
    c.city,
    sum(o.total_price) as total_revenue
from customers c
join orders o on c.customer_id = o.customer_id
group by c.city
having sum(o.total_price) = (
    select max(total_revenue)
    from (
        select sum(o.total_price) as total_revenue
        from customers c
        join orders o on c.customer_id = o.customer_id
        group by c.city
    ) as sub
);

/*
4. (Mở rộng) Hãy dùng INNER JOIN giữa customers, orders, order_items để hiển thị chi tiết:
Tên khách hàng, tên thành phố, tổng sản phẩm đã mua, tổng chi tiêu
*/
select 
    c.customer_name,
    c.city,
    sum(oi.quantity) as total_products,
    sum(oi.quantity * oi.price) as total_spent
from customers c
join orders o on c.customer_id = o.customer_id
join order_items oi on o.order_id = oi.order_id
group by c.customer_id, c.customer_name, c.city;