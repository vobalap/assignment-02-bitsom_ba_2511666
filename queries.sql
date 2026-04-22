part1-rdbms/queries.sql: 

SQL QUERIES FOR NORMALIZED SCHEMA
File: part1-rdbms/queries.sql

Q1: List all customers from Mumbai along with their total order value

SELECT 
    c.customer_id,
    c.customer_name,
    c.customer_city,
    SUM(p.unit_price * o.quantity) AS total_order_value
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Products p ON o.product_id = p.product_id
WHERE c.customer_city = 'Mumbai'
GROUP BY c.customer_id, c.customer_name, c.customer_city
ORDER BY total_order_value DESC;

Q2: Find the top 3 products by total quantity sold

SELECT 
    p.product_id,
    p.product_name,
    p.category,
    SUM(o.quantity) AS total_quantity_sold
FROM Products p
JOIN Orders o ON p.product_id = o.product_id
GROUP BY p.product_id, p.product_name, p.category
ORDER BY total_quantity_sold DESC
LIMIT 3;

Q3: List all sales representatives and the number of unique customers they have handled

SELECT 
    s.sales_rep_id,
    s.sales_rep_name,
    COUNT(DISTINCT o.customer_id) AS unique_customers
FROM Sales_Representatives s
LEFT JOIN Orders o ON s.sales_rep_id = o.sales_rep_id
GROUP BY s.sales_rep_id, s.sales_rep_name
ORDER BY unique_customers DESC;

Q4: Find all orders where the total value exceeds 10,000, sorted by value descending

SELECT 
    o.order_id,
    c.customer_name,
    p.product_name,
    o.quantity,
    p.unit_price,
    (p.unit_price * o.quantity) AS total_value
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN Products p ON o.product_id = p.product_id
WHERE (p.unit_price * o.quantity) > 10000
ORDER BY total_value DESC;
-- Q5: Identify any products that have never been ordered
SELECT 
    p.product_id,
    p.product_name,
    p.category,
    p.unit_price
FROM Products p
LEFT JOIN Orders o ON p.product_id = o.product_id
WHERE o.order_id IS NULL;




