#!/bin/bash
set -e
set -u

date

if [ $# -eq 0 ]
then
	echo 'Please set config file as first parameter'
	exit 0
fi

CONF_FILE=`readlink -m $1`

if [ ! -f $CONF_FILE ]; #test config file existence
then
	echo "Config file $CONF_FILE does not exists"
	exit 0
else
	echo "Use config file $CONF_FILE..."
	. $CONF_FILE #set vars of config file
fi

if [ $# -gt 1 ] && [ $2 = "--first-install" ] #mor than 1 argument and this argument is "--first-install"
then
	FIRST_INSTALL=true
	echo 'First install...'	
else
	FIRST_INSTALL=false
	echo 'Not first install...'	
fi

echo ""
echo "---------------------------------------------------"
echo "------------------- SERVER STOP -------------------"
echo "---------------------------------------------------"
echo ""
date
service odoo-server stop
killall python


echo ""
echo "------------------------------------------------"
echo "------------------- SCRIPT 0 -------------------"
echo "------------------------------------------------"
echo ""
date

if $FIRST_INSTALL
then
	sh ./0-cleanup/script.sh ./config-test.conf --first-install
else
	sh ./0-cleanup/script.sh ./config-test.conf
fi

echo ""
echo "----------------------------------------------"
echo "---------------- SERVER START ----------------"
echo "----------------------------------------------"
echo ""
date
python odoo/odoo.py --addons-path=/home/elneo/odoo/addons,/home/elneo/elneo-openobject,/home/elneo/community_addons --db_user=odoo --db_password=Newtec68 --db_host=localhost -d migrated_2 $

echo ""
echo "-----------------------------------------------"
echo "--------------- INSTALL SCRIPTS ---------------"
echo "-----------------------------------------------"
echo ""
date

if $FIRST_INSTALL
then
	sh install_scripts.sh ./config-test.conf --first-install
else
	sh install_scripts.sh ./config-test.conf
fi

echo ""
echo "-----------------------------------------------"
echo "--------------- INSTALL MODULES ---------------"
echo "-----------------------------------------------"
echo ""
date

if $FIRST_INSTALL
then
	sh install_modules.sh ./config-test.conf --first-install
else
	sh install_modules.sh ./config-test.conf
fi

date

echo ""
echo "------------------------------------------------------"
echo "------------------- SERVER RESTART -------------------"
echo "------------------------------------------------------"
echo ""
date
service odoo-server start
killall python