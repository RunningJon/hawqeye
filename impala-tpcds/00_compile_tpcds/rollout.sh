#!/bin/bash
set -e

PWD=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $PWD/../functions.sh

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
	cp $PWD/tools/dsqgen ../*gen_data/
	cp $PWD/tools/dsdgen ../*gen_data/
	cp $PWD/tools/tpcds.idx ../*gen_data/
	cp $PWD/tools/tpcds.idx ../testing/

	#copy the compiled dsdgen program to the datanodes
	for i in $(cat $PWD/../dn.txt); do
		echo "copy tpcds binaries to $i:$ADMIN_HOME"
		scp tools/dsdgen tools/dsqgen tools/tpcds.idx $i:$ADMIN_HOME/
	done
}

copy_queries()
{
	rm -rf $PWD/../*_gen_data/query_templates
	rm -rf $PWD/../testing/query_templates
	cp -R query_templates $PWD/../*_gen_data/
	cp -R query_templates $PWD/../testing/
}

step=compile_tpcds
init_log $step
start_log
schema_name="tpcds_parquet"
table_name="compile"

make_tpc
copy_tpc
copy_queries
log

end_step $step
