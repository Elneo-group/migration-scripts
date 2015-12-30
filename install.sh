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
echo "-----------------------------------------------------"
echo "------------------- SET MODELS.PY -------------------"
echo "-----------------------------------------------------"
echo ""
date
#if [ -f $ADDONS_BASE_DIR/openerp/models.py.bkp]
#then 
#	echo 'models.py.bkp already exists'
#else
#	echo 'backup models.py'
#	cp $ADDONS_BASE_DIR/openerp/models.py $ADDONS_BASE_DIR/openerp/models.py.bkp
#fi
#cp models.py $ADDONS_BASE_DIR/openerp/



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

echo ""
echo "-------------------------------------------------------"
echo "------------------- RESET MODELS.PY -------------------"
echo "-------------------------------------------------------"
echo ""
date
cp $ADDONS_BASE_DIR/openerp/models.py.bkp $ADDONS_BASE_DIR/openerp/models.py
rm $ADDONS_BASE_DIR/openerp/models.py.bkp
