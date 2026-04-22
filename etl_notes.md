## ETL Decisions

### Decision 1 -< Date Format Standardization>
Problem: The raw data contained three different date formats (DD/MM/YYYY, DD-MM-YYYY, and YYYY-MM-DD) which would cause inconsistencies in date-based queries and prevent proper temporal analysis in the data warehouse.
Resolution: Implemented a date parsing function that attempts to parse each date string using all three format patterns sequentially. All dates were then standardized to the ISO format (YYYY-MM-DD) before loading into the dim_date dimension table. This ensures consistent date handling across all queries and enables proper date arithmetic operations. The dim_date table was designed with a date_key in YYYYMMDD integer format (e.g., 20230115) for efficient joins and includes derived attributes like day_of_week, month_name, quarter, and is_weekend flag for analytical flexibility.

###Decision 2 -< Category Name Normalization>
Problem: The category field had inconsistent casing with five variations: "electronics", "Electronics", "Grocery", "Groceries", and "Clothing". This inconsistency would result in duplicate category entries in reports and incorrect aggregations (e.g., "electronics" and "Electronics" being counted as separate categories).
Resolution: Created a standardized category mapping that consolidates all variations into three canonical categories: "Electronics", "Grocery", and "Clothing". Specifically, both "electronics" and "Electronics" were mapped to "Electronics", while "Groceries" and "Grocery" were consolidated to "Grocery". This mapping was applied during the ETL process before loading into the dim_product dimension table, ensuring all analytical queries return accurate category-level aggregations without duplication.

###Decision 3 -< Missing Store City Imputation>
Problem: The raw data contained 19 NULL values (6.3% of records) in the store_city field, which would create incomplete dimension records and potentially exclude transactions from location-based analysis. These NULL values appeared inconsistently across all five store locations.
Resolution: Implemented a lookup-based imputation strategy using the store_name as the key. Created a reference mapping (store_name → store_city) based on non-NULL records: Bangalore MG → Bangalore, Chennai Anna → Chennai, Delhi South → Delhi, Mumbai Central → Mumbai, and Pune FC Road → Pune. During ETL, any transaction with a NULL store_city was populated using this mapping based on its store_name value. This approach maintains referential integrity in the dim_store dimension and ensures all 300 transactions can be properly attributed to their geographic locations for regional performance analysis. The dim_store table was designed with store_city as a NOT NULL field to prevent future data quality issues.

