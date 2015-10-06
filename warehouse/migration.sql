DO $$
DECLARE 
DB_BACKUP_FILE varchar;
BEGIN

delete from stock_picking_type where id = 16;

--create import tables
DROP TABLE IF EXISTS import_stock_location_route;
DROP TABLE IF EXISTS import_stock_picking_type;
DROP TABLE IF EXISTS import_procurement_rule;
DROP TABLE IF EXISTS import_procurement_rule_procure_method;
DROP TABLE IF EXISTS import_procurement_rule_procure_method_storage_policy;

CREATE TABLE import_stock_location_route
(
  id serial NOT NULL,
  supplier_wh_id integer, -- Supplier Warehouse
  create_uid integer, -- Created by
  create_date timestamp without time zone, -- Created on
  name character varying NOT NULL, -- Route Name
  sequence integer, -- Sequence
  warehouse_selectable boolean, -- Applicable on Warehouse
  company_id integer, -- Company
  supplied_wh_id integer, -- Supplied Warehouse
  product_selectable boolean, -- Applicable on Product
  product_categ_selectable boolean, -- Applicable on Product Category
  write_date timestamp without time zone, -- Last Updated on
  active boolean, -- Active
  write_uid integer, 
  sale_selectable boolean
)
WITH (
  OIDS=FALSE
);

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
  default_location_src_id integer -- Default Source Location
)
WITH (
  OIDS=FALSE
);


CREATE TABLE import_procurement_rule
(
  id serial NOT NULL,
  create_uid integer, -- Created by
  create_date timestamp without time zone, -- Created on
  name character varying NOT NULL, -- Name
  sequence integer, -- Sequence
  company_id integer, -- Company
  write_uid integer, -- Last Updated by
  action character varying NOT NULL, -- Action
  write_date timestamp without time zone, -- Last Updated on
  active boolean, -- Active
  group_id integer, -- Fixed Procurement Group
  group_propagation_option character varying, -- Propagation of Procurement Group
  partner_address_id integer, -- Partner Address
  location_id integer, -- Procurement Location
  location_src_id integer, -- Source Location
  picking_type_id integer, -- Picking Type
  delay integer, -- Number of Days
  warehouse_id integer, -- Served Warehouse
  propagate boolean, -- Propagate cancel and split
  procure_method character varying NOT NULL, -- Move Supply Method
  route_sequence numeric, -- Route Sequence
  route_id integer, -- Route
  propagate_warehouse_id integer, -- Warehouse to Propagate
  invoice_state character varying, -- Invoice Status
  autovalidate_dest_move boolean
)
WITH (
  OIDS=FALSE
);




CREATE TABLE import_procurement_rule_procure_method
(
  id serial NOT NULL,
  create_uid integer, -- Created by
  use_if_enough_stock boolean, -- Use if enough stock
  location_src_id integer, -- Source location
  name character varying(255), -- Name
  sequence integer, -- Sequence
  sub_route_id integer, -- Sub-route
  partner_address_id integer, -- Partner address
  write_uid integer, -- Last Updated by
  delay integer, -- Delay (days)
  write_date timestamp without time zone, -- Last Updated on
  procure_method character varying NOT NULL, -- Move Supply Method
  create_date timestamp without time zone, -- Created on
  rule_id integer, -- Rule
  warehouse_src_id integer, -- Source warehouse
  sub_route_quantity_check_location_id integer
)
WITH (
  OIDS=FALSE
);

CREATE TABLE import_procurement_rule_procure_method_storage_policy
(
  id serial NOT NULL,
  create_uid integer, -- Created by
  create_date timestamp without time zone, -- Created on
  name character varying, -- Storage policy
  write_uid integer, -- Last Updated by
  write_date timestamp without time zone, -- Last Updated on
  procure_method_id integer
)
WITH (
  OIDS=FALSE
);


select val||'stock_location_route.backup' from import_var where name = 'DB_BACKUP_PATH' into DB_BACKUP_FILE;
EXECUTE format('copy import_stock_location_route from ''%s''',DB_BACKUP_FILE);

