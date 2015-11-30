-- SET GOOD state for purchases that are done but lines not
UPDATE purchase_order_line SET state = 'done'
FROM
(SELECT pol.id AS id FROM purchase_order_line pol
JOIN purchase_order po ON po.id = pol.order_id
WHERE pol.state != 'done' AND po.state = 'done') req1
WHERE purchase_order_line.id = req1.id