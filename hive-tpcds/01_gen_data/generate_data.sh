#!/bin/bash
set -e

PWD=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

GEN_DATA_SCALE=$1
CHILD=$2
PARALLEL=$3
GEN_DATA_PATH="$4"
FLATFILE_HDFS_ROOT="$5"


if [[ ! -d "$GEN_DATA_PATH" || -L "$GEN_DATA_PATH" ]]; then
	mkdir -p $GEN_DATA_PATH
fi

echo "rm -rf $GEN_DATA_PATH/*"
rm -rf $GEN_DATA_PATH/*

for t in call_center catalog_page catalog_sales customer customer_address customer_demographics date_dim household_demographics income_band inventory item promotion reason ship_mode store store_sales time_dim warehouse web_page web_sales web_site; do

	echo "$PWD/dsdgen -TABLE $t -SCALE $GEN_DATA_SCALE -CHILD $CHILD -PARALLEL $PARALLEL -DISTRIBUTIONS $PWD/tpcds.idx -TERMINATE N -DIR \"$GEN_DATA_PATH\""
	$PWD/dsdgen -TABLE $t -SCALE $GEN_DATA_SCALE -CHILD $CHILD -PARALLEL $PARALLEL -DISTRIBUTIONS $PWD/tpcds.idx -TERMINATE N -DIR "$GEN_DATA_PATH"
done

for t in call_center catalog_page catalog_returns catalog_sales customer customer_address customer_demographics date_dim household_demographics income_band inventory item promotion reason ship_mode store store_returns store_sales time_dim warehouse web_page web_returns web_sales web_site; do
	DSDGEN_FILENAME="$GEN_DATA_PATH""/""$t""_""$CHILD""_""$PARALLEL"".dat"
	TARGET_PATH="$FLATFILE_HDFS_ROOT""/""$t"

	if [ -f "$DSDGEN_FILENAME" ]; then
		echo "hdfs dfs -put $DSDGEN_FILENAME $TARGET_PATH"
		hdfs dfs -put $DSDGEN_FILENAME $TARGET_PATH
	fi
done
