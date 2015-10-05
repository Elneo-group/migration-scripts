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

echo "INSTALL SCRIPTS"
date

if $FIRST_INSTALL
then
	sh install_scripts.sh ./config-test.conf --first-install
else
	sh install_scripts.sh ./config-test.conf
fi

echo "INSTALL MODULES"
date

if $FIRST_INSTALL
then
	sh install_modules.sh ./config-test.conf --first-install
else
	sh install_modules.sh ./config-test.conf
fi

date