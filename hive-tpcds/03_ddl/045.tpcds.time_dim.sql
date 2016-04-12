CREATE TABLE time_dim LIKE et_time_dim STORED AS PARQUET TBLPROPERTIES ("orc.compress"="SNAPPY");
