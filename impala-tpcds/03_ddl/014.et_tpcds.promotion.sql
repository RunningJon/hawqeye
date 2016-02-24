CREATE EXTERNAL TABLE et_promotion (
    p_promo_sk int ,
    p_promo_id char(16) ,
    p_start_date_sk int,
    p_end_date_sk int,
    p_item_sk int,
    p_cost decimal(15,2),
    p_response_target int,
    p_promo_name char(50),
    p_channel_dmail char(1),
    p_channel_email char(1),
    p_channel_catalog char(1),
    p_channel_tv char(1),
    p_channel_radio char(1),
    p_channel_press char(1),
    p_channel_event char(1),
    p_channel_demo char(1),
    p_channel_details varchar(100),
    p_purpose char(15),
    p_discount_active char(1)
)
row format delimited fields terminated by '|'
location '/user/impadmin/tpcds_parquet/promotion'
tblproperties ('serialization.null.format'='')
;
