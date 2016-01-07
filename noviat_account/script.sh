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

if [ ! $1 ]
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

if [ ! -z "$2" ] && [ $2 = "--first-install" ]
then
	FIRST_INSTALL=true
	echo 'First install...'	
else
	FIRST_INSTALL=false
	echo 'Not first install...'	
fi

BASEDIR=$(dirname $0)
echo "------ NOVIAT_ACCOUNT -----"
echo "Set Vars..."
psql -h $DB_HOST_ORIGIN -d $DATABASE_ORIGIN -U $DB_USER_ORIGIN -f $BASEDIR/../set_var.sql -v DB_BACKUP_PATH_ORIGIN=$DB_BACKUP_PATH_ORIGIN -v DB_BACKUP_PATH=$DB_BACKUP_PATH
psql -h $DB_HOST -d $DATABASE -U $DB_USER -f $BASEDIR/../set_var.sql -v DB_BACKUP_PATH_ORIGIN=$DB_BACKUP_PATH_ORIGIN -v DB_BACKUP_PATH=$DB_BACKUP_PATH


set -e
set -u


echo '0_before.sql...'
psql -h $DB_HOST -d $DATABASE -X --echo-all -v ON_ERROR_STOP=1 -f $BASEDIR/0_before.sql


if [ $? != 0 ]; then
    echo "psql failed while trying to run this sql script" 1>&2
    exit $psql_exit_status
fi

python $BASEDIR/module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL module_install_enhancements

echo '1_uninstall_l10n_be.sql...'
psql -h $DB_HOST -d $DATABASE -X --echo-all -v ON_ERROR_STOP=1 -f $BASEDIR/1_uninstall_l10n_be.sql


if [ $? != 0 ]; then
    echo "psql failed while trying to run this sql script" 1>&2
    exit $psql_exit_status
fi

python $BASEDIR/module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL l10n_be_coa_multilang
python $BASEDIR/module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL l10n_account_translate

echo '2_update_model_data.sql...'
psql -h $DB_HOST -d $DATABASE -f $BASEDIR/2_update_model_data.sql


if [ $? != 0 ]; then
    echo "psql failed while trying to run this sql script" 1>&2
    exit 1
fi

python $BASEDIR/module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL l10n_be_partner

echo '3_update_bank_statement.sql...'
psql -h $DB_HOST -d $DATABASE -X --echo-all -v ON_ERROR_STOP=1 -f $BASEDIR/3_update_bank_statement.sql


if [ $? != 0 ]; then
    echo "psql failed while trying to run this sql script" 1>&2
    exit 1
fi

python $BASEDIR/module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL account_bank_statement_advanced


echo '4_coda_before.sql...'
psql -h $DB_HOST -d $DATABASE -X --echo-all -v ON_ERROR_STOP=1 -f $BASEDIR/4_coda_before.sql


if [ $? != 0 ]; then
    echo "psql failed while trying to run this sql script" 1>&2
    exit 1
fi

python $BASEDIR/module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL l10n_be_coda_advanced
python $BASEDIR/module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL l10n_be_coda_pain
python $BASEDIR/module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL l10n_be_coda_sale

psql -h $DB_HOST -d $DATABASE -X --echo-all -v ON_ERROR_STOP=1 -f $BASEDIR/4_coda_after.sql


if [ $? != 0 ]; then
    echo "psql failed while trying to run this sql script" 1>&2
    exit 1
fi


python $BASEDIR/module_update.py -d $DATABASE -u $USER -w $PASSWORD -s $URL l10n_be_invoice_bba

python $BASEDIR/module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL l10n_be_invoice_layout

echo '4_1_account_financial.sql...'
psql -h $DB_HOST -d $DATABASE -X --echo-all -v ON_ERROR_STOP=1 -f $BASEDIR/4_1_account_financial.sql

python $BASEDIR/module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL account_financial_report_webkit_xls

echo '5_account_pain.sql...'
psql -h $DB_HOST -d $DATABASE -X --echo-all -v ON_ERROR_STOP=1 -f $BASEDIR/5_account_pain.sql


if [ $? != 0 ]; then
    echo "psql failed while trying to run this sql script" 1>&2
    exit 1
fi

python $BASEDIR/module_update.py -d $DATABASE -u $USER -w $PASSWORD -s $URL account_pain

python $BASEDIR/module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL account_invoice_line_default

python $BASEDIR/module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL account_move_line_search_extension

python $BASEDIR/module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL account_move_line_report_xls

python $BASEDIR/module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL account_journal_report_xls


echo '6_account_bank_statement_menu.sql...'
psql -h $DB_HOST -d $DATABASE -X --echo-all -v ON_ERROR_STOP=1 -f $BASEDIR/6_account_bank_statement_menu.sql


if [ $? != 0 ]; then
    echo "psql failed while trying to run this sql script" 1>&2
    exit 1
fi

python $BASEDIR/module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL account_supplier_invoice_check_duplicates

python $BASEDIR/module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL account_invoice_force_number

python $BASEDIR/module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL account_fiscal_position_constraints

python $BASEDIR/module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL account_open_receivables_payables_xls

python $BASEDIR/module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL account_overdue

python $BASEDIR/module_uninstall.py -d $DATABASE -u $USER -w $PASSWORD -s $URL account_asset

python $BASEDIR/module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL account_asset_management_xls

python $BASEDIR/module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL account_invoice_line_import

python $BASEDIR/module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL account_invoice_pay_filter

python $BASEDIR/module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL account_invoice_sequence_by_period

python $BASEDIR/module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL account_invoice_tax_manual

python $BASEDIR/module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL account_journal_period_close

python $BASEDIR/module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL account_move_import

echo '7_account_line_balance.sql...'
psql -h $DB_HOST -d $DATABASE -X --echo-all -v ON_ERROR_STOP=1 -f $BASEDIR/7_account_line_balance.sql


if [ $? != 0 ]; then
    echo "psql failed while trying to run this sql script" 1>&2
    exit 1
fi

python $BASEDIR/module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL account_move_line_balance

python $BASEDIR/module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL account_reversal

python $BASEDIR/module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL account_journal_period_close

python $BASEDIR/module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL account_tax_constraints

python $BASEDIR/module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL account_trial_balance_period_xls

python $BASEDIR/module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL base_vat_enhancements

python $BASEDIR/module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL datetime_widget

python $BASEDIR/module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL account_journal_period_close

python $BASEDIR/module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL intrastat_base

python $BASEDIR/module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL intrastat_product

python $BASEDIR/module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL account_journal_period_close

python $BASEDIR/module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL invoice_fiscal_position_update

python $BASEDIR/module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL l10n_be_coda_batch

python $BASEDIR/module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL multi_company_fix

python $BASEDIR/module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL sale_order_attachments

python $BASEDIR/module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL tree_date_search_extension

python $BASEDIR/module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL web_dialog_size

python $BASEDIR/module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL web_export_view

python $BASEDIR/module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL web_fix_binaryfile

python $BASEDIR/module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL web_sheet_full_width

python $BASEDIR/module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL web_sheet_full_width_selective

echo '8_res_country.sql...'
psql -h $DB_HOST -d $DATABASE -X --echo-all -v ON_ERROR_STOP=1 -f $BASEDIR/8_res_country.sql



echo "------ NOVIAT_ACCOUNT (FIN) -----"
