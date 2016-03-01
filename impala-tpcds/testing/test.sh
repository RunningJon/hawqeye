#!/bin/bash

set -e

PWD=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $PWD/../functions.sh
source $PWD/../tpcds-env.sh

session_id=$1

if [ "$session_id" == "" ]; then
	echo "Error: you must provide the session id as a parameter."
	echo "Example: ./test.sh 3"
	echo "This will execute the session 3 queries."
	exit 1
fi

step=testing_$session_id

init_log $step

#call external function to get IMP_HOST
get_imp_details

if [ "$QUERY_TYPE" != "tpcds" ]; then
	sql_dir=$PWD/$QUERY_TYPE/$session_id
else
	sql_dir=$PWD/$session_id
	#going from 1 base to 0 base
	tpcds_id=$((session_id-1))
	tpcds_query_name="query_""$tpcds_id"".sql"
	query_id=1
	for p in $(seq 1 99); do
		q=$(printf %02d $query_id)
		template_filename=query$p.tpl
		start_position=""
		end_position=""
		for pos in $(grep -n $template_filename $sql_dir/$tpcds_query_name | awk -F ':' '{print $1}'); do
			if [ "$start_position" == "" ]; then
				start_position=$pos
			else
				end_position=$pos
			fi
		done

		#get the query number (the order of query execution) generated by dsqgen
		file_id=$(sed -n "$start_position","$start_position"p $sql_dir/$tpcds_query_name | awk -F ' ' '{print $4}')
		file_id=$(($file_id+100))
		filename=$file_id.query.$q.sql
		sed -n "$start_position","$end_position"p $sql_dir/$tpcds_query_name > $sql_dir/$filename
		query_id=$(($query_id + 1))
		echo "Completed: $sql_dir/$filename"
	done
	echo "rm -f $sql_dir/query_*.sql"
	rm -f $sql_dir/$tpcds_query_name
fi

tuples="0"
for i in $(ls $sql_dir/*.sql); do

	start_log
	id=$i
	schema_name=$session_id
	table_name=$(basename $i | awk -F '.' '{print $3}')

	echo "impala-shell -i $IMP_HOST -d $TPCDS_DBNAME -f $i"
	tuples=$(impala-shell -i $IMP_HOST -d $TPCDS_DBNAME -f $i | wc -l)
	log $tuples

done

end_step $step
