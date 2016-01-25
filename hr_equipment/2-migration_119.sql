DO $$
DECLARE 
DB_BACKUP_FILE varchar;
BEGIN

drop table if exists hr_equipment cascade;
drop table if exists hr_equipment_category cascade;


END;
$$ LANGUAGE plpgsql;
