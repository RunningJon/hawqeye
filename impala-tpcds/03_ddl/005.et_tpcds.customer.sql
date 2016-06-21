CREATE EXTERNAL TABLE et_customer (
    c_customer_sk int ,
    c_customer_id varchar(16) ,
    c_current_cdemo_sk int,
    c_current_hdemo_sk int,
    c_current_addr_sk int,
    c_first_shipto_date_sk int,
    c_first_sales_date_sk int,
    c_salutation varchar(10),
    c_first_name varchar(20),
    c_last_name varchar(30),
    c_preferred_cust_flag char(1),
    c_birth_day int,
    c_birth_month int,
    c_birth_year int,
    c_birth_country varchar(20),
    c_login varchar(13),
    c_email_address varchar(50),
    c_last_review_date varchar(10)
)
row format delimited fields terminated by '|'
location '/user/impadmin/tpcds_parquet/customer'
tblproperties ('serialization.null.format'='')
;
