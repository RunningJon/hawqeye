CREATE TABLE store_sales (
    ss_sold_time_sk int,
    ss_item_sk int,
    ss_customer_sk int,
    ss_cdemo_sk int,
    ss_hdemo_sk int,
    ss_addr_sk int,
    ss_store_sk int,
    ss_promo_sk int,
    ss_ticket_number bigint,
    ss_quantity int,
    ss_wholesale_cost float,
    ss_list_price float,
    ss_sales_price float,
    ss_ext_discount_amt float,
    ss_ext_sales_price float,
    ss_ext_wholesale_cost float,
    ss_ext_list_price float,
    ss_ext_tax float,
    ss_coupon_amt float,
    ss_net_paid float,
    ss_net_paid_inc_tax float,
    ss_net_profit float
)
PARTITIONED BY (ss_sold_date_sk int)
STORED AS PARQUET TBLPROPERTIES ("orc.compress"="SNAPPY");
