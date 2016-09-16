#!/bin/bash
set -e

PWD=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

source $PWD/../tpcds-env.sh
source $PWD/../functions.sh

step=ddl
init_log $step
log_status="success"

#call external function to get IMP_HOST
get_imp_details

for i in $(ls $PWD/*.sql); do
	#id=`echo $i | awk -F '.' '{print $1}'`
	id=$(basename $i | awk -F '.' '{print $1}')
	schema_name=`echo $i | awk -F '.' '{print $2}'`
	table_name=`echo $i | awk -F '.' '{print $3}'`
	start_log
	if [ "$id" == "000" ]; then
		#impala can't handle dropping the database you are currently connected to so use default
		echo "impala-shell -i $IMP_HOST -d default -f $i"
		impala-shell -i $IMP_HOST -d default -f $i
	else
		echo "impala-shell -i $IMP_HOST -d $TPCDS_DBNAME -f $i"
		impala-shell -i $IMP_HOST -d $TPCDS_DBNAME -f $i
	fi
	log
done

end_step $step

