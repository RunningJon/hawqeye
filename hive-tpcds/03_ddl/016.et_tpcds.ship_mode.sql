CREATE EXTERNAL TABLE et_ship_mode (
    sm_ship_mode_sk int,
    sm_ship_mode_id string,
    sm_type string,
    sm_code string,
    sm_carrier string,
    sm_contract string
)
row format delimited fields terminated by '|'
location '/user/hiveadmin/tpcds_parquet/ship_mode';
