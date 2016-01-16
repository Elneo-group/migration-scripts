ALTER TABLE res_partner ADD COLUMN search_field character varying(4096);
COMMENT ON COLUMN res_partner.search_field IS 'Search';



CREATE OR REPLACE FUNCTION fill_partner_search_field(IN integer, OUT res integer)
  RETURNS integer AS
$BODY$     
    update res_partner set search_field = search_format_update(req.search)
from (
	select 
		p.id, 
		substr(concat_ws(' | ',p.name, p.ref, p.alias,p.vat,company.name), 0, 4096) as search
	from res_partner p left join res_partner company on company.id = p.commercial_partner_id  
) req
where req.id = res_partner.id
and res_partner.id = $1 RETURNING res_partner.id;
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;



CREATE OR REPLACE FUNCTION fill_all_partner_search(OUT id integer)
  RETURNS SETOF integer AS
$BODY$   
    DECLARE 
        r RECORD;    
    BEGIN    
	FOR r IN SELECT res_partner.id FROM res_partner where active and search_field is null
	LOOP		
		PERFORM fill_partner_search_field(r.id);
	END LOOP;
	RETURN;
    END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;


update res_partner set search_field = null;

select fill_all_partner_search();