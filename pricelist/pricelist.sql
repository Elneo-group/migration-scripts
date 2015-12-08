DO $$
DECLARE 
DB_BACKUP_FILE varchar;
BEGIN


-- Import cost pricelists

DROP TABLE IF EXISTS import_ir_property;
CREATE TABLE import_ir_property
(
  id serial NOT NULL,
  create_uid integer,
  create_date timestamp without time zone,
  write_date timestamp without time zone,
  write_uid integer,
  value_integer bigint, -- Value
  value_float double precision, -- Value
  name character varying(128), -- Name
  value_text text, -- Value
  res_id character varying(128), -- Resource
  company_id integer, -- Company
  fields_id integer NOT NULL, -- Field
  value_datetime timestamp without time zone, -- Value
  value_binary bytea, -- Value
  value_reference character varying(128), -- Value
  type character varying(16) NOT NULL
);

select val||'ir_property_cost_pricelist.backup' from import_var where name = 'DB_BACKUP_PATH' into DB_BACKUP_FILE;
EXECUTE format('copy import_ir_property from ''%s''',DB_BACKUP_FILE);

INSERT INTO ir_property(
            create_uid, create_date, write_date, write_uid, value_integer_moved0, 
            value_float, value_text, res_id, company_id, fields_id, value_datetime, 
            value_binary, value_reference, type, value_integer, name)
(select create_uid,create_date,write_date,write_uid,value_integer,
	value_float,value_text, res_id, company_id, (select id from ir_model_fields where name = 'cost_price_product_pricelist' and model = 'res.partner'), value_datetime, 
	value_binary, value_reference, type, value_integer, name
from import_ir_property);

END;
$$ LANGUAGE plpgsql;

