#!/bin/bash
set -e

PWD=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

source $PWD/../tpcds-env.sh
source $PWD/../functions.sh

step=load
init_log $step

for i in $(ls $PWD/*.sql); do
	start_log

	id=$(echo $i | awk -F '.' '{print $1}')
	schema_name=$(echo $i | awk -F '.' '{print $2}')
	table_name=$(echo $i | awk -F '.' '{print $3}')

	echo "beeline -u jdbc:hive2://$HIVE_HOSTNAME:10000/$TPCDS_DBNAME -n ${USER} -d org.apache.hive.jdbc.HiveDriver -f $i"
	#output shows the number of rows per partition so loop through output and sum the rows per table
	tuples="0"
	for c in $(beeline -u jdbc:hive2://$HIVE_HOSTNAME:10000/$TPCDS_DBNAME -n ${USER} -d org.apache.hive.jdbc.HiveDriver -f $i 2>&1 | grep numRows | awk -F ' ' '{print $7}' | awk -F '=' '{print $2}' | awk -F ',' '{print $1}'; exit ${PIPESTATUS[0]}); do
		tuples=$(($tuples + $c))
	done

	echo "Tuples inserted: $tuples"

	if [ "$tuples" -le "0" ]; then
		echo "No data loaded for table!"
		exit 1
	fi

	log $tuples
done

#analyze
for i in $(ls $PWD/*.sql); do
	start_log

	id=$(echo $i | awk -F '.' '{print $1}')
	schema_name=$(echo $i | awk -F '.' '{print $2}')
	table_name=$(echo $i | awk -F '.' '{print $3}')

	echo "beeline -u jdbc:hive2://$HIVE_HOSTNAME:10000/$TPCDS_DBNAME -n ${USER} -d org.apache.hive.jdbc.HiveDriver -e \"ANALYZE TABLE $schema_name.$table_name\" COMPUTE STATISTICS FOR COLUMNS"
	beeline -u jdbc:hive2://$HIVE_HOSTNAME:10000/$TPCDS_DBNAME -n ${USER} -d org.apache.hive.jdbc.HiveDriver -e "ANALYZE TABLE $schema_name.$table_name COMPUTE STATISTICS FOR COLUMNS"
	tuples="0"

	log $tuples
	
done

end_step $step
