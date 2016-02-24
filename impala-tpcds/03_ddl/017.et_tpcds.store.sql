CREATE EXTERNAL TABLE et_store (
    s_store_sk int ,
    s_store_id char(16) ,
    s_rec_start_date timestamp,
    s_rec_end_date timestamp,
    s_closed_date_sk int,
    s_store_name varchar(50),
    s_number_employees int,
    s_floor_space int,
    s_hours char(20),
    s_manager varchar(40),
    s_market_id int,
    s_geography_class varchar(100),
    s_market_desc varchar(100),
    s_market_manager varchar(40),
    s_division_id int,
    s_division_name varchar(50),
    s_company_id int,
    s_company_name varchar(50),
    s_street_number varchar(10),
    s_street_name varchar(60),
    s_street_type char(15),
    s_suite_number char(10),
    s_city varchar(60),
    s_county varchar(30),
    s_state char(2),
    s_zip char(10),
    s_country varchar(20),
    s_gmt_offset decimal(5,2),
    s_tax_precentage decimal(5,2)
)
row format delimited fields terminated by '|'
location '/user/impadmin/tpcds_parquet/store'
tblproperties ('serialization.null.format'='')
;
