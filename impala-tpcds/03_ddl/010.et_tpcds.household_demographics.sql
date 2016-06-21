CREATE EXTERNAL TABLE et_household_demographics (
    hd_demo_sk int ,
    hd_income_band_sk int,
    hd_buy_potential varchar(15),
    hd_dep_count int,
    hd_vehicle_count int
)
row format delimited fields terminated by '|'
location '/user/impadmin/tpcds_parquet/household_demographics'
tblproperties ('serialization.null.format'='')
;
