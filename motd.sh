#!/usr/bin/env bash

###########################################
# Created by Dirty Harry for YiiMP use... #
###########################################

source /etc/functions.sh # load our functions
source /etc/yiimpserver.conf

apt_install lsb-release figlet update-motd \
landscape-common update-notifier-common
cd $HOME/yiimpserver/yiimp_single/ubuntu/etc/update-motd.d
sudo rm -r /etc/update-motd.d/
sudo mkdir /etc/update-motd.d/
sudo touch /etc/update-motd.d/00-header ; sudo touch /etc/update-motd.d/10-sysinfo ; sudo touch /etc/update-motd.d/90-footer
sudo chmod +x /etc/update-motd.d/*
sudo cp -r 00-header 10-sysinfo 90-footer /etc/update-motd.d/


cd $HOME/yiimpserver/yiimp_single/ubuntu
# copy additional files
sudo cp -r screens /usr/bin/
sudo chmod +x /usr/bin/screens
sudo cp -r stratum /usr/bin
sudo chmod +x /usr/bin/stratum
sudo cp -r addport /usr/bin
sudo chmod +x /usr/bin/addport
sudo cp -r addport-full /usr/bin
sudo chmod +x /usr/bin/addport-full
sudo cp -r addport-lowdiff /usr/bin
sudo chmod +x /usr/bin/addport-lowdiff
sudo cp -r addport-zenx /usr/bin
sudo chmod +x /usr/bin/addport-zenx
sudo cp -r addport-nicehash /usr/bin
sudo chmod +x /usr/bin/addport-nicehash
echo '
clear
run-parts /etc/update-motd.d/ | sudo tee /etc/motd
' | sudo -E tee /usr/bin/motd >/dev/null 2>&1

sudo chmod +x /usr/bin/motd
cd $HOME/yiimpserver/yiimp_single
