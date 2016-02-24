CREATE TABLE inventory (
    inv_item_sk int ,
    inv_warehouse_sk int ,
    inv_quantity_on_hand int
)
PARTITIONED BY (inv_date_sk int)
STORED AS PARQUETFILE;
