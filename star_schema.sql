 STAR SCHEMA FOR RETAIL DATA WAREHOUSE
 
DIMENSION TABLES

Dimension: Date

CREATE TABLE dim_date (
    date_key INT PRIMARY KEY,
    full_date DATE NOT NULL,
    day_of_week VARCHAR(10),
    day_of_month INT,
    month INT,
    month_name VARCHAR(10),
    quarter INT,
    year INT,
    is_weekend BOOLEAN
);

Dimension: Store
CREATE TABLE dim_store (
    store_key INT PRIMARY KEY,
    store_name VARCHAR(50) NOT NULL,
    store_city VARCHAR(50) NOT NULL
);

Dimension: Product
CREATE TABLE dim_product (
    product_key INT PRIMARY KEY,
    product_name VARCHAR(50) NOT NULL,
    category VARCHAR(50) NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL
);

FACT TABLE :
CREATE TABLE fact_sales (
    sales_key INT PRIMARY KEY AUTO_INCREMENT,
    transaction_id VARCHAR(20) NOT NULL,
    date_key INT NOT NULL,
    store_key INT NOT NULL,
    product_key INT NOT NULL,
    customer_id VARCHAR(20) NOT NULL,
    units_sold INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    total_amount DECIMAL(12, 2) NOT NULL,
    FOREIGN KEY (date_key) REFERENCES dim_date(date_key),
    FOREIGN KEY (store_key) REFERENCES dim_store(store_key),
    FOREIGN KEY (product_key) REFERENCES dim_product(product_key)
);
 
DATA LOADING - CLEANED AND STANDARDIZED
Load Date Dimension (sample dates from 2023)
INSERT INTO dim_date (date_key, full_date, day_of_week, day_of_month, month, month_name, quarter, year, is_weekend) VALUES
(20230102, '2023-01-02', 'Monday', 2, 1, 'January', 1, 2023, FALSE),
(20230115, '2023-01-15', 'Sunday', 15, 1, 'January', 1, 2023, TRUE),
(20230205, '2023-02-05', 'Sunday', 5, 2, 'February', 1, 2023, TRUE),
(20230220, '2023-02-20', 'Monday', 20, 2, 'February', 1, 2023, FALSE),
(20230331, '2023-03-31', 'Friday', 31, 3, 'March', 1, 2023, FALSE),
(20230521, '2023-05-21', 'Sunday', 21, 5, 'May', 2, 2023, TRUE),
(20230604, '2023-06-04', 'Sunday', 4, 6, 'June', 2, 2023, TRUE),
(20230809, '2023-08-09', 'Wednesday', 9, 8, 'August', 3, 2023, FALSE),
(20230829, '2023-08-29', 'Tuesday', 29, 8, 'August', 3, 2023, FALSE),
(20231026, '2023-10-26', 'Thursday', 26, 10, 'October', 4, 2023, FALSE),
(20231118, '2023-11-18', 'Saturday', 18, 11, 'November', 4, 2023, TRUE),
(20231208, '2023-12-08', 'Friday', 8, 12, 'December', 4, 2023, FALSE),
(20231212, '2023-12-12', 'Tuesday', 12, 12, 'December', 4, 2023, FALSE);

Load Store Dimension (cleaned - NULL cities filled with proper values)
INSERT INTO dim_store (store_key, store_name, store_city) VALUES
(1, 'Bangalore MG', 'Bangalore'),
(2, 'Chennai Anna', 'Chennai'),
(3, 'Delhi South', 'Delhi'),
(4, 'Mumbai Central', 'Mumbai'),
(5, 'Pune FC Road', 'Pune');

Load Product Dimension (cleaned - standardized category names)
INSERT INTO dim_product (product_key, product_name, category, unit_price) VALUES
(1, 'Atta 10kg', 'Grocery', 52464.00),
(2, 'Biscuits', 'Grocery', 27469.99),
(3, 'Headphones', 'Electronics', 39854.96),
(4, 'Jacket', 'Clothing', 30187.24),
(5, 'Jeans', 'Clothing', 2317.47),
(6, 'Laptop', 'Electronics', 42343.15),
(7, 'Milk 1L', 'Grocery', 43374.39),
(8, 'Oil 1L', 'Grocery', 26474.34),
(9, 'Phone', 'Electronics', 48703.39),
(10, 'Pulses 1kg', 'Grocery', 31604.47),
(11, 'Rice 5kg', 'Grocery', 52195.05),
(12, 'Saree', 'Clothing', 35451.81),
(13, 'Smartwatch', 'Electronics', 58851.01),
(14, 'Speaker', 'Electronics', 49262.78),
(15, 'T-Shirt', 'Clothing', 29770.19),
(16, 'Tablet', 'Electronics', 23226.12);

 Load Fact Table (cleaned sample data - 15 transactions)
INSERT INTO fact_sales (transaction_id, date_key, store_key, product_key, customer_id, units_sold, unit_price, total_amount) VALUES
('TXN5000', 20230829, 2, 14, 'CUST045', 3, 49262.78, 147788.34),
('TXN5001', 20231212, 2, 16, 'CUST021', 11, 23226.12, 255487.32),
('TXN5002', 20230205, 2, 9, 'CUST019', 20, 48703.39, 974067.80),
('TXN5003', 20230220, 3, 16, 'CUST007', 14, 23226.12, 325165.68),
('TXN5004', 20230115, 2, 13, 'CUST004', 10, 58851.01, 588510.10),
('TXN5005', 20230809, 1, 1, 'CUST027', 12, 52464.00, 629568.00),
('TXN5006', 20230331, 5, 13, 'CUST025', 6, 58851.01, 353106.06),
('TXN5007', 20231026, 5, 5, 'CUST041', 16, 2317.47, 37079.52),
('TXN5008', 20231208, 1, 2, 'CUST030', 9, 27469.99, 247229.91),
('TXN5012', 20230521, 1, 6, 'CUST044', 13, 42343.15, 550460.95),
('TXN5014', 20231118, 3, 4, 'CUST042', 5, 30187.24, 150936.20),
('TXN5018', 20230205, 1, 3, 'CUST015', 15, 39854.96, 597824.40),
('TXN5028', 20230521, 1, 9, 'CUST030', 13, 48703.39, 633144.07),
('TXN5036', 20230604, 5, 9, 'CUST002', 17, 48703.39, 827957.63),
('TXN5046', 20231026, 2, 9, 'CUST037', 10, 48703.39, 487033.90);

INDEXES FOR PERFORMANCE
CREATE INDEX idx_fact_date ON fact_sales(date_key);
CREATE INDEX idx_fact_store ON fact_sales(store_key);
CREATE INDEX idx_fact_product ON fact_sales(product_key);
CREATE INDEX idx_fact_customer ON fact_sales(customer_id);
CREATE INDEX idx_fact_transaction ON fact_sales(transaction_id);
