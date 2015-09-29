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
echo "------ MAINTENANCE -----"
echo "Set Vars..."
psql -h $DB_HOST_ORIGIN -d $DATABASE_ORIGIN -U $DB_USER_ORIGIN -f $BASEDIR/../set_var.sql -v DB_BACKUP_PATH_ORIGIN=$DB_BACKUP_PATH_ORIGIN -v DB_BACKUP_PATH=$DB_BACKUP_PATH
psql -h $DB_HOST -d $DATABASE -U $DB_USER -f $BASEDIR/../set_var.sql -v DB_BACKUP_PATH_ORIGIN=$DB_BACKUP_PATH_ORIGIN -v DB_BACKUP_PATH=$DB_BACKUP_PATH

if [ $FIRST_INSTALL ]
    then
	echo "0_before.sql..."
        psql -h $DB_HOST -d $DATABASE -X --echo-all -v ON_ERROR_STOP=1 -f $BASEDIR/0_before.sql
        
        if [ $? != 0 ]; then
		    echo "psql failed while trying to run this sql script" 1>&2
		    exit $psql_exit_status
		fi
		break
    fi

echo "BASEDIR = $BASEDIR"
echo "DB_HOST = $DB_HOST"
echo "DATABASE = $DATABASE"
echo "USER = $USER"
echo "PASSWORD = $PASSWORD"
echo "URL = $URL"

echo "Maintenance..."
python $BASEDIR/module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL maintenance

echo "0_after.sql..."
psql -h $DB_HOST -d $DATABASE -X --echo-all -v ON_ERROR_STOP=1 -f $BASEDIR/0_after.sql

if [ $? != 0 ]; then
    echo "psql failed while trying to run this sql script" 1>&2
    exit $psql_exit_status
fi

echo "maintenance_element_type..."
python $BASEDIR/module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL maintenance_element_type

echo "maintenance_failure_type..."
python $BASEDIR/module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL maintenance_failure_type

echo "maintenance_installation_check..."
python $BASEDIR/module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL maintenance_installation_check

echo "1_maintenance_product.sql"
psql -h $DB_HOST -d $DATABASE -X --echo-all -v ON_ERROR_STOP=1 -f $BASEDIR/1_maintenance_product.sql


if [ $? != 0 ]; then
    echo "psql failed while trying to run this sql script" 1>&2
    exit $psql_exit_status
fi

echo "maintenance_product..."
python $BASEDIR/module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL maintenance_product

echo "maintenance_timeofuse..."
python $BASEDIR/module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL maintenance_timeofuse

echo "maintenance_project..."
python $BASEDIR/module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL maintenance_project

psql -h $DB_HOST -d $DATABASE -X --echo-all -v ON_ERROR_STOP=1 -f $BASEDIR/2_maintenance_model.sql


if [ $? != 0 ]; then
    echo "psql failed while trying to run this sql script" 1>&2
    exit $psql_exit_status
fi

echo "maintenance_model..."
python $BASEDIR/module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL maintenance_model

echo "maintenance_travel_cost..."
python $BASEDIR/module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL maintenance_travel_cost

echo "maintenance_intervention_merge..."
python $BASEDIR/module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL maintenance_intervention_merge

echo "maintenance_project_invoicing..."
python $BASEDIR/module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL maintenance_project_invoicing

echo "maintenance_project_quotation..."
python $BASEDIR/module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL maintenance_project_quotation

echo "maintenance_project_quotation_advanced..."
python $BASEDIR/module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL maintenance_project_quotation_advanced

psql -h $DB_HOST -d $DATABASE -X --echo-all -v ON_ERROR_STOP=1 -f $BASEDIR/3_default_supplier.sql


if [ $? != 0 ]; then
    echo "psql failed while trying to run this sql script" 1>&2
    exit $psql_exit_status
fi

echo "maintenance_serial_number..."
python $BASEDIR/module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL maintenance_serial_number

echo "elneo_maintenance_serial_number..."
python $BASEDIR/module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL elneo_maintenance_serial_number

echo "elneo_default_supplier..."
python $BASEDIR/module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL elneo_default_supplier

echo "------ MAINTENANCE (FIN) -----"
