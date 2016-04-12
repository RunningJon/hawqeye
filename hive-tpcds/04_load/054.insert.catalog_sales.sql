set hive.exec.dynamic.partition.mode=nonstrict;
set hive.exec.max.dynamic.partitions.pernode=100000;
set hive.exec.max.dynamic.partitions=100000;
set hive.exec.max.created.files=1000000;
set hive.exec.parallel=true;
set hive.exec.reducers.max=1;
set hive.stats.autogather=true;
set hive.optimize.sort.dynamic.partition=true;

set mapred.job.reduce.input.buffer.percent=0.0;
set mapreduce.input.fileinputformat.split.minsizee=240000000;
set mapreduce.input.fileinputformat.split.minsize.per.node=240000000;
set mapreduce.input.fileinputformat.split.minsize.per.rack=240000000;
set hive.optimize.sort.dynamic.partition=true;
set hive.tez.java.opts=-XX:+PrintGCDetails -verbose:gc -XX:+PrintGCTimeStamps -XX:+UseNUMA -XX:+UseG1GC -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/tmp/;

INSERT INTO catalog_sales 
PARTITION(cs_sold_date_sk)
SELECT
    cs_sold_time_sk,
    cs_ship_date_sk,
    cs_bill_customer_sk,
    cs_bill_cdemo_sk,
    cs_bill_hdemo_sk,
    cs_bill_addr_sk,
    cs_ship_customer_sk,
    cs_ship_cdemo_sk,
    cs_ship_hdemo_sk,
    cs_ship_addr_sk,
    cs_call_center_sk,
    cs_catalog_page_sk,
    cs_ship_mode_sk,
    cs_warehouse_sk,
    cs_item_sk,
    cs_promo_sk,
    cs_order_number,
    cs_quantity,
    cs_wholesale_cost,
    cs_list_price,
    cs_sales_price,
    cs_ext_discount_amt,
    cs_ext_sales_price,
    cs_ext_wholesale_cost,
    cs_ext_list_price,
    cs_ext_tax,
    cs_coupon_amt,
    cs_ext_ship_cost,
    cs_net_paid,
    cs_net_paid_inc_tax,
    cs_net_paid_inc_ship,
    cs_net_paid_inc_ship_tax,
    cs_net_profit,
    cs_sold_date_sk
FROM et_catalog_sales
DISTRIBUTE BY cs_sold_date_sk;
