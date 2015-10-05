--add alias column
DO $$ 
    BEGIN
        BEGIN
		ALTER TABLE res_partner ADD COLUMN alias character varying(255);
		COMMENT ON COLUMN res_partner.alias IS 'Alias';
        EXCEPTION
            	WHEN duplicate_column THEN RAISE NOTICE 'column alias already exists in res_partner.';
        END;
    END;
$$;

DELETE FROM ir_ui_menu WHERE parent_id = 693;
DELETE FROM ir_ui_menu WHERE id = 693;
DELETE FROM ir_ui_menu WHERE parent_id = 661;
DELETE FROM ir_ui_menu WHERE id = 661;
DELETE FROM ir_ui_menu WHERE parent_id = 481;
DELETE FROM ir_ui_menu WHERE id = 481;
--DELETE FROM ir_ui_view WHERE name LIKE '%maintenance%' OR model LIKE '%maintenance%';
--DELETE FROM ir_ui_view WHERE name = 'stock.picking.out.tree';

UPDATE maintenance_intervention
SET address_id = rp.id
FROM res_partner rp
JOIN maintenance_installation mi ON mi.address_id = rp.id
WHERE maintenance_intervention.installation_id = mi.id;


UPDATE maintenance_intervention_product SET sale_order_line_id = NULL
WHERE id IN
(SELECT d1.id 
FROM maintenance_intervention_product d1
LEFT JOIN sale_order_line d2
ON d1.sale_order_line_id = d2.id
WHERE d2.id IS NULL
AND d1.sale_order_line_id IS NOT NULL);


UPDATE sale_order SET intervention_id = NULL
WHERE id IN
(SELECT d1.id 
FROM sale_order d1
LEFT JOIN maintenance_intervention d2
ON d1.intervention_id = d2.id
WHERE d2.id IS NULL
AND d1.intervention_id IS NOT NULL);

DO
$$
BEGIN
IF NOT EXISTS (SELECT column_name 
               FROM information_schema.columns 
               WHERE table_schema='public' and table_name='maintenance_intervention' and column_name='task_state') THEN
ALTER TABLE maintenance_intervention ADD COLUMN task_state character varying(255);
COMMENT ON COLUMN maintenance_intervention.task_state IS 'Task state';
END IF;                                      
END
$$;

UPDATE maintenance_intervention mi SET task_state = 'to_plan' WHERE not EXISTS (SELECT 1 FROM maintenance_intervention_task mt WHERE intervention_id = mi.id);
UPDATE maintenance_intervention mi SET task_state = 'planned' WHERE EXISTS (SELECT 1 FROM maintenance_intervention_task mt WHERE intervention_id = mi.id);