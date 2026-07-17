CREATE TABLE ecommerce.customers_clean (
    customer_id VARCHAR(20) PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    phone BIGINT,
    city VARCHAR(50),
    state VARCHAR(50),
    pincode INTEGER,
    gender VARCHAR(10),
    age INTEGER,
    segment VARCHAR(30),
    registration_date DATE,
    last_login_date DATE,
    is_verified BOOLEAN,
    is_active BOOLEAN,
    total_orders INTEGER,
    total_spent NUMERIC(12,2)
);

select * from ecommerce.customers_clean
limit 5


CREATE TABLE ecommerce.suppliers_clean (
    supplier_id VARCHAR(20) PRIMARY KEY,
    supplier_name VARCHAR(100),
    contact_person VARCHAR(100),
    email VARCHAR(100),
    phone BIGINT,
    city VARCHAR(50),
    state VARCHAR(50),
    pincode INTEGER,
    category VARCHAR(50),
    gstin VARCHAR(30),
    payment_terms_days INTEGER,
    rating NUMERIC(3,2),
    created_date DATE,
    is_active BOOLEAN
);

select * from ecommerce.suppliers_clean
limit 5

CREATE TABLE ecommerce.products_clean (
    product_id VARCHAR(20) PRIMARY KEY,
    product_name VARCHAR(200),
    category VARCHAR(50),
    subcategory VARCHAR(50),
    brand VARCHAR(100),
    sku VARCHAR(50),
    mrp NUMERIC(10,2),
    selling_price NUMERIC(10,2),
    cost_price NUMERIC(10,2),
    gst_rate NUMERIC(5,2),
    hsn_code BIGINT,
    weight_grams INTEGER,
    supplier_id VARCHAR(20),
    rating NUMERIC(3,2),
    review_count INTEGER,
    is_active BOOLEAN,
    launch_date DATE,

    CONSTRAINT fk_supplier
        FOREIGN KEY (supplier_id)
        REFERENCES ecommerce.suppliers_clean(supplier_id)
);


select * from ecommerce.products_clean
limit 5


CREATE TABLE ecommerce.orders_clean (
    order_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(20),
    order_date DATE,
    order_time TIME,
    status VARCHAR(30),
    city VARCHAR(50),
    state VARCHAR(50),
    pincode INTEGER,
    total_amount NUMERIC(12,2),
    gst_amount NUMERIC(12,2),
    shipping_charge NUMERIC(10,2),
    discount_amount NUMERIC(10,2),
    final_amount NUMERIC(12,2),
    payment_method VARCHAR(50),
    shipping_partner VARCHAR(100),
    tracking_id VARCHAR(100),
    delivered_date DATE,
    is_cod BOOLEAN,
    channel VARCHAR(30),

    CONSTRAINT fk_customer
        FOREIGN KEY (customer_id)
        REFERENCES ecommerce.customers_clean(customer_id)
);

select * from ecommerce.orders_clean
limit 5


CREATE TABLE ecommerce.order_items_clean (
    item_id VARCHAR(20) PRIMARY KEY,
    order_id VARCHAR(20),
    product_id VARCHAR(20),
    product_name VARCHAR(200),
    category VARCHAR(50),
    quantity INTEGER,
    unit_price NUMERIC(10,2),
    gst_rate NUMERIC(5,2),
    gst_amount NUMERIC(10,2),
    discount_amount NUMERIC(10,2),
    total_price NUMERIC(12,2),

    CONSTRAINT fk_order
        FOREIGN KEY (order_id)
        REFERENCES ecommerce.orders_clean(order_id),

    CONSTRAINT fk_product
        FOREIGN KEY (product_id)
        REFERENCES ecommerce.products_clean(product_id)
);

select * from ecommerce.order_items_clean
limit 5

CREATE TABLE ecommerce.payments_clean (
    payment_id VARCHAR(20) PRIMARY KEY,
    order_id VARCHAR(20),
    customer_id VARCHAR(20),
    payment_date DATE,
    payment_time TIME,
    payment_method VARCHAR(50),
    amount NUMERIC(12,2),
    status VARCHAR(30),
    transaction_id VARCHAR(100),
    bank_name VARCHAR(100),
    gateway VARCHAR(100),
    refund_amount NUMERIC(12,2),
    refund_date DATE,

    CONSTRAINT fk_payment_order
        FOREIGN KEY (order_id)
        REFERENCES ecommerce.orders_clean(order_id),

    CONSTRAINT fk_payment_customer
        FOREIGN KEY (customer_id)
        REFERENCES ecommerce.customers_clean(customer_id)
);

