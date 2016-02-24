#!/bin/bash
set -e

PWD=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

source $PWD/../tpcds-env.sh
source $PWD/../functions.sh

step=load
init_log $step


for i in $(ls $PWD/*.sql); do
	start_log

	id=`echo $i | awk -F '.' '{print $1}'`
	schema_name=`echo $i | awk -F '.' '{print $2}'`
	table_name=`echo $i | awk -F '.' '{print $3}'`

	echo "impala-shell -i $IMP_HOST -d $TPCDS_DBNAME -f $i"
	tuples=$(impala-shell -i $IMP_HOST -d $TPCDS_DBNAME -f $i 2>&1 | grep "Inserted" | awk -F ' ' '{print $2}')

	if [ "$tuples" -le "0" ]; then
		echo "No data loaded for table!"
		exit 1
	fi

	log $tuples
done

#analyze

for i in $(ls $PWD/*.sql); do
	start_log

	id=`echo $i | awk -F '.' '{print $1}'`
	schema_name=`echo $i | awk -F '.' '{print $2}'`
	table_name=`echo $i | awk -F '.' '{print $3}'`

	echo "impala-shell -i $IMP_HOST -d $TPCDS_DBNAME -q \"COMPUTE STATS $table_name\""
	impala-shell -i $IMP_HOST -d $TPCDS_DBNAME -q "COMPUTE STATS $table_name"

	tuples="0"
	log $tuples
	
done

end_step $step
