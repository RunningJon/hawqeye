#!/bin/bash
set -e

PWD=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

source $PWD/../tpcds-env.sh
source $PWD/../functions.sh

remove_old_files()
{
	echo "hdfs dfs -rm -r -f -skipTrash ${FLATFILE_HDFS_REPORTS}"
	hdfs dfs -rm -r -f -skipTrash ${FLATFILE_HDFS_REPORTS}
}

create_new_directories()
{
	echo "hdfs dfs -mkdir ${FLATFILE_HDFS_REPORTS}'"
	hdfs dfs -mkdir ${FLATFILE_HDFS_REPORTS}

	for t in compile_tpcds gen_data ddl load sql; do
		echo "hdfs dfs -mkdir ${FLATFILE_HDFS_REPORTS}/$t"
		hdfs dfs -mkdir ${FLATFILE_HDFS_REPORTS}/$t
	done

	echo "hdfs dfs -chmod -R 777 ${FLATFILE_HDFS_REPORTS}"
	hdfs dfs -chmod -R 777 ${FLATFILE_HDFS_REPORTS}

}

put_data()
{
	for t in compile_tpcds gen_data ddl load sql; do
		TARGET_PATH=$FLATFILE_HDFS_REPORTS"/"$t
		echo "hdfs dfs -put $PWD/../log/rollout_$t.log $TARGET_PATH"
		hdfs dfs -put $PWD/../log/rollout_$t.log $TARGET_PATH
	done
}

create_tables()
{
	for i in $(ls $PWD/*.sql | grep -v report.sql); do
		id=$(basename $i | awk -F '.' '{print $1}')

		if [ "$id" == "00" ]; then
			echo "impala-shell -i $IMP_HOST -d default -f $i"
			impala-shell -i $IMP_HOST -d default -f $i
		else
			echo "impala-shell -i $IMP_HOST -d reports -f $i"
			impala-shell -i $IMP_HOST -d reports -f $i
		fi
	done
}

#call external function to get IMP_HOST
get_imp_details

remove_old_files
create_new_directories
put_data
create_tables

echo "********************************************************************************"
echo "Generate Data"
echo "********************************************************************************"
impala-shell -i $IMP_HOST -d reports -f $PWD/gen_data_report.sql -B --quiet 2> /dev/null
echo ""
echo "********************************************************************************"
echo "Data Loads"
echo "********************************************************************************"
impala-shell -i $IMP_HOST -d reports -f $PWD/loads_report.sql -B --quiet 2> /dev/null
echo ""
echo "********************************************************************************"
echo "Analyze"
echo "********************************************************************************"
impala-shell -i $IMP_HOST -d reports -f $PWD/analyze_report.sql -B --quiet 2> /dev/null
echo ""
echo ""
echo "********************************************************************************"
echo "Queries"
echo "********************************************************************************"
impala-shell -i $IMP_HOST -d reports -f $PWD/queries_report.sql -B --quiet 2> /dev/null
echo ""
