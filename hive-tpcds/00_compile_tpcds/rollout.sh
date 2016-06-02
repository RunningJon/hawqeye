#!/bin/bash
set -e

PWD=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $PWD/../functions.sh
source $PWD/../tpcds-env.sh

make_tpc()
{
	#compile the tools
	cd $PWD/tools
	rm -f *.o
	make
	chmod 755 dsdgen
	chmod 755 dsqgen
	cd ..
}

copy_tpc()
{
	cp $PWD/tools/tpcds.idx ../*gen_data/

	#copy the compiled dsdgen program to the datanodes
	for i in $(cat $PWD/../dn.txt); do
		echo "copy tpcds binaries to $i:$ADMIN_HOME"
		scp tools/dsdgen tools/tpcds.idx $i:$ADMIN_HOME/
	done
}

step=compile_tpcds
init_log $step
start_log
schema_name="$TPCDS_DBNAME"
table_name="compile"

make_tpc
copy_tpc
log

end_step $step
