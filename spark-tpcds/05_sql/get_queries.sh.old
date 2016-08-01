#!/bin/bash
set -e
filename="TPCDS_1_4_Queries.scala"
rm -f $filename
rm -f *.spark.*.sql
wget "https://raw.githubusercontent.com/databricks/spark-sql-perf/master/src/main/scala/com/databricks/spark/sql/perf/tpcds/TPCDS_1_4_Queries.scala"

line1=$(grep -n "runnable" $filename | awk -F ':' '{print $1}')
line1=$((line1+1))
line2=$(grep -n "map(tpcds1_4QueriesMap)" $filename | awk -F ':' '{print $1}')

queries=$(sed -n $line1,$line2"p" $filename | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n/ /g' | awk -F ')' '{print $1}' | sed 's/ //g')
for i in $(echo $queries | sed 's/,/ /g'); do
	
	line1=$(grep -n $i $filename | awk -F ':' '{print $1}' | head -n1)
	line1=$((line1+1))

	line2="0"
	for x in $(grep -n "stripMargin" $filename | awk -F ':' '{print $1}'); do
		line2="$x"
		if [ "$line2" -gt "$line1" ]; then
			break
		fi
	done
	line2=$((line2-1))
	query=$(echo $i | sed -e 's/\"//g')
	if [[ "$query" != "qSsMax" && "$query" != "q39b" ]]; then
		if [ "$query" == "q39a" ]; then
			query="q39"
		fi
		query=$(echo $query | sed -e 's/q//g')
		q=$((query+100))
		new_filename="$q"".spark.$query.sql"
		echo "$i: sed -n $line1,$line2"p" $filename > $new_filename"
		sed -n $line1,$line2"p" $filename > $new_filename
	fi

done

for i in $(ls *.spark.*.sql); do
	echo $i
	sed -i 's/|//' $i
done
