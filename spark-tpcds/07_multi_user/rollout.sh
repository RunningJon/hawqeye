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

	if [ "$SQL_VERSION" == "hive" ]; then 
		if [ "$MULTI_USER_COUNT" -ne "5" ]; then
			echo "hive tests only supports 5 concurrent sessions."
			exit 1
		fi
	fi
}

get_beeline_count()
{
	beeline_count=$(ps -ef | grep beeline | grep multi_user | grep -v grep | wc -l)
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

	if [ "$SQL_VERSION" == "hive" ]; then
		echo "Using static $SQL_VERSION queries"
	else
		echo "Only hive queries are supported at this time."
		exit 1
	fi

	for x in $(seq 1 $MULTI_USER_COUNT); do
		session_log=$PWD/../log/testing_session_$x.log
		echo "$PWD/test.sh $x"
		$PWD/test.sh $x > $session_log 2>&1 < $session_log &
	done

	sleep 2

	get_beeline_count
	echo "Now executing queries. This make take a while."
	echo -ne "Executing queries."
	while [ "$beeline_count" -gt "0" ]; do
		now=$(date)
		echo "$now"
		if ls $PWD/../log/rollout_testing_* 1>/dev/null 2>&1; then
			wc -l $PWD/../log/rollout_testing_*
		else
			echo "No queries complete yet."
		fi

		sleep 60
		get_beeline_count
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
