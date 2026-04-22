
ANALYTICAL QUERIES FOR RETAIL DATA WAREHOUSE

Q1: Total sales revenue by product category for each month

SELECT
    YEAR(d.full_date) AS year,
    MONTH(d.full_date) AS month,
    MONTHNAME(d.full_date) AS month_name,
    p.category,
    SUM(f.total_amount) AS total_revenue,
    COUNT(f.sales_key) AS transaction_count,
    SUM(f.units_sold) AS total_units_sold
FROM fact_sales f
JOIN dim_product p ON f.product_key = p.product_key
JOIN dim_date d ON f.date_key = d.date_key
GROUP BY YEAR(d.full_date), MONTH(d.full_date), MONTHNAME(d.full_date), p.category
ORDER BY year, month, total_revenue DESC;

/*
Expected Results (based on cleaned data from 300 transactions):
- 36 rows (12 months × 3 categories)
- Electronics dominates in Q1 (January: ₹8.02M, February: ₹6.12M)
- Grocery shows strong performance in Q4 (November: ₹8.15M)
- Clothing remains relatively stable throughout the year
*/

Q2: Top 2 performing stores by total revenue

SELECT
    s.store_name,
    s.store_city,
    SUM(f.total_amount) AS total_revenue,
    COUNT(f.sales_key) AS transaction_count,
    SUM(f.units_sold) AS total_units_sold,
    ROUND(AVG(f.total_amount), 2) AS avg_transaction_value
FROM fact_sales f
JOIN dim_store s ON f.store_key = s.store_key
GROUP BY s.store_name, s.store_city
ORDER BY total_revenue DESC
LIMIT 2;

/*
Expected Results (based on cleaned data):
1. Pune FC Road (Pune): ₹28.14M revenue, 71 transactions, 758 units
2. Chennai Anna (Chennai): ₹27.89M revenue, 69 transactions, 709 units

Key Insights:
- Top 2 stores account for ~47% of total revenue
- Similar transaction counts but Pune has higher average order value
*/


Q3: Month-over-month sales trend across all stores

SELECT
    YEAR(d.full_date) AS year,
    MONTH(d.full_date) AS month,
    MONTHNAME(d.full_date) AS month_name,
    SUM(f.total_amount) AS total_revenue,
    LAG(SUM(f.total_amount)) OVER (ORDER BY YEAR(d.full_date), MONTH(d.full_date)) AS previous_month_revenue,
    SUM(f.total_amount) - LAG(SUM(f.total_amount)) OVER (ORDER BY YEAR(d.full_date), MONTH(d.full_date)) AS mom_change,
    ROUND(
        ((SUM(f.total_amount) - LAG(SUM(f.total_amount)) OVER (ORDER BY YEAR(d.full_date), MONTH(d.full_date))) / 
         LAG(SUM(f.total_amount)) OVER (ORDER BY YEAR(d.full_date), MONTH(d.full_date))) * 100, 
        2
    ) AS mom_change_pct
FROM fact_sales f
JOIN dim_date d ON f.date_key = d.date_key
GROUP BY YEAR(d.full_date), MONTH(d.full_date), MONTHNAME(d.full_date)
ORDER BY year, month;

