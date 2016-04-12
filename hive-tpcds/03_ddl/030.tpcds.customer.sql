CREATE TABLE customer LIKE et_customer STORED AS PARQUET TBLPROPERTIES ("orc.compress"="SNAPPY");
