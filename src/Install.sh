#!/bin/bash
# 
# source /etc/os-release
# if [ $ID == "ubuntu" ];then
#     echo "Adicionando mais alguns repositorios"
#     echo "# Ubuntu bionic
#     deb http://archive.ubuntu.com/ubuntu/ focal main restricted
#     deb-src http://archive.ubuntu.com/ubuntu/ focal main restricted
#     deb http://archive.ubuntu.com/ubuntu/ focal-updates main restricted
#     deb-src http://archive.ubuntu.com/ubuntu/ focal-updates main restricted
#     deb http://archive.ubuntu.com/ubuntu/ focal universe
#     deb-src http://archive.ubuntu.com/ubuntu/ focal universe
#     deb http://archive.ubuntu.com/ubuntu/ focal-updates universe
#     deb-src http://archive.ubuntu.com/ubuntu/ focal-updates universe
#     deb http://archive.ubuntu.com/ubuntu/ focal multiverse
#     deb-src http://archive.ubuntu.com/ubuntu/ focal multiverse
#     deb http://archive.ubuntu.com/ubuntu/ focal-updates multiverse
#     deb-src http://archive.ubuntu.com/ubuntu/ focal-updates multiverse
#     deb http://archive.ubuntu.com/ubuntu/ focal-backports main restricted universe multiverse
#     deb-src http://archive.ubuntu.com/ubuntu/ focal-backports main restricted universe multiverse
#     deb http://archive.canonical.com/ubuntu focal partner
#     deb-src http://archive.canonical.com/ubuntu focal partner
#     deb http://security.ubuntu.com/ubuntu/ focal-security main restricted
#     deb-src http://security.ubuntu.com/ubuntu/ focal-security main restricted
#     deb http://security.ubuntu.com/ubuntu/ focal-security universe
#     deb-src http://security.ubuntu.com/ubuntu/ focal-security universe
#     deb http://security.ubuntu.com/ubuntu/ focal-security multiverse
#     deb-src http://security.ubuntu.com/ubuntu/ focal-security multiverse

#     # Ubuntu Bionic
#     deb http://archive.ubuntu.com/ubuntu/ bionic main restricted
#     deb-src http://archive.ubuntu.com/ubuntu/ bionic main restricted
#     deb http://archive.ubuntu.com/ubuntu/ bionic-updates main restricted
#     deb-src http://archive.ubuntu.com/ubuntu/ bionic-updates main restricted
#     deb http://archive.ubuntu.com/ubuntu/ bionic universe
#     deb-src http://archive.ubuntu.com/ubuntu/ bionic universe
#     deb http://archive.ubuntu.com/ubuntu/ bionic-updates universe
#     deb-src http://archive.ubuntu.com/ubuntu/ bionic-updates universe
#     deb http://archive.ubuntu.com/ubuntu/ bionic multiverse
#     deb-src http://archive.ubuntu.com/ubuntu/ bionic multiverse
#     deb http://archive.ubuntu.com/ubuntu/ bionic-updates multiverse
#     deb-src http://archive.ubuntu.com/ubuntu/ bionic-updates multiverse
#     deb http://archive.ubuntu.com/ubuntu/ bionic-backports main restricted universe multiverse
#     deb-src http://archive.ubuntu.com/ubuntu/ bionic-backports main restricted universe multiverse
#     deb http://archive.canonical.com/ubuntu bionic partner
#     deb-src http://archive.canonical.com/ubuntu bionic partner
#     deb http://security.ubuntu.com/ubuntu/ bionic-security main restricted
#     deb-src http://security.ubuntu.com/ubuntu/ bionic-security main restricted
#     deb http://security.ubuntu.com/ubuntu/ bionic-security universe
#     deb-src http://security.ubuntu.com/ubuntu/ bionic-security universe
#     deb http://security.ubuntu.com/ubuntu/ bionic-security multiverse
#     deb-src http://security.ubuntu.com/ubuntu/ bionic-security multiverse

