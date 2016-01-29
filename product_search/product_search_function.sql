ALTER TABLE product_product ADD COLUMN search_field character varying(4096);
COMMENT ON COLUMN product_product.search_field IS 'Search';




CREATE OR REPLACE FUNCTION fill_product_search_field(IN integer, OUT res integer)
  RETURNS integer AS
$BODY$     
    update product_product set search_field = search_format_update(req.search), search_default_code = search_format(req.default_code)
from (select product_product.id, substr(concat_ws(' | ',product_product.default_code, product_template.name, product_product.alias, string_agg(product_supplierinfo.product_name,' | '),
string_agg(product_supplierinfo.product_code, ' | '), string_agg(name_translation.value, ' | ')), 0, 4096) as search, product_product.default_code as default_code
from product_product 
left join product_template
	left join product_supplierinfo on product_supplierinfo.product_tmpl_id = product_template.id 
	left join ir_translation name_translation on name_translation.res_id = product_template.id and name_translation.name = 'product.template,name' 
on product_product.product_tmpl_id = product_template.id 
group by product_product.id, product_template.id
) req
where req.id = product_product.id
and product_product.id = $1 RETURNING product_product.id;
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;


CREATE OR REPLACE FUNCTION fill_all_product_search(OUT id integer)
  RETURNS SETOF integer AS
$BODY$   
    DECLARE 
        r RECORD;    
    BEGIN    
	FOR r IN SELECT product_product.id FROM product_product where active and search_field is null
	LOOP		
		PERFORM fill_product_search_field(r.id);
	END LOOP;
	RETURN;
    END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;






CREATE OR REPLACE FUNCTION fill_trg_product_product()
  RETURNS trigger AS
$BODY$
    BEGIN	
	IF (TG_OP = 'DELETE') THEN		
            perform fill_product_search_field(OLD.id);
            RETURN OLD;
        ELSIF (TG_OP = 'UPDATE' OR TG_OP = 'INSERT') THEN	
            perform fill_product_search_field(NEW.id);
            RETURN NEW;        
        END IF;   

        return null;     
        
    END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


CREATE OR REPLACE FUNCTION fill_trg_ir_translation()
  RETURNS trigger AS
$BODY$
    DECLARE 
        product_id int;
    BEGIN	

	IF (TG_OP = 'DELETE') THEN		
		select into product_id p.id 
		from ir_translation t 
		left join product_product p 
		on t.res_id = p.product_tmpl_id and t.name = 'product.template,name' 
		where t.id = old.id;	
		perform fill_product_search_field(product_id);
		return old;
        ELSIF (TG_OP = 'UPDATE' OR TG_OP = 'INSERT') THEN	
		select into product_id p.id 
		from ir_translation t 
		left join product_product p 
		on t.res_id = p.product_tmpl_id and t.name = 'product.template,name' 
		where t.id = NEW.id;	
		perform fill_product_search_field(product_id);
		return new;
        END IF;   

        return null;  
    
	
    END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


CREATE OR REPLACE FUNCTION fill_trg_product_supplierinfo()
  RETURNS trigger AS
$BODY$
    DECLARE 
        product_id int;
    BEGIN	
	IF (TG_OP = 'DELETE') THEN		
		select into product_id p.id from product_supplierinfo ps left join product_product p on p.product_tmpl_id = ps.product_id where ps.id = old.id;
		perform fill_product_search_field(product_id);
		return old;
        ELSIF (TG_OP = 'UPDATE' OR TG_OP = 'INSERT') THEN	
		select into product_id p.id from product_supplierinfo ps left join product_product p on p.product_tmpl_id = ps.product_id where ps.id = NEW.id;
		perform fill_product_search_field(product_id);
		return new;
        END IF;   

        return null;  
    
	
    END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION fill_trg_product_supplierinfo()
  OWNER TO openerp;


DROP TRIGGER IF EXISTS trg_search_product_product ON product_product;
CREATE TRIGGER trg_search_product_product
  AFTER INSERT OR DELETE
  ON product_product
  FOR EACH ROW
  EXECUTE PROCEDURE fill_trg_product_product();

DROP TRIGGER IF EXISTS trg_search_product_product_update ON product_product;
CREATE TRIGGER trg_search_product_product_update
  AFTER UPDATE
  ON product_product
  FOR EACH ROW
  WHEN ((((old.alias)::text IS DISTINCT FROM (new.alias)::text) OR ((old.default_code)::text IS DISTINCT FROM (new.default_code)::text)))
  EXECUTE PROCEDURE fill_trg_product_product();

DROP TRIGGER IF EXISTS trg_search_ir_translation ON ir_translation;
CREATE TRIGGER trg_search_ir_translation
  AFTER INSERT OR DELETE
  ON ir_translation
  FOR EACH ROW
  EXECUTE PROCEDURE fill_trg_ir_translation();

DROP TRIGGER IF EXISTS trg_search_ir_translation_update ON ir_translation;
CREATE TRIGGER trg_search_ir_translation_update
  AFTER UPDATE
  ON ir_translation
  FOR EACH ROW
  WHEN ((((new.name)::text = 'product.template,name'::text) AND (old.value IS DISTINCT FROM new.value)))
  EXECUTE PROCEDURE fill_trg_ir_translation();

DROP TRIGGER IF EXISTS trg_search_product_supplierinfo ON product_supplierinfo;
CREATE TRIGGER trg_search_product_supplierinfo
  AFTER INSERT OR DELETE
  ON product_supplierinfo
  FOR EACH ROW
  EXECUTE PROCEDURE fill_trg_product_supplierinfo();

DROP TRIGGER IF EXISTS trg_search_product_supplierinfo_update ON product_supplierinfo;
CREATE TRIGGER trg_search_product_supplierinfo_update
  AFTER UPDATE
  ON product_supplierinfo
  FOR EACH ROW
  WHEN ((((old.product_name)::text IS DISTINCT FROM (new.product_name)::text) OR ((old.product_code)::text IS DISTINCT FROM (new.product_code)::text)))
  EXECUTE PROCEDURE fill_trg_product_supplierinfo();

update product_product set search_field = null;

select fill_all_product_search();
