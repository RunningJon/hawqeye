CREATE EXTERNAL TABLE reports.sql_queries
(id int, description string, tuples bigint, duration string)
row format delimited fields terminated by '|'
location '/user/${hivevar:user}/reports/sql';
