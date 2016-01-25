DO
$$
BEGIN
IF NOT EXISTS (SELECT column_name 
               FROM information_schema.columns 
               WHERE table_schema='public' and table_name='product_template' and column_name='default_supplier_id') THEN
	ALTER TABLE product_template ADD COLUMN default_supplier_id integer;
	COMMENT ON COLUMN poduct_template.default_supplier_id IS 'Default supplier';
END IF;                                      
END
$$;

UPDATE product_template
SET default_supplier_id = NULL
 WHERE NOT EXISTS (SELECT rp.id FROM res_partner rp WHERE rp.id = product_template.default_supplier_id) AND default_supplier_id IS NOT NULL;