drop database if exists reports cascade;
create database reports;

CREATE EXTERNAL TABLE reports.compile_tpcds
(id int, description string, tuples bigint, duration string)
row format delimited fields terminated by '|'
location '/user/${hivevar:user}/reports/compile_tpcds';
