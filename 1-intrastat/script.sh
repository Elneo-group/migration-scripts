#!/bin/bash
set -e
set -u

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

BASEDIR=$(dirname $0)
echo "------ INTRASTAT -----"

echo 'before.sql'
#psql -h $DB_HOST -d $DATABASE -U $DB_USER -f $BASEDIR/before.sql

python $BASEDIR/../module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL l10n_be_intrastat_product

echo 'Launch Intrastat Installer'
python $BASEDIR/../module_launch_installer.py -d $DATABASE -u $USER -w $PASSWORD -s $URL -f execute -a "CN_file=2015_fr" intrastat.installer

echo 'after.sql'
psql -h $DB_HOST -d $DATABASE -U $DB_USER -f $BASEDIR/after.sql



echo "------ INTRASTAT (FIN) -----"