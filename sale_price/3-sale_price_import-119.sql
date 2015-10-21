delete from product_discount_type;
truncate table customer_discount_exception;
truncate table elneo_autocompute_saleprice_category_coefficientlist;
truncate table discount_type_discount;
truncate table product_group_discount;

DROP TABLE elneo_autocompute_saleprice_category_coefficientlist;

CREATE TABLE elneo_autocompute_saleprice_category_coefficientlist
(
  id serial NOT NULL,
  create_uid integer,
  create_date timestamp without time zone,
  write_date timestamp without time zone,
  write_uid integer,
  coefficient double precision, -- Coefficient
  categ_id integer, -- Category of Product
  partner_id integer, -- Partner
  is_brutprice boolean, -- Is Same as Brut Price
  CONSTRAINT elneo_autocompute_saleprice_category_coefficientlist_pkey PRIMARY KEY (id),
  CONSTRAINT elneo_autocompute_saleprice_category_coefficien_create_uid_fkey FOREIGN KEY (create_uid)
      REFERENCES res_users (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT elneo_autocompute_saleprice_category_coefficien_partner_id_fkey FOREIGN KEY (partner_id)
      REFERENCES res_partner (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT elneo_autocompute_saleprice_category_coefficient_write_uid_fkey FOREIGN KEY (write_uid)
      REFERENCES res_users (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT elneo_autocompute_saleprice_category_coefficientl_categ_id_fkey FOREIGN KEY (categ_id)
      REFERENCES product_category (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE SET NULL
)
WITH (
  OIDS=FALSE
);
ALTER TABLE elneo_autocompute_saleprice_category_coefficientlist
  OWNER TO openerp;
COMMENT ON TABLE elneo_autocompute_saleprice_category_coefficientlist
  IS 'List of coefficient for partner and product category ';
COMMENT ON COLUMN elneo_autocompute_saleprice_category_coefficientlist.coefficient IS 'Coefficient';
COMMENT ON COLUMN elneo_autocompute_saleprice_category_coefficientlist.categ_id IS 'Category of Product';
COMMENT ON COLUMN elneo_autocompute_saleprice_category_coefficientlist.partner_id IS 'Partner';
COMMENT ON COLUMN elneo_autocompute_saleprice_category_coefficientlist.is_brutprice IS 'Is Same as Brut Price';

ALTER TABLE product_discount_type DROP COLUMN create_uid;

ALTER TABLE product_discount_type ADD COLUMN create_uid integer;
COMMENT ON COLUMN product_discount_type.create_uid IS 'Created by';

ALTER TABLE product_discount_type DROP COLUMN create_date;

ALTER TABLE product_discount_type ADD COLUMN create_date timestamp without time zone;
COMMENT ON COLUMN product_discount_type.create_date IS 'Created on';

ALTER TABLE product_discount_type DROP COLUMN write_date;

ALTER TABLE product_discount_type ADD COLUMN write_date timestamp without time zone;
COMMENT ON COLUMN product_discount_type.write_date IS 'Last Updated on';

ALTER TABLE product_discount_type DROP COLUMN write_uid;

ALTER TABLE product_discount_type ADD COLUMN write_uid integer;
COMMENT ON COLUMN product_discount_type.write_uid IS 'Last Updated by';

ALTER TABLE product_discount_type DROP COLUMN name;

ALTER TABLE product_discount_type ADD COLUMN name character varying;
COMMENT ON COLUMN product_discount_type.name IS 'name';

ALTER TABLE discount_type_discount DROP COLUMN create_uid;

ALTER TABLE discount_type_discount ADD COLUMN create_uid integer;

ALTER TABLE discount_type_discount DROP COLUMN create_date;

ALTER TABLE discount_type_discount ADD COLUMN create_date timestamp without time zone;

ALTER TABLE discount_type_discount DROP COLUMN write_date;

ALTER TABLE discount_type_discount ADD COLUMN write_date timestamp without time zone;

ALTER TABLE discount_type_discount DROP COLUMN write_uid;

ALTER TABLE discount_type_discount ADD COLUMN write_uid integer;

ALTER TABLE discount_type_discount DROP COLUMN margin_max;

ALTER TABLE discount_type_discount ADD COLUMN margin_max double precision;
COMMENT ON COLUMN discount_type_discount.margin_max IS 'Maximum margin';

ALTER TABLE discount_type_discount DROP COLUMN discount_type_id;

ALTER TABLE discount_type_discount ADD COLUMN discount_type_id integer;
COMMENT ON COLUMN discount_type_discount.discount_type_id IS 'Discount type';

ALTER TABLE discount_type_discount DROP COLUMN margin_min;

ALTER TABLE discount_type_discount ADD COLUMN margin_min double precision;
COMMENT ON COLUMN discount_type_discount.margin_min IS 'Minimum margin';

ALTER TABLE discount_type_discount DROP COLUMN discount_percent;

ALTER TABLE discount_type_discount ADD COLUMN discount_percent double precision;
COMMENT ON COLUMN discount_type_discount.discount_percent IS 'Discount (percent)';

ALTER TABLE product_group_discount DROP COLUMN create_uid;

ALTER TABLE product_group_discount ADD COLUMN create_uid integer;

ALTER TABLE product_group_discount DROP COLUMN create_date;

ALTER TABLE product_group_discount ADD COLUMN create_date timestamp without time zone;

ALTER TABLE product_group_discount DROP COLUMN write_date;

ALTER TABLE product_group_discount ADD COLUMN write_date timestamp without time zone;

ALTER TABLE product_group_discount DROP COLUMN write_uid;

ALTER TABLE product_group_discount ADD COLUMN write_uid integer;

ALTER TABLE product_group_discount DROP COLUMN discount;

ALTER TABLE product_group_discount ADD COLUMN discount double precision;
COMMENT ON COLUMN product_group_discount.discount IS 'Discount (%)';

ALTER TABLE product_group_discount DROP COLUMN product_group_id;

ALTER TABLE product_group_discount ADD COLUMN product_group_id integer;
COMMENT ON COLUMN product_group_discount.product_group_id IS 'Product group';

ALTER TABLE product_group_discount DROP COLUMN discount_type_id;

ALTER TABLE product_group_discount ADD COLUMN discount_type_id integer;
COMMENT ON COLUMN product_group_discount.discount_type_id IS 'Discount type';

CREATE TEMP TABLE import_partner_discount_type
(
partner_id integer, 
discount_type_id integer
);

copy product_discount_type from '/home/elneo/product_discount_type.backup';
copy customer_discount_exception from '/home/elneo/customer_discount_exception.backup';
copy elneo_autocompute_saleprice_category_coefficientlist from '/home/elneo/elneo_autocompute_saleprice_category_coefficientlist.backup';
copy discount_type_discount from '/home/elneo/discount_type_discount.backup';
copy product_group_discount from '/home/elneo/product_group_discount.backup';
copy import_partner_discount_type from '/home/elneo/partner_discount_type.backup';


CREATE TEMP TABLE import_ir_property
(
  id integer,
  create_uid integer,
  create_date timestamp without time zone,
  write_date timestamp without time zone,
  write_uid integer,
  value_integer integer,
  value_float double precision, -- Value
  name character varying, -- Name
  value_text text, -- Value
  res_id character varying, -- Resource
  company_id integer, -- Company
  fields_id integer NOT NULL, -- Field
  value_datetime timestamp without time zone, -- Value
  value_binary bytea, -- Value
  value_reference character varying, -- Value
  type character varying NOT NULL -- Type
);


copy import_ir_property from '/home/elneo/property_cost_price_product_pricelist.backup';

update import_ir_property set fields_id = f.id from ir_model_fields f where f.name = 'cost_price_product_pricelist' and f.model = 'res.partner';

insert into ir_property(create_uid, create_date, write_date, write_uid, 
       value_float, name, value_text, res_id, company_id, fields_id, 
       value_datetime, value_binary, value_reference, type, value_integer)
select i.create_uid, i.create_date, i.write_date, i.write_uid, 
       i.value_float, i.name, i.value_text, i.res_id, i.company_id, i.fields_id, 
       i.value_datetime, i.value_binary, i.value_reference, i.type, i.value_integer 
from import_ir_property i left join ir_property p on p.res_id = i.res_id where p.id is null;


update res_partner set discount_type_id = i.discount_type_id from import_partner_discount_type i where i.partner_id = res_partner.id;


update product_template set cost_price = pp.cost_price from product_product pp where pp.product_tmpl_id = product_template.id and pp.cost_price != 0 and pp.cost_price != product_template.cost_price and product_template.cost_price is not null;

update product_template set 
sale_price_fixed = p.sale_price_fixed, 
compute_sale_price = p.compute_sale_price, 
sale_price_seller = p.sale_price_seller
from product_product p 
where p.product_tmpl_id = product_template.id;
