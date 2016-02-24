CREATE EXTERNAL TABLE reports.ddl
(id int, description string, tuples bigint, duration timestamp)
row format delimited fields terminated by '|'
location '/user/impadmin/reports/ddl'
tblproperties ('serialization.null.format'='')
;
