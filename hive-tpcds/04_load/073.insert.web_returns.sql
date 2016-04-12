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

INSERT INTO web_returns 
PARTITION(wr_returned_date_sk)
SELECT 
    wr_returned_time_sk,
    wr_item_sk,
    wr_refunded_customer_sk,
    wr_refunded_cdemo_sk,
    wr_refunded_hdemo_sk,
    wr_refunded_addr_sk,
    wr_returning_customer_sk,
    wr_returning_cdemo_sk,
    wr_returning_hdemo_sk,
    wr_returning_addr_sk,
    wr_web_page_sk,
    wr_reason_sk,
    wr_order_number,
    wr_return_quantity,
    wr_return_amt,
    wr_return_tax,
    wr_return_amt_inc_tax,
    wr_fee,
    wr_return_ship_cost,
    wr_refunded_cash,
    wr_reversed_charge,
    wr_account_credit,
    wr_net_loss,
    wr_returned_date_sk
FROM et_web_returns
distribute by wr_returned_date_sk;
