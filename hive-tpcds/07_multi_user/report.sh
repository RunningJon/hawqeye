#!/bin/bash
set -e

PWD=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $PWD/../functions.sh
source $PWD/../tpcds-env.sh

remove_old_files()
{
	echo "hdfs dfs -rm -r -f -skipTrash ${FLATFILE_HDFS_TESTING}"
	hdfs dfs -rm -r -f -skipTrash ${FLATFILE_HDFS_TESTING}
}

create_new_directories()
{
	echo "hdfs dfs -mkdir ${FLATFILE_HDFS_TESTING}"
	hdfs dfs -mkdir ${FLATFILE_HDFS_TESTING}

	for t in sql; do
		echo "hdfs dfs -mkdir ${FLATFILE_HDFS_TESTING}/$t"
		hdfs dfs -mkdir ${FLATFILE_HDFS_TESTING}/$t
	done

	echo "hdfs dfs -chmod -R 777 ${FLATFILE_HDFS_TESTING}"
	hdfs dfs -chmod -R 777 ${FLATFILE_HDFS_TESTING}

}

put_data()
{
	for t in $(seq 1 $MULTI_USER_COUNT); do
		TARGET_PATH=$FLATFILE_HDFS_TESTING"/sql"
		echo "hdfs dfs -put $PWD/../log/rollout_testing_$t.log $TARGET_PATH"
		hdfs dfs -put $PWD/../log/rollout_testing_$t.log $TARGET_PATH
	done
}

create_tables()
{
	for i in $(ls $PWD/*.sql | grep -v report.sql); do
		id=$(basename $i | awk -F '.' '{print $1}')

		if [ "$id" == "00" ]; then
			echo "beeline -u jdbc:hive2://localhost:10000 -n ${USER} -d org.apache.hive.jdbc.HiveDriver -f $i -hivevar user=$USER"
			beeline -u jdbc:hive2://localhost:10000 -n ${USER} -d org.apache.hive.jdbc.HiveDriver -f $i -hivevar user=$USER
		else
			echo "beeline -u jdbc:hive2://localhost:10000/testing -n ${USER} -d org.apache.hive.jdbc.HiveDriver -f $i -hivevar user=$USER"
			beeline -u jdbc:hive2://localhost:10000/testing -n ${USER} -d org.apache.hive.jdbc.HiveDriver -f $i -hivevar user=$USER
		fi
	done
}

view_reports()
{
	for i in $(ls $PWD/*.sql | grep report); do
		echo "beeline -u jdbc:hive2://localhost:10000/testing -n ${USER} -d org.apache.hive.jdbc.HiveDriver -f $i"
		beeline -u jdbc:hive2://localhost:10000/testing -n ${USER} -d org.apache.hive.jdbc.HiveDriver -f $i
	done
}

create_tables

remove_old_files
create_new_directories
put_data
view_reports
