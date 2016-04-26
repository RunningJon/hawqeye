#!/bin/bash

set -e

PWD=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $PWD/../functions.sh
source $PWD/../tpcds-env.sh

check_multi_user_count()
{
	if [ "$MULTI_USER_COUNT" -eq "0" ]; then
		echo "$MULTI_USER_COUNT set at 0 so exiting..."
		exit 0
	fi

	if [ "$SQL_VERSION" == "imp" ]; then 
		if [ "$MULTI_USER_COUNT" -gt "10" ]; then
			echo "imp tests only supports 10 or less concurrent sessions."
			exit 1
		fi
	fi
}

get_impala_shell_count()
{
	impala_shell_count=$(ps -ef | grep impala-shell | grep multi_user | grep -v grep | wc -l)
}

get_file_count()
{
	file_count=$(ls $PWD/../log/end_testing* 2> /dev/null | wc -l)
}

check_multi_user_count
get_file_count

if [ "$file_count" -ne "$MULTI_USER_COUNT" ]; then

	rm -f $PWD/../log/end_testing_*.log
	rm -f $PWD/../log/testing*.log
	rm -f $PWD/../log/test_*.log

	if [ "$SQL_VERSION" == "imp" ]; then
		echo "Using static $SQL_VERSION queries"
	else
		rm -f $PWD/query_*.sql

		#create each session's directory
		sql_dir=$PWD/$session_id
		echo "sql_dir: $sql_dir"
		for i in $(seq 1 $MULTI_USER_COUNT); do
			sql_dir="$PWD"/"$session_id""$i"
			echo "checking for directory $sql_dir"
			if [ ! -d "$sql_dir" ]; then
				echo "mkdir $sql_dir"
				mkdir $sql_dir
			fi
			echo "rm -f $sql_dir/*.sql"
			rm -f $sql_dir/*.sql
		done

		#Create queries
		echo "cd $PWD"
		cd $PWD	
		echo "$PWD/dsqgen -streams $MULTI_USER_COUNT -input $PWD/query_templates/templates.lst -directory $PWD/query_templates -dialect impala -scale $GEN_DATA_SCALE -verbose y -output $PWD"
		$PWD/dsqgen -streams $MULTI_USER_COUNT -input $PWD/query_templates/templates.lst -directory $PWD/query_templates -dialect impala -scale $GEN_DATA_SCALE -verbose y -output $PWD

		#move the query_x.sql file to the correct session directory
		for i in $(ls $PWD/query_*.sql); do
			stream_number=$(basename $i | awk -F '.' '{print $1}' | awk -F '_' '{print $2}')
			#going from base 0 to base 1
			stream_number=$((stream_number+1))
			echo "stream_number: $stream_number"
			sql_dir=$PWD/$stream_number
			echo "mv $i $sql_dir/"
			mv $i $sql_dir/
		done
	fi

	for x in $(seq 1 $MULTI_USER_COUNT); do
		session_log=$PWD/../log/testing_session_$x.log
		echo "$PWD/test.sh $x"
		$PWD/test.sh $x > $session_log 2>&1 < $session_log &
	done

	sleep 2

	get_impala_shell_count
	echo "Now executing queries. This make take a while."
	echo -ne "Executing queries."
	while [ "$impala_shell_count" -gt "0" ]; do
		now=$(date)
		echo "$now"
		if ls $PWD/../log/rollout_testing_* 1>/dev/null 2>&1; then
			wc -l $PWD/../log/rollout_testing_*
		else
			echo "No queries complete yet."
		fi

		sleep 60
		get_impala_shell_count
	done
	echo "queries complete"
	echo ""

	get_file_count

	if [ "$file_count" -ne "$MULTI_USER_COUNT" ]; then
		echo "The number of successfully completed sessions is less than expected!"
		echo "Please review the log files to determine which queries failed."
		exit 1
	fi
fi

$PWD/report.sh
