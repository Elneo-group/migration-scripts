DO
$$
BEGIN
IF NOT EXISTS (SELECT column_name 
               FROM information_schema.columns 
               WHERE table_schema='public' and table_name='sale_order_line' and column_name='categ_sequence') THEN
ALTER TABLE sale_order_line ADD COLUMN categ_sequence integer;
COMMENT ON COLUMN sale_order_line.categ_sequence IS 'Layout Sequence';
END IF;                                      
END
$$;

DO
$$
BEGIN
IF NOT EXISTS (SELECT column_name 
               FROM information_schema.columns 
               WHERE table_schema='public' and table_name='account_invoice_line' and column_name='categ_sequence') THEN
ALTER TABLE account_invoice_line ADD COLUMN categ_sequence integer;
COMMENT ON COLUMN account_invoice_line.categ_sequence IS 'Layout Sequence';
END IF;                                      
END
$$;

DO
$$
BEGIN
IF NOT EXISTS (SELECT column_name 
               FROM information_schema.columns 
               WHERE table_schema='public' and table_name='sale_order_line' and column_name='sale_layout_cat_id') THEN
ALTER TABLE sale_order_line ADD COLUMN sale_layout_cat_id integer;
COMMENT ON COLUMN sale_order_line.sale_layout_cat_id IS 'Section';
END IF;                                      
END
$$;

DO
$$
BEGIN
IF NOT EXISTS (SELECT column_name 
               FROM information_schema.columns 
               WHERE table_schema='public' and table_name='account_invoice_line' and column_name='sale_layout_cat_id') THEN
ALTER TABLE account_invoice_line ADD COLUMN sale_layout_cat_id integer;
COMMENT ON COLUMN account_invoice_line.sale_layout_cat_id IS 'Section';
END IF;                                      
END
$$;