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


update product_product set search_field = null;

select fill_all_product_search();