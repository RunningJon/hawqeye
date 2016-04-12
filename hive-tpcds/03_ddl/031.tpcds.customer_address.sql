CREATE TABLE customer_address LIKE et_customer_address STORED AS PARQUET TBLPROPERTIES ("orc.compress"="SNAPPY");
