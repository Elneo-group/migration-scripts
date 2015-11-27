-- SET GOOD sale_line_id BETWEEN FORMER stock_move AND procurement_order
UPDATE procurement_order SET sale_line_id = req1.sale_line_id
FROM
(SELECT procurement_id, sale_line_id FROM stock_move
WHERE sale_line_id IS NOT NULL
AND procurement_id IS NOT NULL) req1
WHERE req1.procurement_id = procurement_order.id;


-- SET GOOD purchase_line_id BETWEEN FORMER stock_move AND procurement_order
UPDATE procurement_order SET purchase_line_id = req1.purchase_line_id
FROM
(SELECT procurement_id, purchase_line_id, sale_line_id FROM stock_move
WHERE purchase_line_id IS NOT NULL
AND procurement_id IS NOT NULL) req1
WHERE req1.procurement_id = procurement_order.id;