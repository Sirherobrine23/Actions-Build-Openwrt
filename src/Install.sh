#!/bin/bash
echo "Criando o Diretorio Para o Trabalho no /home/copiler"
sudo mkdir -p /home/copiler
echo "Definindo acesso para $USER"
sudo chown $USER:$GROUPS /home/copiler
sudo chmod 777 /home/copiler/
echo "Atualizando Os Repositorios APT"
sudo apt-get -qq update &> /home/copiler/Apt-Log.txt
echo "Removendos alguns pacotes"
sudo apt purge -y *golang* *android* *google* *mysql* *java* *openjdk* &> /home/copiler/Apt-Log.txt
echo "Instalando Os Pacotes Essenciais, Isso pode demorar!"
sudo apt install -y curl &> /home/copiler/Apt-Log.txt
sudo apt -y install dos2unix git zip rsync mkisofs  $(curl -fsSL https://raw.githubusercontent.com/P3TERX/openwrt-list/master/depends-ubuntu-2004) &> /home/copiler/Apt-Log.txt
echo "Pacotes Instalados: dos2unix git zip rsync mkisofs  $(curl -fsSL https://raw.githubusercontent.com/P3TERX/openwrt-list/master/depends-ubuntu-2004)"
if [ -z $INPUT_MOREPACKAGE ];then
    echo "Instalando Os Pacotes Adicionais: $INPUT_MOREPACKAGE"
    sudo apt -y install $INPUT_MOREPACKAGE &> /home/copiler/Apt-Log.txt
fi
sudo apt-get -qq autoremove --purge &> /home/copiler/Apt-Log.txt
# Remove Swap
echo "Removendo os Swaps"
sudo swapoff -a
sudo rm -rfv /mnt/swap*
echo "Definindo Algumas Permissões para o diretorio \"bin\""
sudo chown $USER:$GROUPS /mnt
sudo chmod 777 /mnt