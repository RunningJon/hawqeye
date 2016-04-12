CREATE TABLE date_dim LIKE et_date_dim STORED AS PARQUET TBLPROPERTIES ("orc.compress"="SNAPPY");
