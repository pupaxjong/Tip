#!/bin/bash


echo
echo "ex) $0        : 1 second loop"
echo "ex) $0 xxx 10 : 'xxx' 10 second loop"
echo

echo $1 : $2 second loop start.

while true; do
DATE=$(date '+%y/%m/%d %H:%M:%S');
echo $DATE  `ps -eo size,pid,user,command --sort -size | awk '{ hr=$1/1024 ; printf("%13.2f Mb ",hr) } { for ( x=4 ; x<=NF ; x++ ) { printf("%s ",$x) } print "" }' |    cut -d "" -f2 | cut -d "-" -f1 | grep $1 | grep -v grep`;
free -m | grep -v Swap;
echo "";
sleep $2; done
