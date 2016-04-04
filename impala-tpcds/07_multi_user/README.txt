./rollout.sh > rollout.log 2>&1 < rollout.log & 
#
## Check the status of the background processes running the TPC-DS queries
./check_status.sh
#
