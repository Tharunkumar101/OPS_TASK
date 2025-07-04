#!/bin/bash

Passwd_f="passwords.txt"
Passwd="abcd@1"

check_password() {
    read -sp "Enter Master Password: " input
    echo
    if [[ "$input" != "$Passwd" ]]; then
        echo "❌ Incorrect Master Password!"
        return 1
    fi
    return 0
}

add_password() {
    read -p "Enter Site Name: " site
    read -p "Enter Username: " username
    read -sp "Enter Password: " password
    echo
    echo "$site | $username | $password" >> "$Passwd_f"
    echo "✅ Password saved!"
}

view_passwords() {
    if check_password; then
        echo "🔐 Saved Passwords:"
        if [[ -s "$Passwd_f" ]]; then
            cat "$Passwd_f"
        else
            echo "⚠️ No passwords saved yet."
        fi
    fi
}
search_password() {
    if check_password; then
        read -p "Enter keyword to search: " keyword
        echo "🔍 Matching entries:"
        grep -i "$keyword" "$Passwd_f" || echo "⚠️ No matches found."
    fi
}

update_password() {
    if check_password; then
        read -p "Enter site name to update: " site

        if grep -iq "$site" "$Passwd_f"; then
            echo "🔄 Existing entry:"
            grep -i "$site" "$Passwd_f"

            read -p "Enter new username: " new_user
            read -sp "Enter new password: " new_pass
            echo

            # Remove old entry (case-insensitive match)
            grep -iv "^$site[[:space:]]*|" "$Passwd_f" > temp.txt

            # Add new entry
            echo "$site | $new_user | $new_pass" >> temp.txt

            # Replace original file
            mv temp.txt "$Passwd_f"

            echo "✅ Updated password for $site"
        else
            echo "❌ No entry found for $site"
        fi
    fi
}
delete_password() {
    if check_password; then
        read -p "Enter site name to delete: " site

        if grep -iq "^$site[[:space:]]*|" "$Passwd_f"; then
            echo "🗑️  Matching entry:"
            grep -i "^$site[[:space:]]*|" "$Passwd_f"

            read -p "Are you sure you want to delete this entry? (y/n): " confirm
            if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
                # Delete the entry from the file
                grep -iv "^$site[[:space:]]*|" "$Passwd_f" > temp.txt
                mv temp.txt "$Passwd_f"
                echo "✅ Entry for '$site' deleted."
            else
                echo "❌ Deletion cancelled."
            fi
        else
            echo "⚠️ No entry found for '$site'"
        fi
    fi
}




# Main menu loop
while true; do
cat <<mm

                                    ==============================
                                    🛡️  SIMPLE PASSWORD MANAGER
                                    ==============================
                                    ➤ ➕ Add Password          =>1
                                    ➤ 📄 View All Passwords    =>2
                                    ➤ 🔍 Search Password       =>3
                                    ➤ 🔄 Update Password       =>4
                                    ➤ 🗑️ Delete Password       =>5
                                    ➤ ❌ Exit                  =>6
mm

read -p "Enter the option : " a
echo

case "$a" in
    1) add_password ;;
    2) view_passwords ;;
    3) search_password ;;
    4) update_password ;;
    5) delete_password ;;
    6) echo "👋 Goodbye!"; break ;;
    *) echo "❌ Invalid option. Please try again." ;;
esac
done
