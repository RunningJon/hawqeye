CREATE EXTERNAL TABLE et_catalog_page (
    cp_catalog_page_sk int ,
    cp_catalog_page_id char(16) ,
    cp_start_date_sk int,
    cp_end_date_sk int,
    cp_department varchar(50),
    cp_catalog_number int,
    cp_catalog_page_number int,
    cp_description varchar(100),
    cp_type varchar(100)
)
row format delimited fields terminated by '|'
location '/user/impadmin/tpcds_parquet/catalog_page'
tblproperties ('serialization.null.format'='')
;
