#!/bin/bash
sudo apt-get -qq update &> Apt-Log.txt
sudo apt install -y curl &> Apt-Log.txt
sudo apt -y install dos2unix git zip rsync mkisofs $(curl -fsSL https://raw.githubusercontent.com/P3TERX/openwrt-list/master/depends-ubuntu-2004) &> Apt-Log.txt
sudo apt-get -qq autoremove --purge &> Apt-Log.txt
# Remove Swap
sudo swapoff -a
sudo rm -rfv /mnt/swap*
sudo chown $USER:$USER /mnt
sudo chmod 777 /mnt