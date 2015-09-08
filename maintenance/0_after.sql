UPDATE maintenance_installation SET warehouse_id = shop_id WHERE warehouse_id IS NULL;

UPDATE maintenance_installation SET state = CASE WHEN active = True THEN 'active' ELSE 'inactive' END WHERE state IS NULL;