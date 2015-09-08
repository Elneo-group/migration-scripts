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
echo "Reading config for purchase_sale...." >&2

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
    echo -n 'This will update purchase_sale modules. Do you want to continue (y/n)? '
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

python ./module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL purchase_sale

psql -d $DATABASE -X --echo-all -v ON_ERROR_STOP=1 -f ./0_after.sql


if [ $? != 0 ]; then
    echo "psql failed while trying to run this sql script" 1>&2
    exit $psql_exit_status
fi
