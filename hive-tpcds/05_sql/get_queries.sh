#!/bin/bash

rm -f *.sql

base_url="https://raw.githubusercontent.com/hortonworks/hive-testbench/hive14/sample-queries-tpcds/"
for i in $(seq 1 99); do
	filename="$base_url""query""$i"".sql"
	echo $filename
	wget $filename
done

#rename files
#101.tpcds.01.sql
for i in $(ls *.sql); do
	id=$(echo $i | awk -F 'y' '{print $2}' | awk -F '.' '{print $1}')
	id=$(printf "%02d\n" $id)
	order_id="1""$id"
	new_filename="$order_id"".""hive"".""$id"".""sql"	
	echo "mv $i $new_filename"
	mv $i $new_filename
done
