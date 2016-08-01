#!/bin/bash
set -e

max_duration="$1"

if [ "$max_duration" == "" ]; then
	echo "max_duration must be provided and is the number of seconds before killing the process."
	echo "3600 = 1 hour; 7200 = 2 hours; 10800 = 3 hours"
	echo "example:"
	echo "./kill_long_running.sh 3600"
	exit 1
fi	
for i in $(ps -ef | grep beeline | grep -v grep | awk -F ' ' '{print $2}'); do
	duration=$(ps -p $i -oetime= | tr '-' ':' | awk -F: '{ total=0; m=1; } { for (i=0; i < NF; i++) {total += $(NF-i)*m; m *= i >= 2 ? 24 : 60 }} {print total}')
	if [ "$duration" -ge "$max_duration" ]; then
		echo "duration: $duration so killing $i"
		echo "process details:"
		ps -ef | grep beeline | grep $i | grep -v grep
		kill $i
	fi
done
