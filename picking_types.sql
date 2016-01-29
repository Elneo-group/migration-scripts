
update stock_picking set picking_type_id = 1 where id in 
(select p.id from stock_picking p left join stock_picking_type pt on pt.id = p.picking_type_id where pt.warehouse_id = 1 and p.name like 'IN/%');
update stock_picking set picking_type_id = 6 where id in 
(select p.id from stock_picking p left join stock_picking_type pt on pt.id = p.picking_type_id where pt.warehouse_id = 2 and p.name like 'IN/%');
update stock_picking set picking_type_id = 3 where id in 
(select p.id from stock_picking p left join stock_picking_type pt on pt.id = p.picking_type_id where pt.warehouse_id = 1 and p.name like 'INT/%');
update stock_picking set picking_type_id = 8 where id in 
(select p.id from stock_picking p left join stock_picking_type pt on pt.id = p.picking_type_id where pt.warehouse_id = 2 and p.name like 'INT/%');
update stock_picking set picking_type_id = 2 where id in 
(select p.id from stock_picking p left join stock_picking_type pt on pt.id = p.picking_type_id where pt.warehouse_id = 1 and p.name like 'OUT/%');
update stock_picking set picking_type_id = 7 where id in 
(select p.id from stock_picking p left join stock_picking_type pt on pt.id = p.picking_type_id where pt.warehouse_id = 2 and p.name like 'OUT/%');
update stock_picking set picking_type_id = 17 where id in 
(select p.id from stock_picking p left join stock_picking_type pt on pt.id = p.picking_type_id where pt.warehouse_id = 1 and p.name like 'maint-return%');
update stock_picking set picking_type_id = 18 where id in 
(select p.id from stock_picking p left join stock_picking_type pt on pt.id = p.picking_type_id where pt.warehouse_id = 2 and p.name like 'maint-return%');


update stock_picking set picking_type_id = 22 where id in 
(select p.id from stock_picking p left join stock_picking_type pt on pt.id = p.picking_type_id left join sale_order s on p.sale_id = s.id where p.stop_delivery and s.block_delivery = 'adm_verification' and pt.warehouse_id = 1 and p.name like 'OUT/%');
update stock_picking set picking_type_id = 24 where id in 
(select p.id from stock_picking p left join stock_picking_type pt on pt.id = p.picking_type_id left join sale_order s on p.sale_id = s.id where p.stop_delivery and s.block_delivery = 'adm_verification' and pt.warehouse_id = 2 and p.name like 'OUT/%');
update stock_picking set picking_type_id = 20 where id in 
(select p.id from stock_picking p left join stock_picking_type pt on pt.id = p.picking_type_id left join sale_order s on p.sale_id = s.id where p.stop_delivery and s.block_delivery = 'delivery_by_saler' and pt.warehouse_id = 1 and p.name like 'OUT/%');
update stock_picking set picking_type_id = 26 where id in 
(select p.id from stock_picking p left join stock_picking_type pt on pt.id = p.picking_type_id left join sale_order s on p.sale_id = s.id where p.stop_delivery and s.block_delivery = 'delivery_by_saler' and pt.warehouse_id = 2 and p.name like 'OUT/%');
update stock_picking set picking_type_id = 23 where id in 
(select p.id from stock_picking p left join stock_picking_type pt on pt.id = p.picking_type_id left join sale_order s on p.sale_id = s.id where p.stop_delivery and s.block_delivery = 'maintenance_assembly' and pt.warehouse_id = 1 and p.name like 'OUT/%');
update stock_picking set picking_type_id = 27 where id in 
(select p.id from stock_picking p left join stock_picking_type pt on pt.id = p.picking_type_id left join sale_order s on p.sale_id = s.id where p.stop_delivery and s.block_delivery = 'maintenance_assembly' and pt.warehouse_id = 2 and p.name like 'OUT/%');
update stock_picking set picking_type_id = 21 where id in 
(select p.id from stock_picking p left join stock_picking_type pt on pt.id = p.picking_type_id left join sale_order s on p.sale_id = s.id where p.stop_delivery and s.block_delivery = 'customer_picking' and pt.warehouse_id = 1 and p.name like 'OUT/%');
update stock_picking set picking_type_id = 25 where id in 
(select p.id from stock_picking p left join stock_picking_type pt on pt.id = p.picking_type_id left join sale_order s on p.sale_id = s.id where p.stop_delivery and s.block_delivery = 'customer_picking' and pt.warehouse_id = 2 and p.name like 'OUT/%');
update stock_picking set picking_type_id = 35 where id in 
(select p.id from stock_picking p left join stock_picking_type pt on pt.id = p.picking_type_id left join sale_order s on p.sale_id = s.id where p.stop_delivery and s.block_delivery = 'postponed_delivery_date' and pt.warehouse_id = 1 and p.name like 'OUT/%');
update stock_picking set picking_type_id = 28 where id in 
(select p.id from stock_picking p left join stock_picking_type pt on pt.id = p.picking_type_id left join sale_order s on p.sale_id = s.id where p.stop_delivery and s.block_delivery = 'postponed_delivery_date' and pt.warehouse_id = 2 and p.name like 'OUT/%');
