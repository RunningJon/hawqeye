## Execute 5 user concurrent test in the background and log to rollout.log
./rollout.sh 3000 5 imp > rollout.log 2>&1 < rollout.log & 
# or with the tpcds option
./rollout.sh 3000 5 tpcds > rollout.log 2>&1 < rollout.log & 
#
## Check the status of the background processes running the TPC-DS queries
./check_status.sh
#
