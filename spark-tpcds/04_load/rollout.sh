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

	echo "beeline -u jdbc:hive2://$HIVE_HOSTNAME:$HIVE_PORT -n ${USER} -d org.apache.hive.jdbc.HiveDriver -f $i"
	#when using hive.stats.autogather=false, the number of rows inserted is not printed.
	#hard code to 1 so reports can finish 
	tuples="1"
	beeline -u jdbc:hive2://$HIVE_HOSTNAME:$HIVE_PORT -n ${USER} -d org.apache.hive.jdbc.HiveDriver -f $i

	log $tuples
done

#analyze
for i in $(ls $PWD/*.sql); do
	start_log

	id=$(echo $i | awk -F '.' '{print $1}')
	schema_name=$(echo $i | awk -F '.' '{print $2}')
	table_name=$(echo $i | awk -F '.' '{print $3}')

	echo "beeline -u jdbc:hive2://$HIVE_HOSTNAME:$HIVE_PORT -n ${USER} -d org.apache.hive.jdbc.HiveDriver -e \"ANALYZE TABLE $table_name COMPUTE STATISTICS FOR COLUMNS\""
	beeline -u jdbc:hive2://$HIVE_HOSTNAME:$HIVE_PORT -n ${USER} -d org.apache.hive.jdbc.HiveDriver -e "ANALYZE TABLE $table_name COMPUTE STATISTICS FOR COLUMNS"
	tuples="0"

	log $tuples
	
done

end_step $step
