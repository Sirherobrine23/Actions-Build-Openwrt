#!/bin/bash
# Basic
echo "::group::Dir"
    echo "Criando o Diretorio Para o Trabalho no /home/copiler"
    sudo mkdir -p /home/copiler
    echo "Definindo acesso para $USER"
    sudo chown $USER:$GROUPS /home/copiler
    sudo chmod 777 /home/copiler/
echo "::endgroup::"

# APT
echo "::group::Apt"
    echo "Atualizando Os Repositorios APT"
    sudo apt-get -qq update &> /home/copiler/Apt-Log.txt
    echo "Removendos alguns pacotes"
    sudo apt purge -y *golang* *android* *google* *mysql* *java* *openjdk* &> /home/copiler/Apt-Log.txt
    echo "Instalando Os Pacotes Essenciais, Isso pode demorar!"
    sudo apt install -y curl &> /home/copiler/Apt-Log.txt
    sudo apt -y install dos2unix git zip rsync mkisofs $(curl -fsSL https://raw.githubusercontent.com/P3TERX/openwrt-list/master/depends-ubuntu-2004) &> /home/copiler/Apt-Log.txt
    echo "Pacotes Instalados: dos2unix git zip rsync mkisofs $(curl -fsSL https://raw.githubusercontent.com/P3TERX/openwrt-list/master/depends-ubuntu-2004), e depedencias"
    if [ $INPUT_MOREPACKAGE == '' ];then
        echo "No more Packages"
    else
        echo "Instalando Os Pacotes Adicionais: $INPUT_MOREPACKAGE"
        sudo apt -y install $INPUT_MOREPACKAGE &> /home/copiler/Apt-Log.txt
    fi
    sudo apt-get -qq autoremove --purge &> /home/copiler/Apt-Log.txt
echo "::endgroup::"

echo "::group::removing large directories"
    echo "Remove Dotnet (20Gb free)"
    apt purge --remove *dotnet* -y
    sudo rm -rf /usr/share/dotnet
    echo "Sucess"
    echo 'Remove android sdk (11Gb+ Free)'
    sudo rm -rf /usr/local/lib/android
    echo "Sucess"
echo "::endgroup::"

# Swap
echo "::group::SwapFile"
    # Remove Swap
    echo "Removendo os Swaps"
    sudo swapoff -a
    sudo rm -rf /mnt/swap*
    echo "Sucess"
echo "::endgroup::"
echo "Definindo Algumas Permissões para o diretorio \"bin\""
sudo chown $USER:$GROUPS /mnt
sudo chmod 777 /mnt
echo "Sucess"
exit 0