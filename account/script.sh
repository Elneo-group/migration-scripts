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
echo "------ ACCOUNT -----"
echo "Set Vars..."
psql -h $DB_HOST_ORIGIN -d $DATABASE_ORIGIN -U $DB_USER_ORIGIN -f $BASEDIR/../set_var.sql -v DB_BACKUP_PATH_ORIGIN=$DB_BACKUP_PATH_ORIGIN -v DB_BACKUP_PATH=$DB_BACKUP_PATH
psql -h $DB_HOST -d $DATABASE -U $DB_USER -f $BASEDIR/../set_var.sql -v DB_BACKUP_PATH_ORIGIN=$DB_BACKUP_PATH_ORIGIN -v DB_BACKUP_PATH=$DB_BACKUP_PATH

echo 'migration.sql'
psql -h $DB_HOST -d $DATABASE -U $DB_USER -f $BASEDIR/migration.sql
echo "------ ACCOUNT (FIN) -----"