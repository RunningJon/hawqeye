drop database if exists reports cascade;
create database reports;

CREATE EXTERNAL TABLE reports.compile_tpcds
(id int, description string, tuples bigint, log_status string, duration timestamp)
row format delimited fields terminated by '|'
location '/user/impadmin/reports/compile_tpcds'
tblproperties ('serialization.null.format'='')
;

