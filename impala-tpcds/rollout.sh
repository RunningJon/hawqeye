#!/bin/bash

set -e
PWD=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

if [ ! -f "$PWD/tpcds-env.sh" ]; then
	echo "cp $PWD/tpcds-env.sh.template $PWD/tpcds-env.sh"
	cp $PWD/tpcds-env.sh.template $PWD/tpcds-env.sh
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
	echo "rm -f $PWD/log/end_ddl.log"
	rm -f $PWD/log/end_ddl.log
	echo "rm -f $PWD/log/end_load.log"
	rm -f $PWD/log/end_load.log
	echo "rm -f $PWD/log/end_sql.log"
	rm -f $PWD/log/end_sql.log

}

create_directories
cleanup

for i in $(ls -d $PWD/0*); do
	echo "$i/rollout.sh"
	$i/rollout.sh
done
