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
SET sale_id = req.so_id
FROM 
(select so.id so_id, p.id pick_id from sale_order so left join stock_picking p on so.procurement_group_id = p.group_id) req
WHERE
stock_picking.id = req.pick_id and stock_picking.sale_id is null;