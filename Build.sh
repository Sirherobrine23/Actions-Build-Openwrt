#!/usr/bin/env bash
# importando e exportando as configurações
export DIR2="$(pwd)"
sudo mkdir /home/copiler/
sudo chmod 777 /home/copiler/
sudo chown $USER:$USER /home/copiler
export uploadssh23="$DIR2/publics/"
echo "Seu diretorio dos arquivos para copilação é: $DIR2"
echo "Diretorio para Uploads: $uploadssh23"
echo "Diretorio Principal: $DIR2"
echo '-----------------------------------------------------'
echo "As variaveis pré-definidas pelo Usuario"
echo '*****************************************************'
echo "URL do repositorio de copilação: $URL"
echo "BRANCH do repositorio: $BRANCH"
echo "Configurações do feed: $FEEDS_FILE"
echo "Arquivo da copilação: $CONFIG"
echo "Arquivo de custumização P1: $P1"
echo "Arquivo de custumização P2: $P2"
echo '*****************************************************'
echo '* Relese Github path ENV:  ${{ env.FIRMWARE_PATH }} *'
echo '* Device Name Github ENV:  ${{ env.DEVICE_NAME }}   *'
echo '* Tag Name Github ENV:     ${{ env.TAG_NAME }}      *'
echo '* Release Name Github ENV: ${{ env.RELEASE_NAME }}  *'
echo '*****************************************************'
mkdir publics/
rm -rf .git*
cp -rf . /home/copiler/
# chamando o copilador
cd /home/copiler/
if [ $UID == '0' ] ;then
    echo 'root !WARNING!'
    export FORCE_UNSAFE_CONFIGURE=1
fi
clone(){
    git clone --depth 1 $URL -b $BRANCH /home/copiler/openwrt && \
    if ! ln -s /mnt /home/copiler/openwrt/bin ;then
        echo "14Gb free to bin files" 
    else
        echo 'Erro in to mount --bind'
        exit 23
    fi
    df -hT . && df -tT /mnt
    status1=1
}
p1(){
    [ -e $FEEDS_FILE ] && mv $FEEDS_FILE openwrt/feeds.conf.default
    chmod +x /home/copiler/$P1
    cd /home/copiler/openwrt
    /home/copiler/$P1
    cd /home/copiler/
    status2=1
}
update(){
    cd /home/copiler/openwrt 
    ./scripts/feeds update -a &> /home/copiler/log_update.txt
    cd /home/copiler/
    status3=1
}
update_install(){
    cd /home/copiler/openwrt
    ./scripts/feeds install -a &> /home/copiler/log_install.txt
    cd /home/copiler/
    status4=1
}
p2(){
    [ -e files ] && mv files openwrt/files
    [ -e $CONFIG ] && mv $CONFIG openwrt/.config
    chmod +x /home/copiler/$P2
    cd /home/copiler/openwrt
    /home/copiler/$P2
    cd /home/copiler/
    status5=1
}
make_download(){
    cd /home/copiler/openwrt
    make defconfig
    make download -j8
    find dl -size -1024c -exec ls -l {} \;
    find dl -size -1024c -exec rm -f {} \;
    cd /home/copiler/
    status6=1
}
make_copiler(){
    cd /home/copiler/openwrt
    echo -e "$(nproc) thread compile"
    make -j$(nproc) || build1='1'
        if [ $build1 == '1' ];then
            make -j1 || build2='1'
            if [ $build2 == '1' ];then
                make -j1 V=s
            fi
        fi
    cd /home/copiler/
    status7=1
}
final(){
    cd /home/copiler/openwrt/bin/targets/*/*
    rm -rfv packages
    cp -rfv * $uploadssh23
    ln -s /home/copiler/openwrt $DIR2/openwrt
    status8=1
}
# status1-8=1
clone 
if [ $status1 == '1' ];then
    p1
    if [ $status2 == '1' ];then
        update
        if [ $status3 == '1' ];then
            update_install 
            if [ $status4 == '1' ];then
                p2
                if [ $status5 == '1' ];then
                    make_download
                    if [ $status6 == '1' ];then
                        make_copiler
                        if [ $status7 == '1' ];then
                            final
                            if [ $status8 == '1' ];then
                                echo "FIRMWARE_PATH=$PWD" >> $GITHUB_ENV
                                cd /home/copiler/
                                grep '^CONFIG_TARGET.*DEVICE.*=y' .config | sed -r 's/.*DEVICE_(.*)=y/\1/' > DEVICE_NAME
                                echo "DEVICE_NAME=$(cat DEVICE_NAME)" >> $GITHUB_ENV
                                echo "TAG_NAME=$(date +"%Y%m%d%H%M")" >> $GITHUB_ENV
                                echo "RELEASE_NAME=$(cat DEVICE_NAME)_$(date +"%Y%m%d%H%M")" >> $GITHUB_ENV
                                echo "UPLOADTORELEASE=true" >> $GITHUB_ENV
                                exit 0
                            else
                                exit 134
                            fi
                        else
                            exit 133
                        fi
                    else
                        exit 132
                    fi
                else
                    exit 131
                fi
            else
                exit 130
            fi
        else
            exit 129
        fi
    else
     exit 128
    fi
else
    exit 127
fi
