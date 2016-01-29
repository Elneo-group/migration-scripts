
update report_paperformat set 
header_spacing = 30, 
margin_right = 9, 
margin_left = 9, 
margin_top = 30, 
margin_bottom = 28
where name = 'European A4';


--Reports : disable old reports
delete from ir_act_report_xml where report_type not in ('qweb-pdf','qweb-html','controller');

delete from ir_values where id in 
(
select ir_values.id from ir_values left join ir_act_report_xml r on r.id = split_part(value,',',2)::INT where key = 'action' and key2 = 'client_print_multi' and value like 'ir.actions.report.xml,%' and r.id is null
);

-- add users to user warehouse flows
insert into res_groups_users_rel
select u.id, g.id 
from res_groups g, res_users u 
where g.name = 'Manage Push and Pull inventory flows'
and (u.id, g.id) not in (select uid, gid from res_groups_users_rel)
;


--Set good sequence implementation
update ir_sequence set implementation = 'no_gap';


update stock_picking set section_id = null;



-- SET GOOD CATEGORY FOR UNIT OF MEASURE PCE
UPDATE product_uom SET category_id = 1 WHERE id = 1;


-- Set default order_policy (sales)
update ir_values set value = 'S''picking''
p0
.' where name = 'order_policy';


--delete predefined filters
delete from ir_filters where name like 'Unassigned%';


-- UPDATE PURCHASE LINES SET CANCEL IF PURCHASE IS CANCELLED
UPDATE purchase_order_line SET state = 'cancel'
WHERE id IN
(SELECT pol.id FROM purchase_order_line pol
JOIN purchase_order po ON pol.order_id = po.id
WHERE po.state = 'cancel'
AND pol.state != 'cancel');


-- add commitment date field to increase speed of sale_order_dates installation
DO
$$
BEGIN
IF NOT EXISTS (SELECT column_name 
               FROM information_schema.columns 
               WHERE table_schema='public' and table_name='sale_order' and column_name='commitment_date') THEN
ALTER TABLE sale_order ADD COLUMN commitment_date timestamp without time zone;
COMMENT ON COLUMN sale_order.commitment_date IS 'Commitment Date';
END IF;                                      
END
$$;

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


--- IN ELNEO SALE WE GET BACK TO OLD BEHAVIOUR WITH PRODUCT DESCRIPTION_SALE
--- WE ADD A FIELD NOTES (SO WE HAVE TO SUBSTRACT NOTE FROM DESCRIPTION)
UPDATE sale_order_line SET name = req1.name
FROM
(SELECT id as id, SUBSTRING(name from 0 for position(chr(10) || notes in name)) as name FROM sale_order_line WHERE position(chr(10) || notes in name) IS NOT NULL AND position(chr(10) || notes in name) <> 0 AND notes IS NOT NULL)req1
WHERE sale_order_line.id = req1.id;



ALTER TABLE sale_order ADD COLUMN margin_elneo double precision;
COMMENT ON COLUMN sale_order.margin_elneo IS 'Margin';
ALTER TABLE sale_order ADD COLUMN margin_elneo_coeff double precision;
COMMENT ON COLUMN sale_order.margin_elneo_coeff IS 'Margin (Coeff)';
ALTER TABLE sale_order_line ADD COLUMN margin_elneo double precision;
COMMENT ON COLUMN sale_order_line.margin_elneo IS 'Margin';
