CREATE EXTERNAL TABLE et_inventory (
    inv_date_sk int ,
    inv_item_sk int ,
    inv_warehouse_sk int ,
    inv_quantity_on_hand int
)
row format delimited fields terminated by '|'
location '/user/impadmin/tpcds_parquet/inventory'
tblproperties ('serialization.null.format'='')
;
