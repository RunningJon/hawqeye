CREATE EXTERNAL TABLE et_time_dim (
    t_time_sk int ,
    t_time_id char(16) ,
    t_time int,
    t_hour int,
    t_minute int,
    t_second int,
    t_am_pm char(2),
    t_shift char(20),
    t_sub_shift char(20),
    t_meal_time char(20)
)
row format delimited fields terminated by '|'
location '/user/impadmin/tpcds_parquet/time_dim'
tblproperties ('serialization.null.format'='')
;
