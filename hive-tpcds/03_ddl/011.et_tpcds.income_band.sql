CREATE EXTERNAL TABLE et_income_band (
    ib_income_band_sk int,
    ib_lower_bound int,
    ib_upper_bound int
)
row format delimited fields terminated by '|'
location '/user/hiveadmin/tpcds_parquet/income_band';
