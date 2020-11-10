#!/usr/bin/env bash
[ $EUID != 0 ] && {
    SUDO=sudo
    echo -e "${INFO} You may need to enter a password to authorize."
}
$SUDO echo || exit 1
$SUDO apt-get -qq update &> Apt-Log.txt
$SUDO apt install -y curl &> Apt-Log.txt
$SUDO apt -y install dos2unix git zip rsync mkisofs $(curl -fsSL https://raw.githubusercontent.com/P3TERX/openwrt-list/master/depends-ubuntu-2004) &> Apt-Log.txt
$SUDO apt-get -qq autoremove --purge &> Apt-Log.txt
# Remove Swap
$SUDO swapoff -a
$SUDO rm -rfv /mnt/swap*
$SUDO chown $USER:$USER /mnt
$SUDO chmod 777 /mnt