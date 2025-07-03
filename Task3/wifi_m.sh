#!/bin/bash

a="Start"
b="7"

while [ "$a" != "$b" ]
do

cat <<m
---- Select any option ---
➤ Turn Wi-Fi ON                     => 1
➤ Turn Wi-Fi OFF                    => 2
➤ View all available Wi-Fi          => 3
➤ Connect to a Wi-Fi Network        => 4
➤ Check Wi-Fi Connection Info       => 5
➤ Check if Wi-Fi Device is Detected => 6
➤ Exit                              => 7
m

echo ""

read -p "Enter the option: " a

case $a in
    1)
        echo "Turn Wi-Fi ON"
        nmcli radio wifi on
        ;;
    2)
        echo "Turn Wi-Fi OFF"
        nmcli radio wifi off
        ;;
    3)
       wifi_status=$(nmcli radio wifi)
       if [ "$wifi_status" = "enabled" ]; then
       echo "Wi-Fi is Enable"
       echo "View all available Wi-Fi"
       nmcli device wifi list
       else
       echo "Wi-Fi is Disabled"
       echo "Turn Wi-Fi ON"

       fi
        ;;
    4)
        echo "Connect to a Wi-Fi Network"
        read -p "Enter the Wi-Fi Name: " WiFi_Name
        read -sp "Enter the Wi-Fi Password: " WiFi_Password
        echo ""
        nmcli device wifi connect "$WiFi_Name" password "$WiFi_Password"
        ;;
    5)
        echo "Check Wi-Fi Connection Info" 
        nmcli connection show
        ;;
    6)
        echo "Wi-Fi Device Detected"
        nmcli device
        ;;
    7)
        echo "Exiting..."
        break
        ;;
    *)
        echo "Invalid option"
        ;;
esac

echo ""
done

