#!/usr/bin/env python3

import os

def prt(cmd):
    os.system(cmd)

def wifi_menu():
    a = "Start"
    b = "7"

    while a != b:
        print("""
                           ---- Select any option ---
                    ➤📶 Turn Wi-Fi ON                       => 1
                    ➤📴 Turn Wi-Fi OFF                      => 2
                    ➤🔍 view all available Wi-Fi            => 3
                    ➤🌐 Connect to a Wi-Fi Network          => 4         
                    ➤📊 Check Wi-Fi Connection Info         => 5
                    ➤📊 Check if Wi-Fi Device is Detected   => 6
                    ➤ Exit                                  => 7
               """)

        a = input("Enter the option: ")

        if a == "1":
            print("Turn Wi-Fi ON")
            prt("nmcli radio wifi on 🤙")

        elif a == "2":
            print("Turn Wi-Fi OFF")
            prt("nmcli radio wifi off")

        elif a == "3":
            wifi_status = os.popen("nmcli radio wifi").read().strip()
            if wifi_status.lower() == "enabled":
                print("Wi-Fi is Enabled\nView all available Wi-Fi:")
                prt("nmcli device wifi list")
            else:
                print("Wi-Fi is Disabled\nTurn Wi-Fi ON")

        elif a == "4":
            print("Connect to a Wi-Fi Network")
            wifi_name = input("Enter the Wi-Fi Name: ")
            wifi_password = input("Enter the Wi-Fi Password: ")
            prt(f'nmcli device wifi connect "{wifi_name}" password "{wifi_password}"')
            print("Wi-Fi Is Connected 🤙")

        elif a == "5":
            print("Check Wi-Fi Connection Info")
            prt("nmcli connection show")

        elif a == "6":
            print("Wi-Fi Device Detected")
            prt("nmcli device")

        elif a == "7":
            print("Exiting...")
            break

        else:
            print("Invalid option")

        print()

if __name__ == "__main__":
    wifi_menu()
