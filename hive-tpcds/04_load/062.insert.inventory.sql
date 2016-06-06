INSERT INTO inventory 
PARTITION(inv_date_sk)
SELECT  
    inv_item_sk,
    inv_warehouse_sk, 
    inv_quantity_on_hand,
    inv_date_sk
FROM et_inventory
distribute by inv_date_sk;
