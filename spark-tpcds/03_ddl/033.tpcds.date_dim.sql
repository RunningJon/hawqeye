CREATE TABLE date_dim LIKE et_date_dim STORED AS ORC TBLPROPERTIES ("orc.compress"="ZLIB");
