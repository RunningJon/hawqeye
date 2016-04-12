CREATE TABLE warehouse LIKE et_warehouse STORED AS PARQUET TBLPROPERTIES ("orc.compress"="SNAPPY");
