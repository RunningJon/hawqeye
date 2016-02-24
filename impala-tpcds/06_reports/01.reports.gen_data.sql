CREATE EXTERNAL TABLE reports.gen_data
(id int, description string, tuples bigint, duration timestamp)
row format delimited fields terminated by '|'
location '/user/impadmin/reports/gen_data'
tblproperties ('serialization.null.format'='')
;
