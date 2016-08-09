#!/bin/bash
set -e

PWD=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

source $PWD/../tpcds-env.sh
source $PWD/../functions.sh
step=single_user_reports

init_log $step

if [ "$HIVE2" == "true" ]; then
	MYPORT="$HIVE2_PORT"
else
	MYPORT="$HIVE_PORT"
fi

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
			echo "beeline -u jdbc:hive2://$HIVE_HOSTNAME:$HIVE_PORT -n ${USER} -d org.apache.hive.jdbc.HiveDriver --outputformat=tsv2 --showHeader=false -f $i -hivevar user=$USER"
			beeline -u jdbc:hive2://$HIVE_HOSTNAME:$HIVE_PORT -n ${USER} -d org.apache.hive.jdbc.HiveDriver --outputformat=tsv2 --showHeader=false -f $i -hivevar user=$USER

		else
			echo "beeline -u jdbc:hive2://$HIVE_HOSTNAME:$HIVE_PORT/reports -n ${USER} -d org.apache.hive.jdbc.HiveDriver --outputformat=tsv2 --showHeader=false -f $i -hivevar user=$USER"
			beeline -u jdbc:hive2://$HIVE_HOSTNAME:$HIVE_PORT/reports -n ${USER} -d org.apache.hive.jdbc.HiveDriver --outputformat=tsv2 --showHeader=false -f $i -hivevar user=$USER
		fi
	done
}

create_tables

remove_old_files
create_new_directories
put_data

echo "********************************************************************************"
echo "Generate Data"
echo "********************************************************************************"
echo "beeline -u jdbc:hive2://$HIVE_HOSTNAME:$MYPORT/reports -n ${USER} -d org.apache.hive.jdbc.HiveDriver --outputformat=tsv2 --showHeader=false -f $PWD/gen_data_report.sql"
beeline -u jdbc:hive2://$HIVE_HOSTNAME:$MYPORT/reports -n ${USER} -d org.apache.hive.jdbc.HiveDriver --outputformat=tsv2 --showHeader=false -f $PWD/gen_data_report.sql 2> /dev/null
echo ""
echo "********************************************************************************"
echo "Analyze tables"
echo "********************************************************************************"
echo "beeline -u jdbc:hive2://$HIVE_HOSTNAME:$MYPORT/reports -n ${USER} -d org.apache.hive.jdbc.HiveDriver --outputformat=tsv2 --showHeader=false -f $PWD/analyze_report.sql"
beeline -u jdbc:hive2://$HIVE_HOSTNAME:$MYPORT/reports -n ${USER} -d org.apache.hive.jdbc.HiveDriver --outputformat=tsv2 --showHeader=false -f $PWD/analyze_report.sql 2> /dev/null
echo ""
echo "********************************************************************************"
echo "Data Loads"
echo "********************************************************************************"
echo "beeline -u jdbc:hive2://$HIVE_HOSTNAME:$MYPORT/reports -n ${USER} -d org.apache.hive.jdbc.HiveDriver --outputformat=tsv2 --showHeader=false -f $PWD/loads_report.sql"
beeline -u jdbc:hive2://$HIVE_HOSTNAME:$MYPORT/reports -n ${USER} -d org.apache.hive.jdbc.HiveDriver --outputformat=tsv2 --showHeader=false -f $PWD/loads_report.sql 2> /dev/null
echo ""
echo "********************************************************************************"
echo "Queries"
echo "********************************************************************************"
echo "beeline -u jdbc:hive2://$HIVE_HOSTNAME:$MYPORT/reports -n ${USER} -d org.apache.hive.jdbc.HiveDriver --outputformat=tsv2 --showHeader=false -f $PWD/queries_report.sql"
beeline -u jdbc:hive2://$HIVE_HOSTNAME:$MYPORT/reports -n ${USER} -d org.apache.hive.jdbc.HiveDriver --outputformat=tsv2 --showHeader=false -f $PWD/queries_report.sql 2> /dev/null
echo ""

end_step $step
