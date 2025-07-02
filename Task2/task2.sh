#!/bin/bash

cmdin=$1
cat <<m
----select any option----
view                => 1
kill                => 2
List All processes  => 3

m
read -p "Enter your option  : " ch

case $ch in
	1)
		pid=$(pidof $1)
		ps -p "$pid" -f
		;;
	2)
		pkill "$1"
		if [ $? -eq 0 ] 
		then
		   echo -e "\n$cmdin was killed"
		else 
		   echo -e "\nenter correct process name"
		fi
		;;

	6)
		ps aux
		;;
	*)
		echo -e "\n just Enter one number (1 to3)"
		;;
esac
