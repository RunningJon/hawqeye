CREATE EXTERNAL TABLE et_ship_mode (
    sm_ship_mode_sk int ,
    sm_ship_mode_id char(16) ,
    sm_type char(30),
    sm_code char(10),
    sm_carrier char(20),
    sm_contract char(20)
)
row format delimited fields terminated by '|'
location '/user/impadmin/tpcds_parquet/ship_mode'
tblproperties ('serialization.null.format'='')
;
