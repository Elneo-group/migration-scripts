DO $$
DECLARE 
DB_BACKUP_FILE varchar;
BEGIN

truncate table hr_equipment cascade;
truncate table hr_equipment_category cascade;

alter sequence hr_equipment_category_id_seq restart with 1;


END;
$$ LANGUAGE plpgsql;
