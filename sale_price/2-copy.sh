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

echo "Set Vars..."
psql -h $DB_HOST_ORIGIN -d $DATABASE_ORIGIN -U $DB_USER_ORIGIN -f $BASEDIR/../set_var.sql -v DB_BACKUP_PATH_ORIGIN=$DB_BACKUP_PATH_ORIGIN -v DB_BACKUP_PATH=$DB_BACKUP_PATH
psql -h $DB_HOST -d $DATABASE -U $DB_USER -f $BASEDIR/../set_var.sql -v DB_BACKUP_PATH_ORIGIN=$DB_BACKUP_PATH_ORIGIN -v DB_BACKUP_PATH=$DB_BACKUP_PATH

echo "Copy backups..."
scp $DB_OS_USER_ORIGIN@$DB_HOST_ORIGIN:$DB_BACKUP_PATH_ORIGIN/product_discount_type.backup $DB_OS_USER@$DB_HOST:$DB_BACKUP_PATH
scp $DB_OS_USER_ORIGIN@$DB_HOST_ORIGIN:$DB_BACKUP_PATH_ORIGIN/customer_discount_exception.backup $DB_OS_USER@$DB_HOST:$DB_BACKUP_PATH
scp $DB_OS_USER_ORIGIN@$DB_HOST_ORIGIN:$DB_BACKUP_PATH_ORIGIN/elneo_autocompute_saleprice_category_coefficientlist.backup $DB_OS_USER@$DB_HOST:$DB_BACKUP_PATH
scp $DB_OS_USER_ORIGIN@$DB_HOST_ORIGIN:$DB_BACKUP_PATH_ORIGIN/discount_type_discount.backup $DB_OS_USER@$DB_HOST:$DB_BACKUP_PATH
scp $DB_OS_USER_ORIGIN@$DB_HOST_ORIGIN:$DB_BACKUP_PATH_ORIGIN/product_group.backup $DB_OS_USER@$DB_HOST:$DB_BACKUP_PATH
scp $DB_OS_USER_ORIGIN@$DB_HOST_ORIGIN:$DB_BACKUP_PATH_ORIGIN/product_group_discount.backup $DB_OS_USER@$DB_HOST:$DB_BACKUP_PATH
scp $DB_OS_USER_ORIGIN@$DB_HOST_ORIGIN:$DB_BACKUP_PATH_ORIGIN/partner_discount_type.backup $DB_OS_USER@$DB_HOST:$DB_BACKUP_PATH
echo "...end of Copy."