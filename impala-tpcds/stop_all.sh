#!/bin/bash

for i in $(ps -ef | grep rollout | grep -v grep | awk -F ' ' '{print $2}'); do
	echo $i
	kill $i
done

for i in $(ps -ef | grep "test.sh" | grep -v grep | awk -F ' ' '{print $2}'); do
	echo $i
	kill $i
done

for i in $(ps -ef | grep "impala-shell" | grep -v grep | awk -F ' ' '{print $2}'); do
	echo $i
	kill $i
done
