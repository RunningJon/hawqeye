CREATE EXTERNAL TABLE et_reason (
    r_reason_sk int,
    r_reason_id string,
    r_reason_desc string
)
row format delimited fields terminated by '|'
location '/user/spark/tpcds_spark/reason';
