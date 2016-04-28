#!/bin/bash

set -e
PWD=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

if [ ! -f "$PWD/tpcds-env.sh" ]; then
	echo "cp $PWD/tpcds-env.sh.template $PWD/tpcds-env.sh"
	cp $PWD/tpcds-env.sh.template $PWD/tpcds-env.sh
	echo "First execution!"
	echo "Review the tpcds-env.sh file and then run again."
	exit 1
fi

source $PWD/functions.sh
source $PWD/tpcds-env.sh

create_directories()
{
	if [ ! -d $LOCAL_PWD/log ]; then
		echo "mkdir $LOCAL_PWD/log"
		mkdir $LOCAL_PWD/log
	fi
}

cleanup()
{
	if [ "$compile" -eq "1" ]; then
		echo "rm -f $PWD/log/end_compile.log"
		rm -f $PWD/log/end_compile.log
	fi
	if [ "$gen_data" -eq "1" ]; then
		echo "rm -f $PWD/log/end_gen_data.log"
		rm -f $PWD/log/end_gen_data.log
	fi
	if [ "$ddl" -eq "1" ]; then
		echo "rm -f $PWD/log/end_ddl.log"
		rm -f $PWD/log/end_ddl.log
	fi
	if [ "$load" -eq "1" ]; then
		echo "rm -f $PWD/log/end_load.log"
		rm -f $PWD/log/end_load.log
	fi
	if [ "$sql" -eq "1" ]; then
		echo "rm -f $PWD/log/end_sql.log"
		rm -f $PWD/log/end_sql.log
		echo "rm -f $PWD/log/one_session_*.log"
		rm -f $PWD/log/one_session_*.log
	fi
	if [ "$reports" -eq "1" ]; then
		echo "rm -f $PWD/log/end_single_user_reports.log"
		rm -f $PWD/log/end_single_user_reports.log
	fi
	if [ "$multi_user" -eq "1" ]; then
		echo "rm -f $PWD/log/end_testing*.log"
		rm -f $PWD/log/end_testing*.log
	fi
}

create_directories
cleanup

for i in $(ls -d $PWD/0*); do
	echo "$i/rollout.sh"
	$i/rollout.sh
done
