Q1: List all customers along with the total number of orders they have placed
SELECT 
    c.customer_id,
    c.name,
    COUNT(o.order_id) AS total_orders
FROM read_csv_auto('customers.csv') c
LEFT JOIN read_json_auto('orders.json') o 
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
ORDER BY total_orders DESC;

Q2: Find the top 3 customers by total order value
SELECT 
    c.customer_id,
    c.name,
    SUM(o.total_amount) AS total_order_value
FROM read_csv_auto('customers.csv') c
INNER JOIN read_json_auto('orders.json') o 
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
ORDER BY total_order_value DESC
LIMIT 3;

Q3: List all products purchased by customers from Bangalore
SELECT DISTINCT
    p.product_id,
    p.product_name,
    p.category
FROM read_csv_auto('customers.csv') c
INNER JOIN read_json_auto('orders.json') o 
    ON c.customer_id = o.customer_id
INNER JOIN read_csv_auto('products (1).csv') p 
    ON o.order_id = p.order_id
WHERE c.city = 'Bangalore'
ORDER BY p.product_name;

-- Q4: Join all three files to show: customer name, order date, product name, and quantity
SELECT 
    c.name AS customer_name,
    o.order_date,
    p.product_name,
    p.quantity
FROM read_csv_auto('customers.csv') c
INNER JOIN read_json_auto('orders.json') o 
    ON c.customer_id = o.customer_id
INNER JOIN read_csv_auto('products (1).csv') p 
    ON o.order_id = p.order_id
ORDER BY o.order_date, c.name, p.product_name;

