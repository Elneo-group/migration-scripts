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
echo "------ WARNING -----"
echo "Set Vars..."
psql -h $DB_HOST_ORIGIN -d $DATABASE_ORIGIN -U $DB_USER_ORIGIN -f $BASEDIR/../set_var.sql -v DB_BACKUP_PATH_ORIGIN=$DB_BACKUP_PATH_ORIGIN -v DB_BACKUP_PATH=$DB_BACKUP_PATH
psql -h $DB_HOST -d $DATABASE -U $DB_USER -f $BASEDIR/../set_var.sql -v DB_BACKUP_PATH_ORIGIN=$DB_BACKUP_PATH_ORIGIN -v DB_BACKUP_PATH=$DB_BACKUP_PATH

echo "Install module 'warning'..."
python $BASEDIR/module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL warning

echo "0_after.sql..."
psql -h $DB_HOST -d $DATABASE -U $DB_USER -X --echo-all -v ON_ERROR_STOP=1 -f $BASEDIR/0_after.sql


if [ $? != 0 ]; then
    echo "psql failed while trying to run this sql script" 1>&2
    exit $psql_exit_status
fi
echo "------ WARNING (FIN) -----"