CREATE EXTERNAL TABLE reports.gen_data
(id int, description string, tuples bigint, duration string)
row format delimited fields terminated by '|'
location '/user/${hivevar:user}/reports/gen_data';
