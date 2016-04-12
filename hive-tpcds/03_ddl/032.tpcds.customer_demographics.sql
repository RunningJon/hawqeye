CREATE TABLE customer_demographics LIKE et_customer_demographics STORED AS PARQUET TBLPROPERTIES ("orc.compress"="SNAPPY");
