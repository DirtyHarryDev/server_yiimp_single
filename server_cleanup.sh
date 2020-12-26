#!/usr/bin/env bash

###########################################
# Created by Dirty Harry for YiiMP use... #
###########################################

source /etc/functions.sh
source $STORAGE_ROOT/yiimp/.yiimp.conf
cd $HOME/yiimpserver/yiimp_single

echo -e " Installing cron screens to crontab...$COL_RESET"

(crontab -l 2>/dev/null; echo "@reboot sleep 20 && /home/yiimp-data/yiimp/starts/screens.start.sh") | crontab -
if [[ ("$CoinPort" == "no") ]]; then
(crontab -l 2>/dev/null; echo "@reboot sleep 20 && /home/yiimp-data/yiimp/starts/stratum.start.sh") | crontab -
fi

(crontab -l 2>/dev/null; echo "@reboot source /etc/functions.sh") | crontab -
(crontab -l 2>/dev/null; echo "@reboot source /etc/yiimpserver.conf") | crontab -
sudo cp -r first_boot.sh $STORAGE_ROOT/yiimp/

echo -e "$GREEN Crontab system complete...$COL_RESET"
echo -e " Creating YiiMP Screens startup script...$COL_RESET"

echo '#!/usr/bin/env bash
source /etc/yiimpserver.conf
# Ugly way to remove junk coins from initial YiiMP database on first boot
source $STORAGE_ROOT/yiimp/.yiimp.conf
if [[ ! -e '$STORAGE_ROOT/yiimp/first_boot.sh' ]]; then
echo
else
source $STORAGE_ROOT/yiimp/first_boot.sh
fi
########################################
# Author: Dirty Harry                  #
#                                      #
# Program: yiimp screen startup script #
#                                      #
########################################
sudo chmod 777 $STORAGE_ROOT/yiimp/site/log/.
sudo chmod 777 $STORAGE_ROOT/yiimp/site/log/debug.log
LOG_DIR=$STORAGE_ROOT/yiimp/site/log
CRONS=$STORAGE_ROOT/yiimp/site/crons
screen -dmS main bash $CRONS/main.sh
screen -dmS loop2 bash $CRONS/loop2.sh
screen -dmS blocks bash $CRONS/blocks.sh
screen -dmS debug tail -f $LOG_DIR/debug.log
' | sudo -E tee $STORAGE_ROOT/yiimp/starts/screens.start.sh >/dev/null 2>&1
sudo chmod +x $STORAGE_ROOT/yiimp/starts/screens.start.sh

echo -e " Creating Stratum screens start script...$COL_RESET"

