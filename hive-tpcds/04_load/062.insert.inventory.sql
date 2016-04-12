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

INSERT INTO inventory 
PARTITION(inv_date_sk)
SELECT  
    inv_item_sk,
    inv_warehouse_sk, 
    inv_quantity_on_hand,
    inv_date_sk
FROM et_inventory
distribute by inv_date_sk;
