UPDATE ir_module_module SET state = 'uninstalled' WHERE name = 'l10n_be_intrastat';
UPDATE ir_module_module SET state = 'uninstalled' WHERE name = 'report_intrastat';

DELETE FROM ir_ui_view WHERE id = 2628;
DELETE FROM ir_ui_view WHERE id = 2627;
DELETE FROM ir_ui_view WHERE id = 2632;
DELETE FROM ir_ui_view WHERE id = 2631;
DELETE FROM ir_ui_view WHERE id = 2630;
DELETE FROM ir_ui_view WHERE id = 2629;

DELETE FROM ir_ui_view WHERE id = 2633;
DELETE FROM ir_ui_view WHERE id = 2638;
DELETE FROM ir_ui_view WHERE id = 2639;
DELETE FROM ir_ui_view WHERE id = 2641;
DELETE FROM ir_ui_view WHERE id = 2640;

DELETE FROM ir_ui_view WHERE id = 2637;
DELETE FROM ir_ui_view WHERE id = 2634;
DELETE FROM ir_ui_view WHERE id = 2635;
DELETE FROM ir_ui_view WHERE id = 2636;
DELETE FROM ir_ui_view WHERE id = 2642;
DELETE FROM ir_ui_view WHERE id = 2626;


-- intrastat columns
DO
$$
BEGIN
IF NOT EXISTS (SELECT column_name 
               FROM information_schema.columns 
               WHERE table_schema='public' and table_name='account_invoice' and column_name='intrastat') THEN
ALTER TABLE account_invoice ADD COLUMN intrastat character varying;
COMMENT ON COLUMN account_invoice.intrastat IS 'Intrastat';
END IF;                                      
END
$$;

DO
$$
BEGIN
IF NOT EXISTS (SELECT column_name 
               FROM information_schema.columns 
               WHERE table_schema='public' and table_name='account_invoice' and column_name='intrastat_transaction_id') THEN
ALTER TABLE account_invoice ADD COLUMN intrastat_transaction_id integer;
COMMENT ON COLUMN account_invoice.intrastat_transaction_id IS 'Intrastat';
END IF;                                      
END
$$;

-- UPDATE
update account_invoice set intrastat_transaction_id = null where intrastat_transaction_id is not null;
UPDATE account_invoice SET intrastat = 'standard' WHERE company_id = 1;


-- RES_COMPANY
DO
$$
BEGIN
IF NOT EXISTS (SELECT column_name 
               FROM information_schema.columns 
               WHERE table_schema='public' and table_name='res_company' and column_name='intrastat') THEN
ALTER TABLE res_company ADD COLUMN intrastat character varying;
COMMENT ON COLUMN res_company.intrastat IS 'Intrastat';
END IF;                                      
END
$$;

DO
$$
BEGIN
IF NOT EXISTS (SELECT column_name 
               FROM information_schema.columns 
               WHERE table_schema='public' and table_name='res_company' and column_name='intrastat_arrivals') THEN
ALTER TABLE res_company ADD COLUMN intrastat_arrivals character varying;
COMMENT ON COLUMN res_company.intrastat_arrivals IS 'Intrastat Arrivals';
END IF;                                      
END
$$;

DO
$$
BEGIN
IF NOT EXISTS (SELECT column_name 
               FROM information_schema.columns 
               WHERE table_schema='public' and table_name='res_company' and column_name='intrastat_dispatches') THEN
ALTER TABLE res_company ADD COLUMN intrastat_dispatches character varying;
COMMENT ON COLUMN res_company.intrastat_dispatches IS 'Intrastat Dispatches';
END IF;                                      
END
$$;

UPDATE res_company SET intrastat = 'standard';
UPDATE res_company SET intrastat_arrivals = 'standard';
UPDATE res_company SET intrastat_dispatches = 'standard';
