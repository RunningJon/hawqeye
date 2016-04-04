CREATE EXTERNAL TABLE reports.sql_queries
(id int, description string, tuples bigint, duration timestamp)
row format delimited fields terminated by '|'
location '/user/impadmin/reports/sql'
tblproperties ('serialization.null.format'='')
;
