CREATE EXTERNAL TABLE et_customer_address (
    ca_address_sk int ,
    ca_address_id char(16) ,
    ca_street_number char(10),
    ca_street_name varchar(60),
    ca_street_type char(15),
    ca_suite_number char(10),
    ca_city varchar(60),
    ca_county varchar(30),
    ca_state char(2),
    ca_zip char(10),
    ca_country varchar(20),
    ca_gmt_offset decimal(5,2),
    ca_location_type char(20)
)
row format delimited fields terminated by '|'
location '/user/impadmin/tpcds_parquet/customer_address'
tblproperties ('serialization.null.format'='')
;
