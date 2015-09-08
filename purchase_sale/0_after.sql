-- INSERT SALE / PURCHASE LINKS BASED ON STOCK_MOVES
INSERT INTO purchase_sale_rel (purchase_id, sale_id)
SELECT DISTINCT purch, sal FROM
(
select pick_in.purchase_id purch, pick_out.sale_id sal
from 
stock_move move_in left join stock_picking pick_in on move_in.picking_id = pick_in.id
left join stock_move move_int left join stock_picking pick_int on move_int.picking_id = pick_int.id on move_in.move_dest_id = move_int.id
left join stock_move move_out left join stock_picking pick_out on move_out.picking_id = pick_out.id on move_int.move_dest_id = move_out.id
where pick_in.type = 'in' and pick_int.type = 'internal' and pick_out.type = 'out'
order by move_in.id asc
) req1
WHERE NOT EXISTS (SELECT 1 FROM purchase_sale_rel psr WHERE psr.sale_id = req1.sal AND psr.purchase_id = req1.purch) AND purch IS NOT NULL AND sal IS NOT NULL;


-- INSERT OLD SALE_PURCHASE LINKS WITH NON CONFIRMED PURCHASES
;with tmp(name ,id, origin) as (
select name, id, LEFT(origin, position(' ' in origin||' ')-1),
    overlay(origin placing '' from 1 for position(' ' in origin||' '))
from purchase_order po
union all
select name, id, LEFT(origin, position(' ' in origin||' ')-1),
    overlay(origin placing '' from 1 for position(' ' in origin||' '))
from purchase_order po
where origin > ''
)
INSERT INTO purchase_sale_rel (sale_id, purchase_id)
select so.id sale_id, req1.id purchase_id FROM sale_order so, (select DISTINCT id, name, origin
from tmp
WHERE origin IS NOT NULL
AND ((substring(origin from 1 for 2) = 'SO' AND char_length(origin) > 4) OR (substring(origin from 1 for 5) = 'AC-SO' AND char_length(origin) > 7))
order by id DESC) req1 WHERE so.name = req1.origin AND NOT EXISTS (SELECT 1 FROM purchase_sale_rel psr WHERE req1.id = psr.purchase_id AND psr.sale_id = so.id);