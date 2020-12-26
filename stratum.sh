#!/usr/bin/env bash

###########################################
# Created by Dirty Harry for YiiMP use... #
###########################################

source /etc/functions.sh
source $STORAGE_ROOT/yiimp/.yiimp.conf
source $HOME/yiimpserver/yiimp_single/.wireguard.install.cnf

echo -e " Building blocknotify and stratum...$COL_RESET"

cd $STORAGE_ROOT/yiimp/yiimp_setup/yiimp
cd $STORAGE_ROOT/yiimp/yiimp_setup/yiimp/blocknotify
blckntifypass=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`
sudo sed -i 's/tu8tu5/'${blckntifypass}'/' blocknotify.cpp
hide_output sudo make
cd $STORAGE_ROOT/yiimp/yiimp_setup/yiimp/stratum/iniparser
hide_output sudo make
cd $STORAGE_ROOT/yiimp/yiimp_setup/yiimp/stratum
if [[ ("$AutoExchange" == "yes") ]]; then
sudo sed -i 's/CFLAGS += -DNO_EXCHANGE/#CFLAGS += -DNO_EXCHANGE/' $STORAGE_ROOT/yiimp/yiimp_setup/yiimp/stratum/Makefile
fi
hide_output sudo make

cd $STORAGE_ROOT/yiimp/yiimp_setup/yiimp/stratum-full/iniparser
hide_output sudo make
cd $STORAGE_ROOT/yiimp/yiimp_setup/yiimp/stratum-full
if [[ ("$AutoExchange" == "yes") ]]; then
sudo sed -i 's/CFLAGS += -DNO_EXCHANGE/#CFLAGS += -DNO_EXCHANGE/' $STORAGE_ROOT/yiimp/yiimp_setup/yiimp/stratum-full/Makefile
fi
hide_output sudo make

cd $STORAGE_ROOT/yiimp/yiimp_setup/yiimp/stratum-lowdiff/iniparser
hide_output sudo make
cd $STORAGE_ROOT/yiimp/yiimp_setup/yiimp/stratum-lowdiff
if [[ ("$AutoExchange" == "yes") ]]; then
sudo sed -i 's/CFLAGS += -DNO_EXCHANGE/#CFLAGS += -DNO_EXCHANGE/' $STORAGE_ROOT/yiimp/yiimp_setup/yiimp/stratum-lowdiff/Makefile
fi
hide_output sudo make

cd $STORAGE_ROOT/yiimp/yiimp_setup/yiimp/stratum-zenx/iniparser
hide_output sudo make
cd $STORAGE_ROOT/yiimp/yiimp_setup/yiimp/stratum-zenx
if [[ ("$AutoExchange" == "yes") ]]; then
sudo sed -i 's/CFLAGS += -DNO_EXCHANGE/#CFLAGS += -DNO_EXCHANGE/' $STORAGE_ROOT/yiimp/yiimp_setup/yiimp/stratum-zenx/Makefile
fi
hide_output sudo make

echo -e " Building stratum folder structure and copying files...$COL_RESET"
cd $STORAGE_ROOT/yiimp/yiimp_setup/yiimp/stratum
sudo cp -a config.sample/. $STORAGE_ROOT/yiimp/site/stratum/config
sudo cp -r stratum $STORAGE_ROOT/yiimp/site/stratum
sudo cp -r run.sh $STORAGE_ROOT/yiimp/site/stratum

cd $STORAGE_ROOT/yiimp/yiimp_setup/yiimp/stratum-full
sudo mv stratum $STORAGE_ROOT/yiimp/site/stratum/stratum_full
sudo mv run.sh $STORAGE_ROOT/yiimp/site/stratum/run_full.sh

cd $STORAGE_ROOT/yiimp/yiimp_setup/yiimp/stratum-lowdiff
sudo mv stratum $STORAGE_ROOT/yiimp/site/stratum/stratum_lowdiff
sudo mv run.sh $STORAGE_ROOT/yiimp/site/stratum/run_lowdiff.sh

cd $STORAGE_ROOT/yiimp/yiimp_setup/yiimp/stratum-zenx
sudo mv stratum $STORAGE_ROOT/yiimp/site/stratum/stratum_zenx
sudo mv run.sh $STORAGE_ROOT/yiimp/site/stratum/run_zenx.sh

cd $STORAGE_ROOT/yiimp/yiimp_setup/yiimp
sudo cp -r $STORAGE_ROOT/yiimp/yiimp_setup/yiimp/blocknotify/blocknotify $STORAGE_ROOT/yiimp/site/stratum
sudo cp -r $STORAGE_ROOT/yiimp/yiimp_setup/yiimp/blocknotify/blocknotify /usr/bin

sudo rm -r $STORAGE_ROOT/yiimp/site/stratum/config/run.sh
echo '#!/usr/bin/env bash
source /etc/yiimpserver.conf
source $STORAGE_ROOT/yiimp/.yiimp.conf
ulimit -n 10240
ulimit -u 10240
cd '""''"${STORAGE_ROOT}"''""'/yiimp/site/stratum
while true; do
./stratum config/$1
sleep 2
done
exec bash' | sudo -E tee $STORAGE_ROOT/yiimp/site/stratum/config/run.sh >/dev/null 2>&1
sudo chmod +x $STORAGE_ROOT/yiimp/site/stratum/config/run.sh

echo '#!/usr/bin/env bash
source /etc/yiimpserver.conf
source $STORAGE_ROOT/yiimp/.yiimp.conf
ulimit -n 10240
ulimit -u 10240
cd '""''"${STORAGE_ROOT}"''""'/yiimp/site/stratum
while true; do
./stratum_full config/$1
sleep 2
done
exec bash' | sudo -E tee $STORAGE_ROOT/yiimp/site/stratum/config/run_full.sh >/dev/null 2>&1
sudo chmod +x $STORAGE_ROOT/yiimp/site/stratum/config/run_full.sh

echo '#!/usr/bin/env bash
source /etc/yiimpserver.conf
source $STORAGE_ROOT/yiimp/.yiimp.conf
ulimit -n 10240
ulimit -u 10240
cd '""''"${STORAGE_ROOT}"''""'/yiimp/site/stratum
while true; do
./stratum_lowdiff config/$1
sleep 2
done
exec bash' | sudo -E tee $STORAGE_ROOT/yiimp/site/stratum/config/run_lowdiff.sh >/dev/null 2>&1
sudo chmod +x $STORAGE_ROOT/yiimp/site/stratum/config/run_lowdiff.sh

echo '#!/usr/bin/env bash
source /etc/yiimpserver.conf
source $STORAGE_ROOT/yiimp/.yiimp.conf
ulimit -n 10240
ulimit -u 10240
cd '""''"${STORAGE_ROOT}"''""'/yiimp/site/stratum
while true; do
./stratum_zenx config/$1
sleep 2
done
exec bash' | sudo -E tee $STORAGE_ROOT/yiimp/site/stratum/config/run_zenx.sh >/dev/null 2>&1
sudo chmod +x $STORAGE_ROOT/yiimp/site/stratum/config/run_zenx.sh

sudo rm -r $STORAGE_ROOT/yiimp/site/stratum/run.sh
echo '#!/usr/bin/env bash
source /etc/yiimpserver.conf
source $STORAGE_ROOT/yiimp/.yiimp.conf
cd '""''"${STORAGE_ROOT}"''""'/yiimp/site/stratum/config/ && ./run.sh $*
' | sudo -E tee $STORAGE_ROOT/yiimp/site/stratum/run.sh >/dev/null 2>&1
sudo chmod +x $STORAGE_ROOT/yiimp/site/stratum/run.sh

sudo rm -r $STORAGE_ROOT/yiimp/site/stratum/run_full.sh
echo '#!/usr/bin/env bash
source /etc/yiimpserver.conf
source $STORAGE_ROOT/yiimp/.yiimp.conf
cd '""''"${STORAGE_ROOT}"''""'/yiimp/site/stratum/config/ && ./run_full.sh $*
' | sudo -E tee $STORAGE_ROOT/yiimp/site/stratum/run_full.sh >/dev/null 2>&1
sudo chmod +x $STORAGE_ROOT/yiimp/site/stratum/run_full.sh

sudo rm -r $STORAGE_ROOT/yiimp/site/stratum/run_lowdiff.sh
echo '#!/usr/bin/env bash
source /etc/yiimpserver.conf
source $STORAGE_ROOT/yiimp/.yiimp.conf
cd '""''"${STORAGE_ROOT}"''""'/yiimp/site/stratum/config/ && ./run_lowdiff.sh $*
' | sudo -E tee $STORAGE_ROOT/yiimp/site/stratum/run_lowdiff.sh >/dev/null 2>&1
sudo chmod +x $STORAGE_ROOT/yiimp/site/stratum/run_lowdiff.sh

sudo rm -r $STORAGE_ROOT/yiimp/site/stratum/run_zenx.sh
echo '#!/usr/bin/env bash
source /etc/yiimpserver.conf
source $STORAGE_ROOT/yiimp/.yiimp.conf
cd '""''"${STORAGE_ROOT}"''""'/yiimp/site/stratum/config/ && ./run_zenx.sh $*
' | sudo -E tee $STORAGE_ROOT/yiimp/site/stratum/run_zenx.sh >/dev/null 2>&1
sudo chmod +x $STORAGE_ROOT/yiimp/site/stratum/run_zenx.sh

echo -e " Updating stratum config files with database connection info...$COL_RESET"
cd $STORAGE_ROOT/yiimp/site/stratum/config

sudo sed -i 's/password = tu8tu5/password = '${blckntifypass}'/g' *.conf
sudo sed -i 's/server = yaamp.com/server = '${StratumURL}'/g' *.conf
if [[ ("$wireguard" == "true") ]]; then
  sudo sed -i 's/host = yaampdb/host = '${DBInternalIP}'/g' *.conf
else
sudo sed -i 's/host = yaampdb/host = localhost/g' *.conf
fi
sudo sed -i 's/database = yaamp/database = '${YiiMPDBName}'/g' *.conf
sudo sed -i 's/username = root/username = '${StratumDBUser}'/g' *.conf
sudo sed -i 's/password = patofpaq/password = '${StratumUserDBPassword}'/g' *.conf

#set permissions
sudo setfacl -m u:$USER:rwx $STORAGE_ROOT/yiimp/site/stratum/
sudo setfacl -m u:$USER:rwx $STORAGE_ROOT/yiimp/site/stratum/config

echo -e "$GREEN Stratum build completed...$COL_RESET"
cd $HOME/yiimpserver/yiimp_single
