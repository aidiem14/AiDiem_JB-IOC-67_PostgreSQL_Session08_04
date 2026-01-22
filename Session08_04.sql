create table products (
	id serial primary key,
	name varchar(100),
	price numeric,
	discount_percent int
);

insert into products (name, price, discount_percent) values
('Laptop Dell Inspiron', 18000000, 10),
('Laptop Hp Pavilion', 16500000, 8),
('Laptop Lenovo Thinkpad', 20000000, 12),
('Laptop Asus Vivobook', 15000000, 5),
('Laptop Xiaomi Redmi', 14000000, 7),
('Iphone 14', 22000000, 15),
('Samsung Galaxy S23', 21000000, 10),
('Ipad Air', 17000000, 8),
('Sony Headphones', 3200000, 5),
('Logitech Wireless Mouse', 550000, 0);

-- Viết Procedure calculate_discount(p_id INT, OUT p_final_price NUMERIC) để:
-- Lấy price và discount_percent của sản phẩm
-- Tính giá sau giảm: p_final_price = price - (price * discount_percent / 100)
-- Nếu phần trăm giảm giá > 50, thì giới hạn chỉ còn 50%
create or replace procedure calculate_discount(p_id int, out p_final_price numeric)
language plpgsql
as $$
declare
p_price int;
p_discount_percent int;
begin
select price, discount_percent into p_price, p_discount_percent from products where id = p_id;
if p_price is null then raise exception 'Sản phẩm không tồn tại';
end if;
if p_discount_percent > 50 then p_discount_percent := 50; 
end if;
p_final_price := p_price - (p_price * p_discount_percent/100);
end;
$$;

-- Cập nhật lại cột price trong bảng products thành giá sau giảm
update products set price = price - (
price * 
case
when discount_percent > 50 then 50
else discount_percent
end / 100
);

-- Gọi thử
DO $$ 
DECLARE 
    v_final_price NUMERIC;
BEGIN 
    -- Gọi procedure và truyền biến vào vị trí OUT
    CALL calculate_discount(2, v_final_price); 

    -- In kết quả ra màn hình (Thông báo)
    RAISE NOTICE 'Lương mới là: %', v_final_price;
END $$;
