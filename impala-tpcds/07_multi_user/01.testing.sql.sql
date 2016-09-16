CREATE EXTERNAL TABLE testing.sql_queries
(id int, description string, tuples bigint, log_status string, duration timestamp)
row format delimited fields terminated by '|'
location '/user/impadmin/testing/sql'
tblproperties ('serialization.null.format'='')
