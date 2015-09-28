DO $$
DECLARE 
DB_BACKUP_FILE_ORIGIN varchar;
BEGIN

truncate table hr_equipment;
insert into hr_equipment(name, serial_no, category_id, equipment_assign_to, employee_id, purchase_date, model, cost, note)
select case when type = 'tablet' then 'Tablet' when type = 'fix_computer' then 'PC' when type = 'portable_computer' then 'Laptop' when type = 'smartphone' then 'Smartphone' when type = 'GSM' then 'Mobile' when type = 'USB_key' then 'Mobile data usb key' when type = 'printer' then 'Printer' when type = 'gps' then 'GPS' end as name, serial_number as serial_no, case when type = 'tablet' then 1 when type = 'fix_computer' then 2 when type = 'portable_computer' then 3 when type = 'smartphone' then 4 when type = 'GSM' then 4 when type = 'USB_key' then 5 when type = 'printer' then 6  end as category_id, 'employee' as equipment_assign_to, employee_id, date_buy as purchase_date, model, replace(regexp_replace(price, '[^0-9]*' ,'', 'g'),',','.')::float as cost, concat('sim: ',sim,E'\npin: ',pin,E'\npuk: ',puk,E'\nnote: ',note) as note from elneo_hr_multimedia;


select val||'hr_equipment.backup' from import_var where name = 'DB_BACKUP_PATH_ORIGIN' into DB_BACKUP_FILE_ORIGIN;
EXECUTE format('copy hr_equipment to ''%s''',DB_BACKUP_FILE_ORIGIN);


END;
$$ LANGUAGE plpgsql;
