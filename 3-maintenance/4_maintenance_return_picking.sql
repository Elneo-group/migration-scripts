UPDATE stock_picking sp SET picking_type_id = 
	(SELECT spt.id FROM stock_picking_type spt JOIN stock_warehouse sw ON sw.maint_ret_type_id = spt.id
	WHERE sw.id = (SELECT spt1.warehouse_id FROM stock_picking_type spt1 WHERE spt1.id = sp.picking_type_id))
WHERE sp.is_maint_restocking = True;