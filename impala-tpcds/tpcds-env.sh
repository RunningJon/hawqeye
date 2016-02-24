#!/bin/bash

set -e

LOCAL_PWD=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

FLATFILE_HDFS_ROOT=/user/${USER}/tpcds_parquet
FLATFILE_HDFS_REPORTS=/user/${USER}/reports
GEN_DATA_SCALE=3000
DSDGEN_THREADS_PER_NODE=12
TPCDS_DBNAME=tpcds_parquet
QUERY_TYPE="imp"

DN_COUNTER=$(cat $LOCAL_PWD/dn.txt | wc -l)
RANDOM_COUNTER=$(( ( RANDOM % $DN_COUNTER )  + 1 ))
PARALLEL=$(($DN_COUNTER * $DSDGEN_THREADS_PER_NODE))

i="0"
for dn in $(cat $LOCAL_PWD/dn.txt); do
	i=$(($i + 1))
	if [ "$i" -eq "$RANDOM_COUNTER" ]; then
		IMP_HOST="$dn"
	fi
done
