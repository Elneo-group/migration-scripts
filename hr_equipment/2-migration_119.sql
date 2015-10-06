DO $$
DECLARE 
DB_BACKUP_FILE varchar;
BEGIN

truncate table hr_equipment_category cascade;

alter sequence hr_equipment_category_id_seq restart with 1;

INSERT INTO hr_equipment_category(name, alias_id)
    VALUES ('Tablet',1);
INSERT INTO hr_equipment_category(name, alias_id)
    VALUES ('PC',1);
INSERT INTO hr_equipment_category(name, alias_id)
    VALUES ('Laptop',1);
INSERT INTO hr_equipment_category(name, alias_id)
    VALUES ('Mobile phone',1);
INSERT INTO hr_equipment_category(name, alias_id)
    VALUES ('Mobile USB key',1);
INSERT INTO hr_equipment_category(name, alias_id)
    VALUES ('Printer',1);


select val||'hr_equipment.backup' from import_var where name = 'DB_BACKUP_PATH' into DB_BACKUP_FILE;

EXECUTE format('copy hr_equipment from ''%s''',DB_BACKUP_FILE);

END;
$$ LANGUAGE plpgsql;