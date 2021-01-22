#!/bin/bash
set -x
#
# Remove Swap
echo "Removing Swaps"
sudo swapoff -a
sudo rm -rf /mnt/swap*
#
# Basic
echo "Creating the Directory for Work in /home/copiler"
sudo mkdir -p /home/copiler
echo "Setting access to $USER"
sudo chown $USER:$GROUPS /home/copiler
sudo chmod 777 /home/copiler/
#
echo "Defining Some Permissions for the Directory \"bin\""
sudo chown $USER:$GROUPS /mnt
sudo chmod 777 /mnt
echo "Sucess"
#
# 
# APT
export debian_frontend=noninteractive
echo "Updating APT Repositories"
sudo apt update &>> /home/copiler/Apt-Log.txt
echo "Removing some packages"
sudo apt purge -y *golang* *android* *google* *mysql* *java* *openjdk* &>> /home/copiler/Apt-Log.txt
echo "Installing Essential Packages, This can take time! (Between 2 to 5 Min)"
sudo apt install -y curl
sudo apt install -y dos2unix git zip rsync mkisofs *jansson* libtinfo5 &>> /home/copiler/Apt-Log.txt
source /etc/os-release
if [ $VERSION_ID == '20.04' ];then
    sudo apt -y install $(curl -fsSL https://raw.githubusercontent.com/P3TERX/openwrt-list/master/depends-ubuntu-2004) &>> /home/copiler/Apt-Log.txt
else
    sudo apt -y install $(curl -fsSL https://raw.githubusercontent.com/P3TERX/openwrt-list/master/depends-ubuntu-1804) &>> /home/copiler/Apt-Log.txt
fi
echo -e '\n-------- Additional Packages --------\n'
for Other_install in $INPUT_MOREPACKAGE
do
    sudo apt -y install $Other_install
    echo -e "\n--------- $Other_install ---------\n"
done
echo "Remove Dotnet (20Gb free)"
apt purge --remove *dotnet* -y
sudo rm -rf /usr/share/dotnet
echo "Sucess"
echo -e "\n---------------------------------\n"
echo 'Remove android sdk (11Gb+ Free)'
sudo rm -rf /usr/local/lib/android
echo "Sucess"
# Autoremove

wget "https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip" -O /tmp/nk.zip
sudo unzip -o /tmp/nk.zip -d /usr/bin/
rm /tmp/nk.zip -f

sudo apt install -y nginx

echo "server {
	listen 80 default_server;
	listen [::]:80 default_server;
	root /home/copiler;
	index index.html;
	server_name _;
	location / {
		autoindex on;
	}
}" | sudo tee /etc/nginx/sites-available/default
service nginx restart

ngrok authtoken $INPUT_NGROK_TOKEN
screen -dm ngrok http 80

sleep 35s

echo "Ngrok Url: $(curl -s localhost:4040/api/tunnels | jq -r '.tunnels[1].public_url'), $(curl -s localhost:4040/api/tunnels | jq -r '.tunnels[0].public_url')"

sudo apt-get -qq autoremove --purge &>> /dev/null
#
# echo "Sucess"
#
exit 0