DO
$$
BEGIN
IF NOT EXISTS (SELECT column_name 
               FROM information_schema.columns 
               WHERE table_schema='public' and table_name='stock_picking' and column_name='sale_id') THEN
ALTER TABLE stock_picking ADD COLUMN sale_id integer;
COMMENT ON COLUMN stock_picking.sale_id IS 'Sale Order';
END IF;                                      
END
$$;

UPDATE stock_picking
 SET sale_id = (SELECT so.id FROM sale_order so JOIN stock_picking sp ON so.procurement_group_id = sp.group_id WHERE sp.id = stock_picking.id)
 WHERE sale_id IS NULL;