#!/bin/bash
set -e

PWD=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

source $PWD/../tpcds-env.sh
source $PWD/../functions.sh

step=ddl
init_log $step

for i in $(ls $PWD/*.sql); do
	#id=`echo $i | awk -F '.' '{print $1}'`
	id=$(basename $i | awk -F '.' '{print $1}')
	schema_name=`echo $i | awk -F '.' '{print $2}'`
	table_name=`echo $i | awk -F '.' '{print $3}'`
	start_log
	if [ "$id" == "000" ]; then
		echo "beeline -u jdbc:hive2://localhost:10000 -n ${USER} -d org.apache.hive.jdbc.HiveDriver -f $i"
		beeline -u jdbc:hive2://localhost:10000 -n ${USER} -d org.apache.hive.jdbc.HiveDriver -f $i
	else
		echo "beeline -u jdbc:hive2://localhost:10000/$TPCDS_DBNAME -n ${USER} -d org.apache.hive.jdbc.HiveDriver -f $i"
		beeline -u jdbc:hive2://localhost:10000/$TPCDS_DBNAME -n ${USER} -d org.apache.hive.jdbc.HiveDriver -f $i
	fi
	log
done

end_step $step

