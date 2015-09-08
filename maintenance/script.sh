#!/bin/bash
################################################################################
# Script for Installation: ODOO modules
# Author: Denis Roussel - Elneo - 2015
#-------------------------------------------------------------------------------
#  
# 
#-------------------------------------------------------------------------------
# USAGE:
#
# script
#
# EXAMPLE:
# ./script
#
################################################################################

DATABASE="demo"
DATABASE_USER="odoo"
DATABASE_PASSWORD="odoo"
USER="demo"
PASSWORD="demo"
URL="http://localhost:8069"

CONF_FILE="$(pwd)/config.conf"

set -e
set -u

# Read config
echo "Reading config for maintenance...." >&2

if [ -f $CONF_FILE ];
then
   echo "File $CONF_FILE exists"
   . $CONF_FILE
else
   echo "File $CONF_FILE does not exists. Taking defaults."
fi


goon=
while [ -z $goon ]
do
    echo -n 'This will update maintenance modules. Do you want to continue (y/n)? '
    read goon
    if [ $goon = 'n' ]
    then
        exit
    fi
    if [ $goon = 'y' ]
    then
        break
    fi
    goon=
done

goon=
while [ -z $goon ]
do
    echo -n '=== FIRST INSTALL === Is it the first install (not an update, otherwise it will delete some views) (y/n)? '
    read goon
    if [ $goon = 'n' ]
    then
        break
    fi
    if [ $goon = 'y' ]
    then
        psql -d $DATABASE -X --echo-all -v ON_ERROR_STOP=1 -f ./0_before.sql
        
        if [ $? != 0 ]; then
		    echo "psql failed while trying to run this sql script" 1>&2
		    exit $psql_exit_status
		fi
		break
    fi
    goon=
done


python ./module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL maintenance


psql -d $DATABASE -X --echo-all -v ON_ERROR_STOP=1 -f ./0_after.sql


if [ $? != 0 ]; then
    echo "psql failed while trying to run this sql script" 1>&2
    exit $psql_exit_status
fi

python ./module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL maintenance_element_type

python ./module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL maintenance_failure_type

python ./module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL maintenance_installation_check

psql -d $DATABASE -X --echo-all -v ON_ERROR_STOP=1 -f ./1_maintenance_product.sql


if [ $? != 0 ]; then
    echo "psql failed while trying to run this sql script" 1>&2
    exit $psql_exit_status
fi

python ./module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL maintenance_product

python ./module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL maintenance_timeofuse

python ./module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL maintenance_project

psql -d $DATABASE -X --echo-all -v ON_ERROR_STOP=1 -f ./2_maintenance_model.sql


if [ $? != 0 ]; then
    echo "psql failed while trying to run this sql script" 1>&2
    exit $psql_exit_status
fi

python ./module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL maintenance_model

python ./module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL maintenance_travel_cost

python ./module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL maintenance_intervention_merge

python ./module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL maintenance_project_invoicing

python ./module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL maintenance_project_quotation

python ./module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL maintenance_project_quotation_advanced

psql -d $DATABASE -X --echo-all -v ON_ERROR_STOP=1 -f ./3_default_supplier.sql


if [ $? != 0 ]; then
    echo "psql failed while trying to run this sql script" 1>&2
    exit $psql_exit_status
fi

python ./module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL maintenance_serial_number

python ./module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL elneo_maintenance_serial_number

python ./module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL elneo_default_supplier