#     # Ubuntu Xenial
#     deb http://archive.ubuntu.com/ubuntu/ xenial main restricted
#     deb-src http://archive.ubuntu.com/ubuntu/ xenial main restricted
#     deb http://archive.ubuntu.com/ubuntu/ xenial-updates main restricted
#     deb-src http://archive.ubuntu.com/ubuntu/ xenial-updates main restricted
#     deb http://archive.ubuntu.com/ubuntu/ xenial universe
#     deb-src http://archive.ubuntu.com/ubuntu/ xenial universe
#     deb http://archive.ubuntu.com/ubuntu/ xenial-updates universe
#     deb-src http://archive.ubuntu.com/ubuntu/ xenial-updates universe
#     deb http://archive.ubuntu.com/ubuntu/ xenial multiverse
#     deb-src http://archive.ubuntu.com/ubuntu/ xenial multiverse
#     deb http://archive.ubuntu.com/ubuntu/ xenial-updates multiverse
#     deb-src http://archive.ubuntu.com/ubuntu/ xenial-updates multiverse
#     deb http://archive.ubuntu.com/ubuntu/ xenial-backports main restricted universe multiverse
#     deb-src http://archive.ubuntu.com/ubuntu/ xenial-backports main restricted universe multiverse
#     deb http://archive.canonical.com/ubuntu xenial partner
#     deb-src http://archive.canonical.com/ubuntu xenial partner
#     deb http://security.ubuntu.com/ubuntu/ xenial-security main restricted
#     deb-src http://security.ubuntu.com/ubuntu/ xenial-security main restricted
#     deb http://security.ubuntu.com/ubuntu/ xenial-security universe
#     deb-src http://security.ubuntu.com/ubuntu/ xenial-security universe
#     deb http://security.ubuntu.com/ubuntu/ xenial-security multiverse
#     deb-src http://security.ubuntu.com/ubuntu/ xenial-security multiverse" >> /tmp/apt_sources.txt
# else
#     echo "# Debian Buster
#     deb http://deb.debian.org/debian buster main non-free contrib
#     deb http://deb.debian.org/debian buster-updates main non-free contrib
#     deb http://security.debian.org/debian-security/ buster/updates main non-free contrib
#     deb http://ftp.debian.org/debian buster-backports main non-free contrib

#     # Debian oldstable
#     deb http://deb.debian.org/debian oldstable main non-free contrib
#     deb http://deb.debian.org/debian oldstable-updates main non-free contrib
#     deb http://security.debian.org/debian-security/ oldstable/updates main non-free contrib
#     deb http://ftp.debian.org/debian oldstable-backports main non-free contrib" >> /tmp/apt_sources.txt
# fi
# cat /etc/apt/sources.list >> /tmp/apt_sources.txt
# sleep 1s
# cat /tmp/apt_sources.txt | sudo tee /etc/apt/sources.list &> /dev/null

# APT
echo "Updating APT Repositories"
sudo apt-get update &>> /home/copiler/Apt-Log.txt
echo "Removing some packages"
sudo apt purge -y *golang* *android* *google* *mysql* *java* *openjdk* &>> /home/copiler/Apt-Log.txt
echo "Installing Essential Packages, This can take time! (Between 2 to 5 Min)"
sudo apt install -y curl
sudo apt install -y dos2unix git zip rsync mkisofs *jansson* libtinfo5 &>> /home/copiler/Apt-Log.txt
if [ $VERSION_ID == '20.04' ];then
    sudo apt -y install $(curl -fsSL https://raw.githubusercontent.com/P3TERX/openwrt-list/master/depends-ubuntu-2004) &>> /home/copiler/Apt-Log.txt
else
    sudo apt -y install $(curl -fsSL https://raw.githubusercontent.com/P3TERX/openwrt-list/master/depends-ubuntu-1804) &>> /home/copiler/Apt-Log.txt
fi
sudo apt -y install $INPUT_MOREPACKAGE

echo "Remove Dotnet (20Gb free)"
apt purge --remove *dotnet* -y
sudo rm -rf /usr/share/dotnet
echo "Sucess"
echo -e "\n---------------------------------\n"
echo 'Remove android sdk (11Gb+ Free)'
sudo rm -rf /usr/local/lib/android
echo "Sucess"
# Autoremove
sudo apt-get -qq autoremove --purge

# Swap
# Remove Swap
echo "Removing Swaps"
sudo swapoff -a
sudo rm -rf /mnt/swap*
echo "Sucess"

# Basic
echo "Creating the Directory for Work in /home/copiler"
sudo mkdir -p /home/copiler
echo "Setting access to $USER"
sudo chown $USER:$GROUPS /home/copiler
sudo chmod 777 /home/copiler/

echo "Defining Some Permissions for the Directory \"bin\""
sudo chown $USER:$GROUPS /mnt
sudo chmod 777 /mnt
echo "Sucess"
exit 0