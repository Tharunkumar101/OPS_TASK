#!/bin/bash

a="Start"
b="7"

while [ "$a" != "$b" ]
do
cat <<m
        ---- Select any option ---
➤ start the server               => 1
➤ stop the server                => 2
➤ Exit                           => 3
m

echo ""

read -p "Enter the option: " a
echo""

case $a in

    1)
        if dpkg -s nginx >/dev/null 2>&1; then
            echo "✅ Nginx is already installed."
       
        else
            echo "Nginx is not installed. Installing now..."
            sudo apt update
            sudo apt install nginx -y
        fi
    
        NGROK_CONFIG="$HOME/.ngrok2/ngrok.yml"
        TOKEN_STORE="$HOME/.ngrok_token_store"
        if ! grep -q "authtoken:" "$NGROK_CONFIG" 2>/dev/null; then
            if [ -f "$TOKEN_STORE" ]; then
                echo "📦 Restoring Ngrok AuthToken from local store..."
            
                token=$(cat "$TOKEN_STORE")
                ngrok config add-authtoken "$token"
                echo "✅ AuthToken restored and configured."
            
            else
                echo "🔐 Ngrok AuthToken not found."
                read -p "Enter your Ngrok AuthToken: " token
                echo "$token" > "$TOKEN_STORE"
            
                ngrok config add-authtoken "$token"
                echo "✅ AuthToken saved and configured."
    
            fi
        else
            echo "✅ Ngrok AuthToken already configured."
        fi


        read -p "ENTER THE FILE PATH: " path

    
        sudo lsof -t -i :80 | xargs -r sudo kill -9

    
        echo "🚀 Starting Python HTTP server..."
        sudo python3 -m http.server 80 --bind 0.0.0.0 --directory "$path" > /dev/null 2>&1 &

        sleep 2

   
        echo "🌐 Starting ngrok..."
        nohup ngrok http 80 > /dev/null 2>&1 &

        sleep 5

        NGROK_URL=$(curl -s http://localhost:4040/api/tunnels | grep -o '"public_url":"https:[^"]*' | sed 's/"public_url":"//')

        if [[ -z "$NGROK_URL" ]]; then
            echo "❌ Failed to get Ngrok URL. Is ngrok installed and in PATH?"
        else
            echo "✅ Ngrok Public URL: $NGROK_URL"
        fi
    ;;
    2)
        echo "🛑 Stopping Python HTTP server and Ngrok..."
        sudo pkill -f "python3 -m http.server"
        sudo pkill -f "ngrok"
        echo "✅ All servers stopped."
    ;;
    3)
        echo "👋 Exiting..."
        break
    ;;
    *)
        echo "❌ Invalid option"
    ;;
esac

echo ""
done
