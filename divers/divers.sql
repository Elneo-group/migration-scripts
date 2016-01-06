
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