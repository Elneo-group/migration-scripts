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

CONF_FILE="./config.conf"

set -e
set -u

# Read config
echo "Reading config for noviat_account...." >&2

if [ -f $CONF_FILE ];
then
   echo "File $CONF_FILE exists"
   source ./config.conf
else
   echo "File $CONF_FILE does not exists. Taking defaults."
fi


goon=
while [ -z $goon ]
do
    echo -n 'This will update noviat_account modules. Do you want to continue? '
    read goon
    if [[ $goon = 'n' ]]
    then
        break
    fi
    goon=
done


python ./module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL module_install_enhancements

psql -d $DATABASE -X --echo-all -v ON_ERROR_STOP=1 -f ./1_uninstall_l10n_be.sql


if [ $? != 0 ]; then
    echo "psql failed while trying to run this sql script" 1>&2
    exit $psql_exit_status
fi

python ./module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL l10n_be_coa_multilang
python ./module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL l10n_account_translate

psql -d $DATABASE -f ./2_update_model_data.sql


if [ $? != 0 ]; then
    echo "psql failed while trying to run this sql script" 1>&2
    exit 1
fi

python ./module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL l10n_be_partner

psql -d $DATABASE -X --echo-all -v ON_ERROR_STOP=1 -f ./3_update_bank_statement.sql


if [ $? != 0 ]; then
    echo "psql failed while trying to run this sql script" 1>&2
    exit 1
fi

python ./module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL account_bank_statement_advanced

psql -d $DATABASE -X --echo-all -v ON_ERROR_STOP=1 -f ./4_coda_before.sql


if [ $? != 0 ]; then
    echo "psql failed while trying to run this sql script" 1>&2
    exit 1
fi

python ./module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL l10n_be_coda_advanced
python ./module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL l10n_be_coda_pain
python ./module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL l10n_be_coda_sale

psql -d $DATABASE -X --echo-all -v ON_ERROR_STOP=1 -f ./4_coda_after.sql


if [ $? != 0 ]; then
    echo "psql failed while trying to run this sql script" 1>&2
    exit 1
fi


python ./module_update.py -d $DATABASE -u $USER -w $PASSWORD -s $URL l10n_be_invoice_bba

python ./module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL l10n_be_invoice_layout

psql -d $DATABASE -X --echo-all -v ON_ERROR_STOP=1 -f ./4_1_account_financial.sql

python ./module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL account_financial_report_webkit_xls

psql -d $DATABASE -X --echo-all -v ON_ERROR_STOP=1 -f ./5_account_pain.sql


if [ $? != 0 ]; then
    echo "psql failed while trying to run this sql script" 1>&2
    exit 1
fi

python ./module_update.py -d $DATABASE -u $USER -w $PASSWORD -s $URL account_pain

python ./module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL account_invoice_line_default

python ./module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL account_move_line_search_extension

python ./module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL account_move_line_report_xls

python ./module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL account_journal_report_xls


psql -d $DATABASE -X --echo-all -v ON_ERROR_STOP=1 -f ./6_account_bank_statement_menu.sql


if [ $? != 0 ]; then
    echo "psql failed while trying to run this sql script" 1>&2
    exit 1
fi

python ./module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL account_supplier_invoice_check_duplicates

python ./module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL account_invoice_force_number

python ./module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL account_fiscal_position_constraints

python ./module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL account_open_receivables_payables_xls

python ./module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL account_overdue

python ./module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL account_asset_management_xls
