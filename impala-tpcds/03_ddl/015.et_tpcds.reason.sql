CREATE EXTERNAL TABLE et_reason (
    r_reason_sk int ,
    r_reason_id char(16) ,
    r_reason_desc char(100)
)
row format delimited fields terminated by '|'
location '/user/impadmin/tpcds_parquet/customer_address'
tblproperties ('serialization.null.format'='')
;
