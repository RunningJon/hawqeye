CREATE EXTERNAL TABLE et_web_page (
    wp_web_page_sk int ,
    wp_web_page_id varchar(16) ,
    wp_rec_start_date timestamp,
    wp_rec_end_date timestamp,
    wp_creation_date_sk int,
    wp_access_date_sk int,
    wp_autogen_flag char(1),
    wp_customer_sk int,
    wp_url varchar(100),
    wp_type varchar(50),
    wp_char_count int,
    wp_link_count int,
    wp_image_count int,
    wp_max_ad_count int
)
row format delimited fields terminated by '|'
location '/user/impadmin/tpcds_parquet/web_page'
tblproperties ('serialization.null.format'='')
;
