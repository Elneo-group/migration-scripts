DO $$
DECLARE 
DB_BACKUP_FILE varchar;
BEGIN

drop table hr_equipment if exists;
drop table hr_equipment_category if exists;


END;
$$ LANGUAGE plpgsql;
