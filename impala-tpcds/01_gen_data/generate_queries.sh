#!/bin/bash

PWD=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $PWD/../functions.sh
source $PWD/../tpcds-env.sh

set -e

query_id=1
file_id=101

rm -f $PWD/query_0.sql

echo "$PWD/dsqgen -input $PWD/query_templates/templates.lst -directory $PWD/query_templates -dialect impala -scale $GEN_DATA_SCALE -verbose y -output $PWD"
$PWD/dsqgen -input $PWD/query_templates/templates.lst -directory $PWD/query_templates -dialect impala -scale $GEN_DATA_SCALE -verbose y -output $PWD

rm -f $PWD/../05_sql/*.query.*.sql

for p in $(seq 1 99); do
	q=$(printf %02d $query_id)
	filename=$file_id.tpcds.$q.sql
	template_filename=query$p.tpl
	start_position=""
	end_position=""
	for pos in $(grep -n $template_filename $PWD/query_0.sql | awk -F ':' '{print $1}'); do
		if [ "$start_position" == "" ]; then
			start_position=$pos
		else
			end_position=$pos
		fi
	done

	#Impala can't handle the last lining in a SQL file being a comment so remove.
	end_position=$(($end_position-1))

	echo "sed -n \"$start_position\",\"$end_position\"p $PWD/query_0.sql > $PWD/../05_sql/$filename"
	sed -n "$start_position","$end_position"p $PWD/query_0.sql > $PWD/../05_sql/$filename
	query_id=$(($query_id + 1))
	file_id=$(($file_id + 1))
	echo "Completed: $PWD/../05_sql/$filename"
done

echo "COMPLETE: dsqgen scale $GEN_DATA_SCALE"
