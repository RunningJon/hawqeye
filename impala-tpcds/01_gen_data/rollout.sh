#!/bin/bash
set -e

PWD=$( cd $( dirname ${BASH_SOURCE[0]} ) && pwd )
source $PWD/../functions.sh
source $PWD/../tpcds-env.sh

get_count_generate_data()
{
	count="0"
	for i in $(cat $PWD/../dn.txt); do
		next_count=$(ssh -n -f $i "bash -c 'ps -ef | grep generate_data.sh | grep -v grep | wc -l'")
		count=$(($count + $next_count))
	done
}

kill_orphaned_data_gen()
{
	for i in $(cat $PWD/../dn.txt); do
		echo "$i:kill any orphaned processes"
		ssh -n -f $i "bash -c 'for x in $(ps -ef | grep dsdgen | grep -v grep | awk -F ' ' '{print $2}'); do echo "killing $x"; kill $x; done'"
	done
}

copy_generate_data()
{
	#copy generate_data.sh to ~/
	for i in $(cat $PWD/../dn.txt); do
		echo "copy generate_data.sh to $i:$ADMIN_HOME"
		scp $PWD/generate_data.sh $i:$ADMIN_HOME/
	done
}

remove_old_files()
{
	echo "hdfs dfs -rm -r -f -skipTrash ${FLATFILE_HDFS_ROOT}"
	hdfs dfs -rm -r -f -skipTrash ${FLATFILE_HDFS_ROOT}
}

create_new_directories()
{
	echo "hdfs dfs -mkdir ${FLATFILE_HDFS_ROOT}"
	hdfs dfs -mkdir ${FLATFILE_HDFS_ROOT}

	for t in call_center catalog_page catalog_returns catalog_sales customer customer_address customer_demographics date_dim household_demographics income_band inventory item promotion reason ship_mode store store_returns store_sales time_dim warehouse web_page web_returns web_sales web_site; do
		echo "hdfs dfs -mkdir ${FLATFILE_HDFS_ROOT}/$t"
		hdfs dfs -mkdir ${FLATFILE_HDFS_ROOT}/$t
	done

	echo "hdfs dfs -chmod -R 777 ${FLATFILE_HDFS_ROOT}"
	hdfs dfs -chmod -R 777 ${FLATFILE_HDFS_ROOT}

}

gen_data()
{
	local CHILD="0"
	for i in $(cat $PWD/../dn.txt); do
		EXT_HOST=$i
		for x in $(seq 1 ${DSDGEN_THREADS_PER_NODE}); do
			CHILD=$(($CHILD + 1))
			GEN_DATA_PATH="/data$x/tpcds_parquet"
			echo "ssh -n -f $EXT_HOST \"bash -c 'cd ~/; ./generate_data.sh $GEN_DATA_SCALE $CHILD $PARALLEL \"$GEN_DATA_PATH\" \"$FLATFILE_HDFS_ROOT\" > generate_data.$CHILD.log 2>&1 < generate_data.$CHILD.log &'\""
			ssh -n -f $EXT_HOST "bash -c 'cd ~/; ./generate_data.sh $GEN_DATA_SCALE $CHILD $PARALLEL "$GEN_DATA_PATH" "$FLATFILE_HDFS_ROOT" > generate_data.$CHILD.log 2>&1 < generate_data.$CHILD.log &'"
		done
	done
}

step=gen_data
init_log $step
start_log
schema_name="tpcds_parquet"
table_name="gen_data"

kill_orphaned_data_gen
copy_generate_data
remove_old_files
create_new_directories
#call external function to get PARALLEL
get_imp_details
gen_data

echo ""
get_count_generate_data
echo "Now generating data.  This make take a while."
echo -ne "Generating data"
while [ "$count" -gt "0" ]; do
	echo -ne "."
	sleep 5
	get_count_generate_data
done

echo "Done generating data"
echo ""
log

end_step $step
