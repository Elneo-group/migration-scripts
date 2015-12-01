DO $$
DECLARE 
DB_BACKUP_FILE varchar;
BEGIN

drop table if exists hr_equipment;
drop table if exists hr_equipment_category;


END;
$$ LANGUAGE plpgsql;