select * from ecommerce.payments_clean
limit 5

CREATE TABLE ecommerce.returns_clean (
    return_id VARCHAR(20) PRIMARY KEY,
    order_id VARCHAR(20),
    customer_id VARCHAR(20),
    return_date DATE,
    reason VARCHAR(200),
    return_amount NUMERIC(12,2),
    refund_status VARCHAR(30),
    refund_date DATE,
    return_condition VARCHAR(100),
    remarks TEXT,

    CONSTRAINT fk_return_order
        FOREIGN KEY (order_id)
        REFERENCES ecommerce.orders_clean(order_id),

    CONSTRAINT fk_return_customer
        FOREIGN KEY (customer_id)
        REFERENCES ecommerce.customers_clean(customer_id)
);

select * from ecommerce.returns_clean
limit 5

CREATE TABLE ecommerce.inventory_clean (
    inventory_id VARCHAR(20) PRIMARY KEY,
    product_id VARCHAR(20),
    warehouse_location VARCHAR(100),
    quantity_available INTEGER,
    quantity_reserved INTEGER,
    reorder_level INTEGER,
    reorder_quantity INTEGER,
    last_restocked_date DATE,
    unit_cost NUMERIC(10,2),
    total_inventory_value NUMERIC(15,2),
    status VARCHAR(30),
    calculated_value NUMERIC(15,2),

    CONSTRAINT fk_inventory_product
        FOREIGN KEY (product_id)
        REFERENCES ecommerce.products_clean(product_id)
);

select * from ecommerce.inventory_clean
limit 5


select count(*)
from ecommerce.customers_clean

select count(*)
from ecommerce.orders_clean

select count(*)
from ecommerce.order_items_clean

select count(*)
from ecommerce.products_clean

select count(*)
from ecommerce.payments_clean

select count(*)
from ecommerce.returns_clean;

select count(*)
from ecommerce.inventory_clean;

select count(*)
from ecommerce.suppliers_clean;

select customer_id,
count(*)
from ecommerce.customers_clean
group by customer_id 
having count(*)>1

select order_id,
count(*)
from ecommerce.orders_clean
group by order_id 
having count(*)>1

select *
from ecommerce.orders_clean as o
left join ecommerce.customers_clean as c
on o.customer_id = c.customer_id
where c.customer_id IS NULL


select *
from ecommerce.order_items_clean as oi
left join ecommerce.orders_clean as o
on oi.order_id = o.order_id
where o.order_id IS NULL


select *
from ecommerce.products_clean as p
left join ecommerce.suppliers_clean as s
on p.supplier_id =  s.supplier_id
where s.supplier_id IS NULL;


select *
from ecommerce.products_clean as p
left join ecommerce.inventory_clean as i
on p.product_id =  i.product_id
where p.product_id IS NULL;

select *
from ecommerce.orders_clean as o
left join ecommerce.payments_clean as p
on p.order_id = o.order_id
where o.order_id IS NULL;

select *
from ecommerce.orders_clean as o
left join ecommerce.returns_clean as r
on r.order_id = o.order_id
where o.order_id IS NULL;

select *
from ecommerce.orders_clean
limit 5;

select *
from ecommerce.customers_clean
limit 5;

select *
from ecommerce.order_items_clean
limit 5;

select *
from ecommerce.products_clean
limit 5;

select *
from ecommerce.payments_clean
limit 5;

select *
from ecommerce.returns_clean
limit 5;

select *
from ecommerce.inventory_clean
limit 5;

select *
from ecommerce.suppliers_clean
limit 5;


select
count (*)
from ecommerce.customers_clean
where email is null


select 
count(*)
from ecommerce.orders_clean
where delivered_date is null;


select
o.order_id,
c.first_name,
o.final_amount
from ecommerce.orders_clean as o
join ecommerce.customers_clean as c
on c.customer_id = o.customer_id 
limit 10;


select count(*)
from ecommerce.orders_clean
where status = 'Cancelled';

select count(*)
from ecommerce.payments_clean
where status = 'Success';

select order_id,
final_amount
from ecommerce.orders_clean
order by final_amount desc
limit 10;