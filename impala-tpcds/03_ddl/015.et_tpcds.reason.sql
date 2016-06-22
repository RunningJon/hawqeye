CREATE EXTERNAL TABLE et_reason (
    r_reason_sk int ,
    r_reason_id varchar(16) ,
    r_reason_desc varchar(100)
)
row format delimited fields terminated by '|'
location '/user/impadmin/tpcds_parquet/reason'
tblproperties ('serialization.null.format'='')
;
