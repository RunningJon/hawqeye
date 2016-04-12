CREATE TABLE income_band LIKE et_income_band STORED AS PARQUET TBLPROPERTIES ("orc.compress"="SNAPPY");
