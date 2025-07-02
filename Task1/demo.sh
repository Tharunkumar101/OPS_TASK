#!/bin/bash


cat <<m 
Opctions :

Download all Image        => 1
Download specific Image   => 2

m
Pass=0
Fail=0
echo " "
read -p "Enter Your Option :" ch
list_n=$(wc -l image.csv)
case $ch in
	1)
	    while read -r line; do
	    wget -P /home/tharunkumar/Desktop/Task/Task1 "$line" &>> d.log
	    if [ $? -eq 0 ]
            then
               echo "Downloaded"
		((Pass++))
            else
               echo "Wrong Url"
		 ((Fail++))
            fi 
	      done < image.csv
	      echo -e "\nTotal Downloaded Image :$Pass     Total broken url :$Fail \n"
	      ;;
	2)
	    read -p "Enter the specific image number (1 to $list_n)  :" spe
	    Sline=$( head -n "$spe" imageu.csv | tail -n 1 )
	    wget -P /home/tharunkumar/Desktop/Task/Task1 "$Sline" &>> d.log
            if [ $? -eq 0 ]
            then
	     echo " Image is saved "
	    else
             echo "Scheck the url and internet"
            fi
	    ;;
	*)
        echo "Invalid option"
        ;;esac