select val||'stock_picking_type.backup' from import_var where name = 'DB_BACKUP_PATH' into DB_BACKUP_FILE;
EXECUTE format('copy import_stock_picking_type from ''%s''',DB_BACKUP_FILE);

select val||'procurement_rule.backup' from import_var where name = 'DB_BACKUP_PATH' into DB_BACKUP_FILE;
EXECUTE format('copy import_procurement_rule from ''%s''',DB_BACKUP_FILE);

select val||'procurement_rule_procure_method.backup' from import_var where name = 'DB_BACKUP_PATH' into DB_BACKUP_FILE;
EXECUTE format('copy import_procurement_rule_procure_method from ''%s''',DB_BACKUP_FILE);

select val||'procurement_rule_procure_method_storage_policy.backup' from import_var where name = 'DB_BACKUP_PATH' into DB_BACKUP_FILE;
EXECUTE format('copy import_procurement_rule_procure_method_storage_policy from ''%s''',DB_BACKUP_FILE);


update stock_location_route set 
supplier_wh_id = i.supplier_wh_id,
name = i.name, 
sequence = i.sequence,
warehouse_selectable = i.warehouse_selectable,
company_id = i.company_id,
supplied_wh_id = i.supplied_wh_id, 
product_selectable = i.product_selectable, 
product_categ_selectable = i.product_categ_selectable, 
write_date = i.write_date, 
active = i.active, 
sale_selectable = i.sale_selectable
from import_stock_location_route i
where i.id = stock_location_route.id;
insert into stock_location_route (select * from import_stock_location_route where id not in (select id from stock_location_route));

update stock_picking_type set 
code = i.code,
  sequence = i.sequence,
  color = i.color,
  default_location_dest_id = i.default_location_dest_id,
  warehouse_id = i.warehouse_id,
  sequence_id = i.sequence_id,
  active = i.active,
  name = i.name,
  return_picking_type_id = i.return_picking_type_id,
  default_location_src_id = i.default_location_src_id
from import_stock_picking_type i
where i.id = stock_picking_type.id;
insert into stock_picking_type (select * from import_stock_picking_type where id not in (select id from stock_picking_type));

update procurement_rule set 
name = i.name,
  sequence = i.sequence,
  company_id = i.company_id,
  action = i.action,
  active = i.active,
  group_id = i.group_id,
  group_propagation_option = i.group_propagation_option,
  partner_address_id = i.partner_address_id,
  location_id = i.location_id,
  location_src_id  = i.location_src_id,
  picking_type_id = i.picking_type_id,
  delay = i.delay,
  warehouse_id = i.warehouse_id,
  propagate = i.propagate,
  procure_method = i.procure_method,
  route_sequence = i.route_sequence,
  route_id = i.route_id,
  propagate_warehouse_id = i.propagate_warehouse_id,
  invoice_state = i.invoice_state,
  autovalidate_dest_move = i.autovalidate_dest_move
from import_procurement_rule i
where i.id = procurement_rule.id;
insert into procurement_rule (select * from import_procurement_rule where id not in (select id from procurement_rule));

update procurement_rule_procure_method set 
use_if_enough_stock = i.use_if_enough_stock,
  location_src_id = i.location_src_id,
  name = i.name,
  sequence = i.sequence,
  sub_route_id = i.sub_route_id,
  partner_address_id = i.partner_address_id,
  delay = i.delay,
  procure_method = i.procure_method,
  rule_id = i.rule_id,
  warehouse_src_id = i.warehouse_src_id,
  sub_route_quantity_check_location_id = i.sub_route_quantity_check_location_id
from import_procurement_rule_procure_method i
where i.id = procurement_rule_procure_method.id;
insert into procurement_rule_procure_method (select * from import_procurement_rule_procure_method where id not in (select id from procurement_rule_procure_method));

update procurement_rule_procure_method_storage_policy set 
name = i.name,
procure_method_id = i.procure_method_id
from import_procurement_rule_procure_method_storage_policy i
where i.id = procurement_rule_procure_method_storage_policy.id;
insert into procurement_rule_procure_method_storage_policy (select * from import_procurement_rule_procure_method_storage_policy where id not in (select id from procurement_rule_procure_method_storage_policy));


END;
$$ LANGUAGE plpgsql;
