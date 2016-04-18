#!/bin/bash
set -e
PWD=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

source $PWD/tpcds-env.sh

for i in $(ps -ef | grep impala-shell | grep -v grep | awk -F ' ' '{print $2}'); do
        duration=$(ps -p $i -oetime= | tr '-' ':' | awk -F: '{ total=0; m=1; } { for (i=0; i < NF; i++) {total += $(NF-i)*m; m *= i >= 2 ? 24 : 60 }} {print total}')
        if [ "$duration" -ge "$LONG_RUNNING_TIMEOUT" ]; then
                echo "duration: $duration so killing $i"
                echo "process details:"
                ps -ef | grep impala-shell | grep $i | grep -v grep
                kill $i
        fi
done
