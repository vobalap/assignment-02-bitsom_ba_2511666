part1-rdbms/schema_design.sql:
------------------------------------------------------------------------------
TABLE 1: CUSTOMERS
------------------------------------------------------------------------------
CREATE TABLE Customers (
    customer_id VARCHAR(10) PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    customer_email VARCHAR(100) NOT NULL,
    customer_city VARCHAR(50) NOT NULL
);
INSERT INTO Customers (customer_id, customer_name, customer_email, customer_city) VALUES
('C001', 'Rohan Mehta', 'rohan@gmail.com', 'Mumbai'),
('C002', 'Priya Sharma', 'priya@gmail.com', 'Delhi'),
('C003', 'Amit Verma', 'amit@gmail.com', 'Bangalore'),
('C004', 'Sneha Iyer', 'sneha@gmail.com', 'Chennai'),
('C005', 'Vikram Singh', 'vikram@gmail.com', 'Mumbai'),
('C006', 'Neha Gupta', 'neha@gmail.com', 'Delhi'),
('C007', 'Arjun Nair', 'arjun@gmail.com', 'Bangalore'),
('C008', 'Kavya Rao', 'kavya@gmail.com', 'Hyderabad');
------------------------------------------------------------------------------
TABLE 2: PRODUCTS
------------------------------------------------------------------------------
CREATE TABLE Products (
    product_id VARCHAR(10) PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL
);
INSERT INTO Products (product_id, product_name, category, unit_price) VALUES
('P001', 'Laptop', 'Electronics', 55000.00),
('P002', 'Mouse', 'Electronics', 800.00),
('P003', 'Desk Chair', 'Furniture', 8500.00),
('P004', 'Notebook', 'Stationery', 120.00),
('P005', 'Headphones', 'Electronics', 3200.00),
('P006', 'Standing Desk', 'Furniture', 22000.00),
('P007', 'Pen Set', 'Stationery', 250.00),
('P008', 'Webcam', 'Electronics', 2100.00);
------------------------------------------------------------------------------
TABLE 3: SALES_REPRESENTATIVES
------------------------------------------------------------------------------
CREATE TABLE Sales_Representatives (
    sales_rep_id VARCHAR(10) PRIMARY KEY,
    sales_rep_name VARCHAR(100) NOT NULL,
    sales_rep_email VARCHAR(100) NOT NULL,
    office_address VARCHAR(200) NOT NULL
);
INSERT INTO Sales_Representatives (sales_rep_id, sales_rep_name, sales_rep_email, office_address) VALUES
('SR01', 'Deepak Joshi', 'deepak@corp.com', 'Mumbai HQ, Nariman Point, Mumbai - 400021'),
('SR02', 'Anita Desai', 'anita@corp.com', 'Delhi Office, Connaught Place, New Delhi - 110001'),
('SR03', 'Ravi Kumar', 'ravi@corp.com', 'South Zone, MG Road, Bangalore - 560001'),
('SR04', 'Meera Patel', 'meera@corp.com', 'West Zone, CG Road, Ahmedabad - 380009'),
('SR05', 'Karthik Reddy', 'karthik@corp.com', 'South Zone, Banjara Hills, Hyderabad - 500034');

------------------------------------------------------------------------------
TABLE 4: ORDERS
------------------------------------------------------------------------------
CREATE TABLE Orders (
    order_id VARCHAR(10) PRIMARY KEY,
    customer_id VARCHAR(10) NOT NULL,
    product_id VARCHAR(10) NOT NULL,
    sales_rep_id VARCHAR(10) NOT NULL,
    quantity INT NOT NULL,
    order_date DATE NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id),
    FOREIGN KEY (sales_rep_id) REFERENCES Sales_Representatives(sales_rep_id)
);

INSERT INTO Orders (order_id, customer_id, product_id, sales_rep_id, quantity, order_date) VALUES
('ORD1027', 'C002', 'P004', 'SR02', 4, '2023-11-02'),
('ORD1114', 'C001', 'P007', 'SR01', 2, '2023-08-06'),
('ORD1153', 'C006', 'P007', 'SR01', 3, '2023-02-14'),
('ORD1002', 'C002', 'P005', 'SR02', 1, '2023-01-17'),
('ORD1118', 'C006', 'P007', 'SR02', 5, '2023-11-10'),
('ORD1185', 'C003', 'P008', 'SR03', 1, '2023-06-15'),
('ORD1091', 'C001', 'P006', 'SR01', 3, '2023-07-24'),
('ORD1131', 'C008', 'P001', 'SR02', 4, '2023-06-22');

Schema Design Explanation: 
I've created a normalized 3NF database schema with four tables that eliminate all the anomalies identified in section 1.1:
Tables Created:
1.	Customers - Stores customer information (8 rows)
o	Primary Key: customer_id
o	Eliminates Insert Anomaly: Customers can exist without orders
2.	Products - Stores product catalog (8 rows including P008 Webcam)
o	Primary Key: product_id
o	Eliminates Delete Anomaly: Products persist even if orders are deleted
3.	Sales_Representatives - Stores sales rep information (5 rows)
o	Primary Key: sales_rep_id
o	Eliminates Update Anomaly: Rep info updated once, affects all orders
4.	Orders - Stores only order transactions (8 rows)
o	Primary Key: order_id
o	Foreign Keys: customer_id, product_id, sales_rep_id
o	Contains only order-specific data (quantity, date)
Query to reconstruct the original flat file view: 

SELECT 
    o.order_id,
    c.customer_id,
    c.customer_name,
    c.customer_email,
    c.customer_city,
    p.product_id,
    p.product_name,
    p.category,
    p.unit_price,
    o.quantity,
    o.order_date,
    s.sales_rep_id,
    s.sales_rep_name,
    s.sales_rep_email,
    s.office_address
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN Products p ON o.product_id = p.product_id
JOIN Sales_Representatives s ON o.sales_rep_id = s.sales_rep_id
ORDER BY o.order_id;


ANOMALY ELIMINATION VERIFICATION

1. INSERT ANOMALY ELIMINATED:
Can now add new customers without orders:
INSERT INTO Customers (customer_id, customer_name, customer_email, customer_city) 
VALUES ('C009', 'Rajesh Kumar', 'rajesh@gmail.com', 'Pune');
2. UPDATE ANOMALY ELIMINATED:
Update customer email in ONE place (affects all their orders):
UPDATE Customers SET customer_email = 'priya.sharma@gmail.com' WHERE customer_id = 'C002';
3. DELETE ANOMALY ELIMINATED:
Delete order ORD1185 without losing Product P008 information:
DELETE FROM Orders WHERE order_id = 'ORD1185';
Product P008 (Webcam) still exists in Products table!
SELECT * FROM Products WHERE product_id = 'P008';
