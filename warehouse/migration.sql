DO $$
DECLARE 
DB_BACKUP_FILE varchar;
BEGIN


-- Import sequences of picking types

DROP TABLE IF EXISTS import_stock_picking_type_sequence;
CREATE TABLE import_stock_picking_type_sequence
(
  id serial NOT NULL,
  create_uid integer,
  create_date timestamp without time zone,
  write_date timestamp without time zone,
  write_uid integer,
  code character varying(64), -- Code
  name character varying(64) NOT NULL, -- Name
  number_next integer NOT NULL, -- Next Number
  company_id integer, -- Company
  padding integer NOT NULL, -- Number padding
  number_increment integer NOT NULL, -- Increment Number
  prefix character varying, -- Prefix
  active boolean, -- Active
  suffix character varying, -- Suffix
  implementation character varying NOT NULL
)
WITH (
  OIDS=FALSE
);
select val||'stock_picking_type_sequence.backup' from import_var where name = 'DB_BACKUP_PATH' into DB_BACKUP_FILE;
EXECUTE format('copy import_stock_picking_type_sequence from ''%s''',DB_BACKUP_FILE);

insert into ir_sequence(code, name, number_next, company_id, padding, number_increment, prefix, active, suffix, implementation) 
(select code, name, number_next, company_id, padding, number_increment, prefix, active, suffix, implementation from import_stock_picking_type_sequence);

RAISE NOTICE '--1--';

-- INSERT PICKING TYPES
DROP TABLE IF EXISTS import_stock_picking_type;
RAISE NOTICE '--2--';
CREATE TABLE import_stock_picking_type 
(
  id serial NOT NULL,
  code character varying NOT NULL, -- Type of Operation
  create_date timestamp without time zone, -- Created on
  sequence integer, -- Sequence
  color integer, -- Color
  write_uid integer, -- Last Updated by
  create_uid integer, -- Created by
  default_location_dest_id integer, -- Default Destination Location
  warehouse_id integer, -- Warehouse
  sequence_id integer NOT NULL, -- Reference Sequence
  write_date timestamp without time zone, -- Last Updated on
  active boolean, -- Active
  name character varying NOT NULL, -- Picking Type Name
  return_picking_type_id integer, -- Picking Type for Returns
  default_location_src_id integer, -- Default Source Location
  special boolean, -- Special
  need_carrier boolean
)
WITH (
  OIDS=FALSE
);
RAISE NOTICE '--3--';
select val||'stock_picking_type.backup' from import_var where name = 'DB_BACKUP_PATH' into DB_BACKUP_FILE;
RAISE NOTICE '--4--';
EXECUTE format('copy import_stock_picking_type from ''%s''',DB_BACKUP_FILE);
RAISE NOTICE '--5--';



insert into stock_picking_type (id, code, sequence, color, default_location_dest_id, warehouse_id, sequence_id, active, name, return_picking_type_id, default_location_src_id, special, need_carrier) 
(
	select i.id, i.code, 
	i.sequence, 
	i.color, 
	i.default_location_dest_id,
	case when i.warehouse_id in (select id from stock_warehouse) then i.warehouse_id else null end,
	min(seq.id),
	i.active,
	i.name,
	i.return_picking_type_id,
	i.default_location_src_id, 
	i.special, 
	i.need_carrier
	from import_stock_picking_type i left join import_stock_picking_type_sequence iseq left join ir_sequence seq on iseq.name = seq.name on i.sequence_id = iseq.id
	where i.id not in (select id from stock_picking_type) group by i.id, i.code, i.sequence, i.color, i.default_location_dest_id, i.warehouse_id, i.active,	i.name,	i.return_picking_type_id, i.default_location_src_id, i.special, i.need_carrier
);

RAISE NOTICE '--6--';


-- Import stock_location_route
delete from stock_location_route;
select val||'stock_location_route.backup' from import_var where name = 'DB_BACKUP_PATH' into DB_BACKUP_FILE;
EXECUTE format('copy stock_location_route from ''%s''',DB_BACKUP_FILE);

RAISE NOTICE '--7--';

-- Import procurement_rule

delete from procurement_rule;
select val||'procurement_rule.backup' from import_var where name = 'DB_BACKUP_PATH' into DB_BACKUP_FILE;
EXECUTE format('copy procurement_rule from ''%s''',DB_BACKUP_FILE);

RAISE NOTICE '--8--';

-- Import procurement_rule_procure_method
delete from procurement_rule_procure_method;
select val||'procurement_rule_procure_method.backup' from import_var where name = 'DB_BACKUP_PATH' into DB_BACKUP_FILE;
EXECUTE format('copy procurement_rule_procure_method from ''%s''',DB_BACKUP_FILE);

-- Import procurement_rule_procure_method_storage_policy
delete from procurement_rule_procure_method_storage_policy;
select val||'procurement_rule_procure_method_storage_policy.backup' from import_var where name = 'DB_BACKUP_PATH' into DB_BACKUP_FILE;
EXECUTE format('copy procurement_rule_procure_method_storage_policy from ''%s''',DB_BACKUP_FILE);


--Set good warehouse for users
update res_users set default_warehouse_id = 1 where id in (1,5,7,10,13,14,16,17,20,21,22,24,25,26,28,29,30,31,32,34,35,37,38,41,42,49,50,52,54,55,56,57,58,59,60,61,66,68,69,70,71,72,73,74,75,85,88,90,96,97,98,99,100,103,105,108,111,121,122);
update res_users set default_warehouse_id = 2 where id not in (1,5,7,10,13,14,16,17,20,21,22,24,25,26,28,29,30,31,32,34,35,37,38,41,42,49,50,52,54,55,56,57,58,59,60,61,66,68,69,70,71,72,73,74,75,85,88,90,96,97,98,99,100,103,105,108,111,121,122);

--Delete warehouse landefeld 
update sale_order set warehouse_id = u.default_warehouse_id from res_users u where u.id = sale_order.user_id and sale_order.warehouse_id = 3;

update stock_picking set picking_type_id = 6 where id in (select pick.id from stock_picking pick left join sale_order s on s.id = pick.sale_id left join purchase_order p on p.id = pick.purchase_id where pick.picking_type_id = 11 and (s.warehouse_id = 2 or p.warehouse_id = 2));
update stock_picking set picking_type_id = 8 where id in (select pick.id from stock_picking pick left join sale_order s on s.id = pick.sale_id left join purchase_order p on p.id = pick.purchase_id where pick.picking_type_id = 13 and (s.warehouse_id = 2 or p.warehouse_id = 2));
update stock_picking set picking_type_id = 7 where id in (select pick.id from stock_picking pick left join sale_order s on s.id = pick.sale_id left join purchase_order p on p.id = pick.purchase_id where pick.picking_type_id = 12 and (s.warehouse_id = 2 or p.warehouse_id = 2));

update stock_picking set picking_type_id = 1 where id in (select pick.id from stock_picking pick left join sale_order s on s.id = pick.sale_id left join purchase_order p on p.id = pick.purchase_id where pick.picking_type_id = 11);
update stock_picking set picking_type_id = 3 where id in (select pick.id from stock_picking pick left join sale_order s on s.id = pick.sale_id left join purchase_order p on p.id = pick.purchase_id where pick.picking_type_id = 13);
update stock_picking set picking_type_id = 2 where id in (select pick.id from stock_picking pick left join sale_order s on s.id = pick.sale_id left join purchase_order p on p.id = pick.purchase_id where pick.picking_type_id = 12);

delete from stock_picking_type where warehouse_id = 3;

delete from stock_warehouse where id = 3;

END;
$$ LANGUAGE plpgsql;

