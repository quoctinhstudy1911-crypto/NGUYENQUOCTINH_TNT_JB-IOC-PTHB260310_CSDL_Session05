--1. Viết truy vấn con (Subquery) để tìm sản phẩm có doanh thu cao nhất trong bảng orders
	-- Hiển thị: product_name, total_revenue
select 
    p.product_name,
    sum(o.total_price) as total_revenue
from orders o
join products p on o.product_id = p.product_id
group by p.product_id, p.product_name
having sum(o.total_price) = (
    select max(total_revenue)
    from (
        select sum(total_price) as total_revenue
        from orders
        group by product_id
    ) as sub
);

--2. Viết truy vấn hiển thị tổng doanh thu theo từng nhóm category (dùng JOIN + GROUP BY)
select 
    p.category,
    sum(o.total_price) as total_revenue
from orders o
join products p on o.product_id = p.product_id
group by p.category;

--3. Dùng INTERSECT để tìm ra nhóm category có sản phẩm bán chạy nhất (ở câu 1) cũng nằm trong danh sách nhóm có tổng doanh thu lớn hơn 3000
(
    select p.category
    from products p
    where p.product_id in (
        select product_id
        from orders
        group by product_id
        having sum(total_price) = (
            select max(total_revenue)
            from (
                select sum(total_price) as total_revenue
                from orders
                group by product_id
            ) as sub
        )
    )
)
intersect
(
    select p.category
    from orders o
    join products p on o.product_id = p.product_id
    group by p.category
    having sum(o.total_price) > 3000
);
