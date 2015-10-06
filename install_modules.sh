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

#clean view problem

psql -h $DB_HOST -d $DATABASE -U $DB_USER -c "update ir_ui_view set arch = replace(arch,'<field name=\"in_group_76\" groups=\"base.group_no_one\"/>','') where name = 'res.users.groups'"

#community modules
community_modules=$(find $ADDONS_BASE_DIR/community_addons -maxdepth 1 -type d -printf "%f\n" -and -not -path \*/.\* | sort | xargs printf "'%s'," | sed 's/.\{1\}$//g')
community_modules_toupdate=$(psql -h $DB_HOST -d $DATABASE -U $DB_USER -c "select name from ir_module_module where name in ($community_modules) and state in ('installed','to update')" -t | xargs printf "%s," | sed 's/.\{1\}$//g')
community_modules_toinstall=$(psql -h $DB_HOST -d $DATABASE -U $DB_USER -c "select name from ir_module_module where name in ($community_modules)and state not in ('installed','to update')" -t | xargs printf "%s," | sed 's/.\{1\}$//g')
echo "update community modules : $community_modules_toupdate..."
date
if [ ${#community_modules_toupdate} -gt 0 ]
then
	python $BASEDIR/module_update.py -d $DATABASE -u $USER -w $PASSWORD -s $URL $community_modules_toupdate
fi

echo "install community modules : $community_modules_toinstall..."
date
if [ ${#community_modules_toinstall} -gt 0 ]
then
	python $BASEDIR/module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL $community_modules_toinstall
fi


#elneo modules
elneo_modules=$(find $ADDONS_BASE_DIR/elneo-openobject -maxdepth 1 -type d -printf "%f\n" -and -not -path \*/.\* | sort | xargs printf "'%s'," | sed 's/.\{1\}$//g')
elneo_modules_toupdate=$(psql -h $DB_HOST -d $DATABASE -U $DB_USER -c "select name from ir_module_module where name in ($elneo_modules) and state in ('installed','to update')" -t | xargs printf "%s," | sed 's/.\{1\}$//g')
elneo_modules_toinstall=$(psql -h $DB_HOST -d $DATABASE -U $DB_USER -c "select name from ir_module_module where name in ($elneo_modules)and state not in ('installed','to update')" -t | xargs printf "%s," | sed 's/.\{1\}$//g')
echo "update elneo modules : $elneo_modules_toupdate..."
date
if [ ${#elneo_modules_toupdate} -gt 0 ]
then
	python $BASEDIR/module_update.py -d $DATABASE -u $USER -w $PASSWORD -s $URL $elneo_modules_toupdate
fi
echo "install elneo modules : $elneo_modules_toinstall..."
date
if [ ${#elneo_modules_toinstall} -gt 0 ]
then
	python $BASEDIR/module_install.py -d $DATABASE -u $USER -w $PASSWORD -s $URL $elneo_modules_toinstall
fi