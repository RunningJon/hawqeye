CREATE EXTERNAL TABLE et_customer_demographics (
    cd_demo_sk int ,
    cd_gender char(1),
    cd_marital_status char(1),
    cd_education_status char(20),
    cd_purchase_estimate int,
    cd_credit_rating char(10),
    cd_dep_count int,
    cd_dep_employed_count int,
    cd_dep_college_count int
)
row format delimited fields terminated by '|'
location '/user/impadmin/tpcds_parquet/customer_demographics'
tblproperties ('serialization.null.format'='')
;
