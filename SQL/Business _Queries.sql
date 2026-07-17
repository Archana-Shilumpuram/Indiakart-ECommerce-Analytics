KPI 1 - Gross Merchandise Value (GMV)
#What is the total value of all orders?
SELECT
    SUM(final_amount) AS gross_merchandise_value
FROM ecommerce.orders_clean;

KPI 2 - Net Revenue
Revenue from delivered orders only.
SELECT
    SUM(final_amount) AS net_revenue
FROM ecommerce.orders_clean
WHERE status = 'Delivered';

KPI 3- average order value
SELECT
    ROUND(AVG(final_amount),2) AS average_order_value
FROM ecommerce.orders_clean
WHERE status='Delivered';

KPI 4 - Total orders
SELECT
COUNT(*) AS total_orders
FROM ecommerce.orders_clean;

KPI 5- Delivered orders
SELECT
COUNT(*) AS delivered_orders
FROM ecommerce.orders_clean
WHERE status='Delivered';

KPI 6- Cancellation Rate
SELECT
ROUND(COUNT(*) FILTER(WHERE status='Cancelled')*100.0/COUNT(*),2)
AS cancellation_rate
FROM ecommerce.orders_clean;

KPI 7 - Return rate
SELECT
ROUND(COUNT(r.return_id)*100.0/COUNT(DISTINCT o.order_id),2)AS return_rate
FROM ecommerce.orders_clean o
LEFT JOIN ecommerce.returns_clean r
ON o.order_id=r.order_id
WHERE o.status='Delivered';

KPI 8 - Payment Failure Rate
SELECT
ROUND(COUNT(*) FILTER(WHERE status='Failed')*100.0/COUNT(*),2)AS payment_failure_rate
FROM ecommerce.payments_clean;

KPI 9 - Inventory Fill rate
SELECT
ROUND(COUNT(*) FILTER(WHERE status='In Stock')*100.0/COUNT(*),2)AS inventory_fill_rate
FROM ecommerce.inventory_clean;

KPI 10 - Top Revenue category


SELECT
p.category,
SUM(oi.total_price) revenue
FROM ecommerce.products_clean p
JOIN ecommerce.order_items_clean oi
ON p.product_id=oi.product_id
GROUP BY p.category
ORDER BY revenue DESC;

KPI 11 - Revenue share by category

SELECT
category,
SUM(revenue) AS revenue,
ROUND(SUM(revenue)*100.0/SUM(SUM(revenue)) OVER(),2)AS revenue_share
FROM(
SELECT
p.category,
oi.total_price revenue
FROM ecommerce.products_clean p
JOIN ecommerce.order_items_clean oi
ON p.product_id=oi.product_id)x
GROUP BY category
ORDER BY revenue DESC;

KPI 12- Top 10 Customers

SELECT
c.customer_id,
c.first_name,
SUM(o.final_amount)AS revenue
FROM ecommerce.customers_clean c
JOIN ecommerce.orders_clean o
ON c.customer_id=o.customer_id
WHERE o.status='Delivered'
GROUP BY
c.customer_id,
c.first_name
ORDER BY revenue DESC
LIMIT 10;

KPI 13 - Revenue by state

SELECT
state,
SUM(final_amount)AS revenue
FROM ecommerce.orders_clean
WHERE status='Delivered'
GROUP BY state
ORDER BY revenue DESC;

KPI 14 - Top 10 Products

SELECT
p.product_name,
SUM(oi.total_price)AS revenue
FROM ecommerce.products_clean p
JOIN ecommerce.order_items_clean oi
ON p.product_id=oi.product_id
GROUP BY p.product_name
ORDER BY revenue DESC;

LIMIT 10;

KPI 15 - Monthly revenue trend

SELECT
DATE_TRUNC('month',order_date)
AS month,
SUM(final_amount)
AS revenue
FROM ecommerce.orders_clean
WHERE status='Delivered'
GROUP BY month
ORDER BY month;


KPI 16	- Month over Month Growth

WITH monthly_revenue AS (
SELECT
DATE_TRUNC('month',order_date) AS month,
SUM(final_amount) AS revenue
FROM ecommerce.orders_clean
WHERE status='Delivered'
GROUP BY month
)
SELECT
month,
revenue,
LAG(revenue) OVER(ORDER BY month) AS previous_month,
ROUND(((revenue-LAG(revenue)OVER(ORDER BY month))/LAG(revenue)OVER(ORDER BY month))*100,2)
AS growth_percent
FROM monthly_revenue;

KPI 17 - Customer Lifetime Value

SELECT
segment,
ROUND(AVG(total_spent),2)
AS avg_customer_lifetime_value
FROM ecommerce.customers_clean
GROUP BY segment
ORDER BY avg_customer_lifetime_value DESC;

KPI 18 - 	Top Performing Supplier

SELECT
s.supplier_name,
SUM(oi.total_price)
AS revenue
FROM ecommerce.suppliers_clean s
JOIN ecommerce.products_clean p
ON s.supplier_id=p.supplier_id
JOIN ecommerce.order_items_clean oi
ON p.product_id=oi.product_id
GROUP BY s.supplier_name
ORDER BY revenue DESC;

KPI 19 - Best Selling Products

SELECT
p.product_name,
SUM(oi.quantity)
AS units_sold
FROM ecommerce.products_clean p
JOIN ecommerce.order_items_clean oi
ON p.product_id=oi.product_id
GROUP BY p.product_name
ORDER BY units_sold DESC
LIMIT 10;

KPI 20 - Dashboard summary Query

SELECT
COUNT(*) AS total_orders,
SUM(final_amount) AS total_revenue,
ROUND(AVG(final_amount),2) AS avg_order_value,
MIN(final_amount) AS min_order,
MAX(final_amount) AS max_order
FROM ecommerce.orders_clean
WHERE status='Delivered';



Mini Business Case Study

After running these queries, write a short summary:

Example:

Total GMV for the analysis period was ₹3147385544.58.
Net Revenue from delivered orders was ₹2053858611.96.
The cancellation rate was 11.99%, which is above/below the target.
Electronics contributed the highest revenue.
Maharashtra generated the highest sales.
Premium customers had the highest lifetime value.
UPI was the most frequently used payment method.
Inventory fill rate was above 95%, indicating healthy stock availability.