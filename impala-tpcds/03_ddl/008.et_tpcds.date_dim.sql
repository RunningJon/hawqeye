CREATE EXTERNAL TABLE et_date_dim (
    d_date_sk int ,
    d_date_id varchar(16) ,
    d_date timestamp,
    d_month_seq int,
    d_week_seq int,
    d_quarter_seq int,
    d_year int,
    d_dow int,
    d_moy int,
    d_dom int,
    d_qoy int,
    d_fy_year int,
    d_fy_quarter_seq int,
    d_fy_week_seq int,
    d_day_name varchar(9),
    d_quarter_name varchar(6),
    d_holiday char(1),
    d_weekend char(1),
    d_following_holiday char(1),
    d_first_dom int,
    d_last_dom int,
    d_same_day_ly int,
    d_same_day_lq int,
    d_current_day char(1),
    d_current_week char(1),
    d_current_month char(1),
    d_current_quarter char(1),
    d_current_year char(1)
)
row format delimited fields terminated by '|'
location '/user/impadmin/tpcds_parquet/date_dim'
tblproperties ('serialization.null.format'='')
;
