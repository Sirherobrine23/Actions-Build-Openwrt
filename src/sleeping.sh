#!/bin/bash
#
ngrok authtoken "$2"
screen -dm ngrok http 80
sleep 50s
count="$1"
while ! [[ ${count} == '0' ]]
do
    echo "Ngrok Url: $(curl -s localhost:4040/api/tunnels | jq -r '.tunnels[0].public_url')"
    echo "Ngrok Url: $(curl -s localhost:4040/api/tunnels | jq -r '.tunnels[1].public_url')"
    count=$((${count} - 1))
    echo ${count} Seconds
    sleep 1s
done
exit 0