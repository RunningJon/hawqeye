#!/bin/bash
set -e

PWD=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $PWD/../tpcds-env.sh
source $PWD/../functions.sh
log_status="success"

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
	oom="0"
	
	while [ "$run_query" -eq "1" ]; do
		query_log_file="$PWD/../log/one_session_""$myfile"".log"
		echo "impala-shell -i $IMP_HOST -d $TPCDS_DBNAME -f $i --quiet"
		#myoutput will capture the error code if the query is killed from a timeout (code 143)
		myoutput=$(impala-shell -i $IMP_HOST -d $TPCDS_DBNAME -f $i --quiet > $query_log_file 2>&1 || echo $?)

		# these are known errors that Impala will have under heavy load.  When this happens, retry to run the query
		error_state_store=$(grep "Waiting for catalog update from the StateStore" $query_log_file | wc -l)
		error_connect_timeout=$(grep "Error connecting: TTransportException" $query_log_file | wc -l)
		error_communicate_impalad=$(grep "Error communicating with impalad" $query_log_file | wc -l)
		error_connection_reset=$(grep "Socket error 104: Connection reset by peer" $query_log_file | wc -l)
		error_connection_refused=$(grep "Connection refused" $query_log_file | wc -l)
		error_unreachable_impalad=$(grep "Cancelled due to unreachable impalad" $query_log_file | wc -l)
		error_econnreset=$(grep "ECONNRESET" $query_log_file | wc -l)
		error_sender_timeout=$(grep "Sender timed out waiting for receiver fragment instance" $query_log_file | wc -l)

		# unsupported SQL found in the standard TPC-DS queries
		unsupported_analysis_exception=$(grep "AnalysisException" $query_log_file | wc -l)

		# out of memory error happens on queries under heavy load.  Continue with these queries.
		oom=$(grep "Memory limit exceeded" $query_log_file | wc -l)

		#Errors that warrant a retry
		if [[ "$error_state_store" -gt "0" || "$error_connect_timeout" -gt "0" || "$error_communicate_impalad" -gt "0" || "$error_connection_reset" -gt "0" || "$error_connection_refused" -gt "0" || "$error_unreachable_impalad" -gt "0" || "$error_econnreset" -gt "0" || "$error_sender_timeout" -gt "0" ]]; then
			# Wait 5 seconds and try again
			# Print the error message and continue
			if [ "$error_state_store" -gt "0" ]; then
				grep "Waiting for catalog update from the StateStore" $query_log_file
			fi
			if [ "$error_connect_timeout" -gt "0" ]; then
				grep "Error connecting: TTransportException" $query_log_file
			fi
			if [ "$error_communicate_impalad" -gt "0" ]; then
				grep "Error communicating with impalad" $query_log_file
			fi
			if [ "$error_connection_reset" -gt "0" ]; then
				grep "Socket error 104: Connection reset by peer" $query_log_file
			fi
			if [ "$error_connection_refused" -gt "0" ]; then
				grep "Connection refused" $query_log_file
			fi
			if [ "$error_unreachable_impalad" -gt "0" ]; then
				grep "Cancelled due to unreachable impalad" $query_log_file
			fi
			if [ "$error_econnreset" -gt "0" ]; then
				grep "ECONNRESET" $query_log_file
			fi
			if [ "$error_sender_timeout" -gt "0" ]; then
				grep "Sender timed out waiting for receiver fragment instance" $query_log_file
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
				log_status="timeout"
				tuples="0"
				log $tuples $log_status
			else
				run_query="1"
				sleep 5
			fi
		else
			#OOM, unsupported SQL, and terminated 
			if [[ "$oom" -gt "0" || "$unsupported_analysis_exception" -gt "0" || "$myoutput" -eq "143" ]]; then
				if [ "$oom" -gt "0" ]; then
					log_status="oom"
					cat $query_log_file
				else 
					if [ "$unsupported_analysis_exception" -gt "0" ]; then
						log_status="error"
						cat $query_log_file
					else 
						if [ "$myoutput" == "143" ]; then
							log_status="timeout"
						fi
					fi
				fi

				tuples="0"
				run_query="0"
				log $tuples $log_status
			else
				tuples=$(cat $query_log_file | wc -l)
				run_query="0"
				log_status="success"
				log $tuples $log_status
			fi
		fi
	done
done

end_step $step
