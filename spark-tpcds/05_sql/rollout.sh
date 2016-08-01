#!/bin/bash
set -e

PWD=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $PWD/../tpcds-env.sh
source $PWD/../functions.sh

step=sql
init_log $step

for i in $(ls $PWD/*.$SQL_VERSION.*.sql); do
	id=`echo $i | awk -F '.' '{print $1}'`
	schema_name=`echo $i | awk -F '.' '{print $2}'`
	table_name=`echo $i | awk -F '.' '{print $3}'`

	start_log
	echo "beeline -u jdbc:hive2://$SPARK_HOSTNAME:$SPARK_PORT -n ${USER} -d org.apache.hive.jdbc.HiveDriver --outputformat=csv2 --showHeader=false -f $i"
	tuples=$(beeline -u jdbc:hive2://$SPARK_HOSTNAME:$SPARK_PORT -n ${USER} -d org.apache.hive.jdbc.HiveDriver --outputformat=csv2 --showHeader=false -f $i | wc -l; exit ${PIPESTATUS[0]})

	log $tuples
done
end_step $step