echo '#!/usr/bin/env bash
########################################
# Author: Dirty Harry                  #
#                                      #
# Program: yiimp screen startup script #
#                                      #
########################################
source /etc/yiimpserver.conf
source $STORAGE_ROOT/yiimp/.yiimp.conf
STRATUM_DIR=$STORAGE_ROOT/yiimp/site/stratum
LOG_DIR=$STORAGE_ROOT/yiimp/site/log
screen -dmS c11 bash $STRATUM_DIR/run.sh c11
screen -dmS deep bash $STRATUM_DIR/run.sh deep
screen -dmS x11 bash $STRATUM_DIR/run.sh x11
screen -dmS x11evo bash $STRATUM_DIR/run.sh x11evo
screen -dmS x13 bash $STRATUM_DIR/run.sh x13
screen -dmS x14 bash bash $STRATUM_DIR/run.sh x14
screen -dmS x15 bash $STRATUM_DIR/run.sh x15
screen -dmS x17 bash $STRATUM_DIR/run.sh x17
screen -dmS xevan bash $STRATUM_DIR/run.sh xevan
screen -dmS timetravel bash $STRATUM_DIR/run.sh timetravel
screen -dmS bitcore bash $STRATUM_DIR/run.sh bitcore
screen -dmS hmq1725 bash $STRATUM_DIR/run.sh hmq1725
screen -dmS tribus bash $STRATUM_DIR/run.sh tribus
screen -dmS sha bash $STRATUM_DIR/run.sh sha
screen -dmS sha256t bash $STRATUM_DIR/run.sh sha256t
screen -dmS scrypt bash $STRATUM_DIR/run.sh scrypt
screen -dmS scryptn bash $STRATUM_DIR/run.sh scryptn
screen -dmS luffa bash $STRATUM_DIR/run.sh luffa
screen -dmS neo bash $STRATUM_DIR/run.sh neo
screen -dmS nist5 bash $STRATUM_DIR/run.sh nist5
screen -dmS penta bash $STRATUM_DIR/run.sh penta
screen -dmS quark bash $STRATUM_DIR/run.sh quark
screen -dmS qubit bash $STRATUM_DIR/run.sh qubit
screen -dmS jha bash $STRATUM_DIR/run.sh jha
screen -dmS dmd-gr bash $STRATUM_DIR/run.sh dmd-gr
screen -dmS myr-gr bash $STRATUM_DIR/run.sh myr-gr
screen -dmS lbry bash $STRATUM_DIR/run.sh lbry
screen -dmS lyra2 bash $STRATUM_DIR/run.sh lyra2
screen -dmS lyra2v2 bash $STRATUM_DIR/run.sh lyra2v2
screen -dmS zero bash $STRATUM_DIR/run.sh lyra2z
screen -dmS blakecoin bash $STRATUM_DIR/run.sh blakecoin # blake 8
screen -dmS blake bash $STRATUM_DIR/run.sh blake
screen -dmS blake2s bash $STRATUM_DIR/run.sh blake2s
screen -dmS vanilla bash $STRATUM_DIR/run.sh vanilla # blake 8
screen -dmS decred bash $STRATUM_DIR/run.sh decred # blake 14
screen -dmS keccak bash $STRATUM_DIR/run.sh keccak
screen -dmS whirlpool bash $STRATUM_DIR/run.sh whirlpool
screen -dmS skein bash $STRATUM_DIR/run.sh skein
screen -dmS skein2 bash $STRATUM_DIR/run.sh skein2
screen -dmS yescrypt bash $STRATUM_DIR/run.sh yescrypt
screen -dmS zr5 bash $STRATUM_DIR/run.sh zr5
screen -dmS sib bash $STRATUM_DIR/run.sh sib
screen -dmS m7m sudo bash $STRATUM_DIR/run.sh m7m
screen -dmS veltor bash $STRATUM_DIR/run.sh veltor
screen -dmS velvet bash $STRATUM_DIR/run.sh velvet
screen -dmS argon2 bash $STRATUM_DIR/run.sh argon2
screen -dmS groestl bash $STRATUM_DIR/run.sh groestl
screen -dmS skunk bash $STRATUM_DIR/run.sh skunk
screen -dmS phi1612 bash $STRATUM_DIR/run.sh phi1612
screen -dmS hsr bash $STRATUM_DIR/run.sh hsr
screen -dmS yescryptr16 bash $STRATUM_DIR/run.sh yescryptr16
screen -dmS x16r bash $STRATUM_DIR/run.sh x16r
screen -dmS x16rv2 bash $STRATUM_DIR/run.sh x16rv2
screen -dmS balloon bash $STRATUM_DIR/run_zenx.sh balloon
' | sudo -E tee $STORAGE_ROOT/yiimp/starts/stratum.start.sh >/dev/null 2>&1
sudo chmod +x $STORAGE_ROOT/yiimp/starts/stratum.start.sh

echo '
source /etc/yiimpserver.conf
source $STORAGE_ROOT/yiimp/.yiimp.conf
LOG_DIR=$STORAGE_ROOT/yiimp/site/log
CRONS=$STORAGE_ROOT/yiimp/site/crons
STRATUM_DIR=$STORAGE_ROOT/yiimp/site/stratum
' | sudo -E tee $STORAGE_ROOT/yiimp/.prescreens.start.conf >/dev/null 2>&1

echo "source /etc/yiimpserver.conf" | hide_output tee -a ~/.bashrc
echo "source $STORAGE_ROOT/yiimp/.prescreens.start.conf" | hide_output tee -a ~/.bashrc
echo -e "$GREEN YiiMP Screens added...$COL_RESET"

sudo rm -r $STORAGE_ROOT/yiimp/yiimp_setup
cd $HOME/yiimpserver/yiimp_single
