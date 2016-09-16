CREATE EXTERNAL TABLE reports.load_data
(id int, description string, tuples bigint, log_status string, duration timestamp)
row format delimited fields terminated by '|'
location '/user/impadmin/reports/load'
tblproperties ('serialization.null.format'='')
;
