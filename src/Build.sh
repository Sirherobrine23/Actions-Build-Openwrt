#!/usr/bin/env bash
# importing and exporting settings
export DIR2="$(pwd)"
export uploadssh23="$DIR2/publics/"
echo "Your directory of files for copying is: $DIR2"
echo "Directory for Uploads: $uploadssh23"
echo "Main Directory: $DIR2"
echo '-----------------------------------------------------'
echo "The variables predefined by the User"
echo '*****************************************************'
echo "Compilation repository URL: $INPUT_URL"
echo "BRANCH of the repository: $INPUT_BRANCH"
echo "Feed settings: $INPUT_FEEDS_FILE"
echo "Copilation file: $INPUT_CONFIG"
echo "Customization file P1: $INPUT_P1"
echo "Customization file P2: $INPUT_P2"
echo '*****************************************************'
echo '* Relese Github path ENV:  ${{ env.FIRMWARE_PATH }} *'
echo '* Device Name Github ENV:  ${{ env.DEVICE_NAME }}   *'
echo '* Tag Name Github ENV:     ${{ env.TAG_NAME }}      *'
echo '* Release Name Github ENV: ${{ env.RELEASE_NAME }}  *'
echo '*****************************************************'
mkdir publics/
rm -rf .git*
cp -rf . /home/copiler/
# calling the copilator
clone(){
    git clone --depth 1 $INPUT_URL -b $INPUT_BRANCH /home/copiler/openwrt
    mkdir /home/copiler/openwrt/bin 
    sudo mount --bind /mnt /home/copiler/openwrt/bin && LINKS=1
    if [ $LINKS == '1' ] ;then
        df -hT . 
        df -hT /mnt
    else
        echo 'Erro in to create Link'
        exit 23
    fi
    status1=1
}
p1(){
    if [ -e $INPUT_FEEDS_FILE ];then
        mv $INPUT_FEEDS_FILE openwrt/feeds.conf.default
    fi
    if [ -e "${1}" ];then
        cd /home/copiler/openwrt
        echo "::group::Load custom feeds"
        bash "${1}"
        echo "::endgroup::"
    fi
    cd /home/copiler/
    status2=1
}
update(){
    cd /home/copiler/openwrt 
    ./scripts/feeds update -a
    cd /home/copiler/
    status3=1
}
update_install(){
    cd /home/copiler/openwrt
    ./scripts/feeds install -a
    cd /home/copiler/
    status4=1
}
p2(){
    # [ -e files ] && mv files openwrt/files
    if [ -e $INPUT_CONFIG ];then
        echo "Moving the openwrt build file"
        cat $INPUT_CONFIG | grep -v ^\# | grep  . > openwrt/.config
    else
        echo "No Config file found"
        exit 24
    fi
    if [ -e "${2}" ];then
        cd /home/copiler/openwrt
        echo "::group::Custom Config"
        bash "${2}"
        echo "::endgroup::"
    fi
    cd /home/copiler/
    status5=1
}
make_download(){
    echo "::group::Defconfig and Download"
        cd /home/copiler/openwrt
        make defconfig
        make download -j8
        find dl -size -1024c -exec ls -l {} \;
        find dl -size -1024c -exec rm -f {} \;
        cd /home/copiler/
    echo "::endgroup::"
    status6=1
}
make_copiler(){
    cd /home/copiler/openwrt
    echo -e "$(nproc) thread compile"
        make -j$(nproc) || build1='1'
        if [ $build1 == '1' ];then
        echo "::group::error, rerun, attempt 2"
            make -j1 || build2='1'
        echo "::endgroup::" # Build 2
            if [ $build2 == '1' ];then
            echo "::group::error, rerun, attempt 3"
                make -j1 V=sc || build3=1
                echo "::endgroup::" # Build 3
                if [ $build3 == '1' ];then
                    echo "::group::error, rerun, attempt 4"
                    make -j1 V=sw || build4=1
                    echo "::endgroup::" # Build 4
                    if [ $build4 == '1' ];then
                        echo "Erro In Copiler Configs"
                        exit 255
                    fi
                fi
            # echo "::endgroup::"
            fi
        fi
    cd /home/copiler/
    status7=1
}
final(){
    cd /home/copiler/openwrt/bin/targets/*/* || exit 255
    rm -rf packages
    cp -rf * $uploadssh23
    ln -s /home/copiler/openwrt $DIR2/openwrt
    rm -fvr config.buildinfo config.seed feeds.buildinfo *.manifest *-uImage-lzma.bin *-vmlinux-lzma.elf *-vmlinux.bin *-vmlinux.elf *-vmlinux.lzma version.buildinfo
    cd /home/copiler/
    status8=1
}
final2(){
    cd /home/copiler/openwrt/bin/targets/*/* || exit 255
    echo "FIRMWARE_PATH=$PWD" >> $GITHUB_ENV
    cd /home/copiler/
    cat /home/copiler/openwrt/.config | grep 'CONFIG_TARGET_PROFILE=' | sed 's|CONFIG_TARGET_PROFILE=||g' |sed 's|"||g' > /tmp/DEVICE_NAME
    echo "DEVICE_NAME=$(cat /tmp/DEVICE_NAME)" >> $GITHUB_ENV
    echo "TAG_NAME=$(date +"%Y%m%d%H%M")" >> $GITHUB_ENV
    echo "RELEASE_NAME=$(cat /tmp/DEVICE_NAME)_$(date +"%Y%m%d%H%M")" >> $GITHUB_ENV
    echo "UPLOADTORELEASE=true" >> $GITHUB_ENV
    cd $DIR2
    echo "Build Date: $(date +"%H:%M %d/%m/%Y")" > release.txt
    echo "Build To Device: $(cat /tmp/DEVICE_NAME)" >> release.txt
    echo "Build Branch:  $INPUT_BRANCH" >> release.txt
    echo "Github Branch: $GITHUB_REF" >> release.txt
    # --------------------------------------------------------------------------------------------
    luci_detect=`cat /home/copiler/openwrt/.config|grep -v ^\#|grep -q "CONFIG_PACKAGE_luci=y";echo $?`
    if [ ${luci_detect} == '0' ];then
        LUCI="true"
        echo "With LUCI"
    else 
        LUCI="false"
        echo "Without LUCI"
    fi
    VP1=`cat /home/copiler/openwrt/.config|grep -v ^\#|grep -q "openvpn";echo $?`
    VP2=`cat /home/copiler/openwrt/.config|grep -v ^\#|grep -q "wireguard";echo $?`
    # Detection of VPN protocols
    if [ $VP1 == '0' ];then
        VPN="OpenVPN"
        echo "OpenVPN"
    elif [ $VP2 == '0' ];then
        VPN="Wireguard"
        echo "Wireguard"
    else
        VPN="Not detected"
        echo "Not detected VPN Package"
    fi
    # --------------------------------------------------------------------------------------------
    echo "Includes LUCI: $LUCI" >> release.txt
    echo "Includes VPN: $VPN" >> release.txt
    echo "BODY_PATH=$PWD/release.txt" >> $GITHUB_ENV
}
cd /home/copiler/
if [ $UID == '0' ] ;then
    echo 'root !WARNING!'
    export FORCE_UNSAFE_CONFIGURE=1
fi
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
                                final2
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
