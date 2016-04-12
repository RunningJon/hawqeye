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

INSERT INTO store_sales
PARTITION(ss_sold_date_sk) 
SELECT 
   ss_sold_time_sk,
   ss_item_sk,
   ss_customer_sk,
   ss_cdemo_sk,
   ss_hdemo_sk,
   ss_addr_sk,
   ss_store_sk,
   ss_promo_sk,
   ss_ticket_number,
   ss_quantity,
   ss_wholesale_cost,
   ss_list_price,
   ss_sales_price,
   ss_ext_discount_amt,
   ss_ext_sales_price,
   ss_ext_wholesale_cost,
   ss_ext_list_price,
   ss_ext_tax,
   ss_coupon_amt,
   ss_net_paid,
   ss_net_paid_inc_tax,
   ss_net_profit,
   ss_sold_date_sk
FROM et_store_sales
distribute by ss_sold_date_sk;
