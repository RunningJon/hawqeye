CREATE EXTERNAL TABLE et_household_demographics (
    hd_demo_sk int,
    hd_income_band_sk int,
    hd_buy_potential string,
    hd_dep_count int,
    hd_vehicle_count int
)
row format delimited fields terminated by '|'
location '/user/hiveadmin/tpcds_parquet/household_demographics';
