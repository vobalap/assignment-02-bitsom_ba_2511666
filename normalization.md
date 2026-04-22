## Anomaly Analysis

1. Insert Anomaly
Definition: An Insert Anomaly occurs when you cannot add data to the database without adding unrelated data, or when the same information must be redundantly inserted multiple times.
Specific Evidence from the CSV:
•	Customer C002 (Priya Sharma) appears in 21 different orders
•	In every single row, the same customer information is duplicated:
o	customer_name: "Priya Sharma"
o	customer_email: "priya@gmail.com"
o	customer_city: "Delhi"
Example Rows (ORD1027, ORD1002, ORD1037, ORD1054, ORD1048, ORD1094, ORD1035, ORD1147, ORD1045, ORD1165): Every time Priya Sharma places a new order, her complete customer profile (name, email, city) must be re-entered. This creates 21 redundant copies of the same customer information.
Problem: If you want to add a new customer to the system who hasn't placed an order yet, you cannot do so because customer data only exists within order records. Additionally, every new order requires re-entering all customer details, leading to data redundancy and potential inconsistencies.
________________________________________
2. Update Anomaly
Definition: An Update Anomaly occurs when updating a single piece of information requires multiple row updates, and failure to update all instances creates data inconsistencies.
Specific Evidence from the CSV:
•	Sales Rep SR01 (Deepak Joshi) appears in 83 different order rows
•	His information is duplicated across all these rows:
o	sales_rep_name: "Deepak Joshi"
o	sales_rep_email: "deepak@corp.com"
o	office_address: "Mumbai HQ, Nariman Point, Mumbai - 400021"
Critical Inconsistency Found: The analysis revealed that SR01's office address appears in two different formats:
•	"Mumbai HQ, Nariman Point, Mumbai - 400021" (most rows)
•	"Mumbai HQ, Nariman Pt, Mumbai - 400021" (some rows, e.g., ORD1180, ORD1170, ORD1173)
Example Rows (ORD1114, ORD1153, ORD1083, ORD1091, ORD1061, ORD1022, ORD1166, ORD1025, ORD1092, ORD1043): All contain identical sales rep information for SR01.
Problem: If Deepak Joshi changes his email address or office location, you would need to update 83 separate rows. The existing inconsistency in the address format ("Point" vs "Pt") demonstrates this problem—someone updated some rows but not others, creating data integrity issues. If the sales rep gets promoted or transferred, all 83 rows must be modified, and missing even one creates inconsistent data.
________________________________________
3. Delete Anomaly
Definition: A Delete Anomaly occurs when deleting a record causes unintended loss of other valuable information that should be preserved.
Specific Evidence from the CSV:
•	Product P008 (Webcam) appears in only ONE order: ORD1185
•	This single row contains:
o	order_id: ORD1185
o	product_id: P008
o	product_name: "Webcam"
o	category: "Electronics"
o	unit_price: 2100
o	customer_name: "Amit Verma"
Problem: If order ORD1185 is deleted (perhaps the customer cancels the order, or it's removed for any business reason), ALL information about Product P008 (Webcam) would be permanently lost from the database. You would lose:
•	The fact that the company sells webcams
•	The product code (P008)
•	The category classification (Electronics)
•	The unit price (₹2,100)
This is critical because product information should exist independently of whether orders have been placed. The company needs to maintain product catalogs even for items that haven't been ordered recently or have had orders cancelled.


## Normalization Justification:
Normalization Justification
While keeping everything in one table may appear simpler initially, the evidence from orders_flat-8.csv demonstrates that this approach creates significant operational risks and inefficiencies that far outweigh any perceived simplicity.
Data Redundancy and Storage Costs: Customer C002 (Priya Sharma) appears in 21 separate orders, with her name, email, and city duplicated identically across all rows. Similarly, Sales Rep SR01 (Deepak Joshi) has his complete profile replicated across 83 order records. This redundancy multiplies storage requirements and increases database size unnecessarily. In a normalized structure, each customer and sales representative would be stored once, dramatically reducing storage costs and improving query performance.
Data Integrity Risks: The flat file already exhibits data inconsistencies that prove the fragility of this approach. SR01's office address appears in two different formats: "Mumbai HQ, Nariman Point, Mumbai - 400021" and "Mumbai HQ, Nariman Pt, Mumbai - 400021." This inconsistency occurred because someone updated some rows but not all 83 instances. In a normalized database, updating SR01's address would require changing just one row in the Sales_Representatives table, eliminating the possibility of such inconsistencies.
Operational Limitations: The flat structure prevents basic business operations. You cannot add a new customer to the system until they place an order, cannot maintain a product catalog for items not yet ordered, and risk losing all product information (like Product P008 Webcam) if its single order is deleted. These are not theoretical concerns; they represent real business constraints that limit operational flexibility.
Maintenance Burden: When Deepak Joshi changes his email address, IT staff must update 83 separate rows, risking errors and inconsistencies. When a customer moves to cities, every historical order must be updated. This maintenance burden grows exponentially with database size, turning simple updates into error-prone, time-consuming operations that require careful coordination and validation.
The "simplicity" of one table is an illusion that creates complexity elsewhere—in application code that must handle redundancy, in manual processes to maintain consistency, and in business limitations that constrain growth. Normalization isn't over-engineering; it's fundamental database design that prevents these documented problems from occurring.
 
