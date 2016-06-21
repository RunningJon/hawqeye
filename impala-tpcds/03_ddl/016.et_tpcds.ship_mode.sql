CREATE EXTERNAL TABLE et_ship_mode (
    sm_ship_mode_sk int ,
    sm_ship_mode_id varchar(16) ,
    sm_type varchar(30),
    sm_code varchar(10),
    sm_carrier varchar(20),
    sm_contract varchar(20)
)
row format delimited fields terminated by '|'
location '/user/impadmin/tpcds_parquet/ship_mode'
tblproperties ('serialization.null.format'='')
;
