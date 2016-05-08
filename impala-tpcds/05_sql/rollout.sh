#!/bin/bash
set -e

PWD=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $PWD/../tpcds-env.sh
source $PWD/../functions.sh

step=sql
init_log $step

# call external function to get IMP_HOST
get_imp_details

for i in $(ls $PWD/*.$SQL_VERSION.*.sql); do

	start_log
	id=`echo $i | awk -F '.' '{print $1}'`
	schema_name=`echo $i | awk -F '.' '{print $2}'`
	table_name=`echo $i | awk -F '.' '{print $3}'`
	myfile=$(basename $i)

	run_query="1"
	oom_count="0"
	while [ "$run_query" -eq "1" ]; do
		query_log_file="$PWD/../log/one_session_""$myfile"".log"
		echo "impala-shell -i $IMP_HOST -d $TPCDS_DBNAME -f $i --quiet"
		impala-shell -i $IMP_HOST -d $TPCDS_DBNAME -f $i --quiet > $query_log_file 2>&1 || true

		# these are known errors that Impala will have under heavy load.  When this happens, retry to run the query
		error_state_store_count=$(grep "Waiting for catalog update from the StateStore" $query_log_file | wc -l)
		error_connect_timeout_count=$(grep "Error connecting: TTransportException" $query_log_file | wc -l)
		error_communicate_impalad_count=$(grep "Error communicating with impalad" $query_log_file | wc -l)
		error_connection_reset_count=$(grep "Socket error 104: Connection reset by peer" $query_log_file | wc -l)
		error_connection_refused_count=$(grep "Connection refused" $query_log_file | wc -l)
		warning_unreachable_impalad=$(grep "Cancelled due to unreachable impalad" $query_log_file | wc -l)
		error_econnreset=$(grep "ECONNRESET" $query_log_file | wc -l)

		# check for any error because there might be one that is not expected
		error_count=$(grep -i error $query_log_file | wc -l)

		# out of memory error happens on queries under heavy load.  Continue with these queries.
		oom_count=$(grep "Memory limit exceeded" $query_log_file | wc -l)

		if [ "$oom_count" -gt "0" ]; then
			# query ran but ran out of memory.  Don't retry
			grep "Memory limit exceeded" $query_log_file
			tuples="0"
			run_query="0"
			log $tuples
		else
			if [[ "$error_state_store_count" -gt "0" || "$error_connect_timeout_count" -gt "0" || "$error_communicate_impalad_count" -gt "0" || "$error_connection_reset_count" -gt "0" || "$error_connection_refused_count" -gt "0" || "$warning_unreachable_impalad" -gt "0" || "$error_econnreset" -gt "0" ]]; then

				# Wait 5 seconds and try again
				# Print the error message and continue
				if [ "$error_state_store_count" -gt "0" ]; then
					grep "Waiting for catalog update from the StateStore" $query_log_file
				fi

				if [ "$error_connect_timeout_count" -gt "0" ]; then
					grep "Error connecting: TTransportException" $query_log_file
				fi

				if [ "$error_communicate_impalad_count" -gt "0" ]; then
					grep "Error communicating with impalad" $query_log_file
				fi

				if [ "$error_connection_reset_count" -gt "0" ]; then
					grep "Socket error 104: Connection reset by peer" $query_log_file
				fi

				if [ "$error_connection_refused_count" -gt "0" ]; then
					grep "Connection refused" $query_log_file
				fi

				if [ "$warning_unreachable_impalad" -gt "0" ]; then
					grep "Cancelled due to unreachable impalad" $query_log_file
				fi

				if [ "$error_econnreset" -gt "0" ]; then
					grep "ECONNRESET" $query_log_file
				fi

				# check for unexpected errors
				if [[ "$error_state_store_count" -eq "0" && "$error_connect_timeout_count" -eq "0" && "$error_communicate_impalad_count" -eq "0" && "$error_connection_reset_count" -eq "0" && "$error_connection_refused_count" -eq "0" && "$warning_unreachable_impalad" -eq "0" && "$error_econnreset" -eq "0" && "$error_count" -gt "0" ]]; then
					echo "Unexpected error!"
					grep -i error $query_log_file
				fi

				# capture the execution time and if too long, then don't retry
				if [ "$OSVERSION" == "Linux" ]; then
					current_t="$(($(date +%s%N)-T))"
					# seconds
					current_s="$((current_t/1000000000))"
				else
					# must be OSX which doesn't have nano-seconds
					current_s="$(($(date +%s)-T))"
				fi
				# give up after hitting the long_running_timeout
				if [ "$current_s" -ge "$LONG_RUNNING_TIMEOUT" ]; then
					echo "Long running timeout exceeded."
					run_query="0"
					tuples="0"
					log $tuples
				else
					run_query="1"
					sleep 5
				fi
			else
				tuples=$(cat $query_log_file | wc -l)
				run_query="0"
				log $tuples
			fi
		fi
	done
done

end_step $step


