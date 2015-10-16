DO $$
DECLARE 
DB_BACKUP_FILE varchar;
BEGIN

truncate table res_partner_res_partner_nace_rel;
insert into res_partner_res_partner_nace_rel
select distinct o_rel.partner_id,n.id
from res_partner_nace n 
left join nace_code o on regexp_replace(n.code, '[^1-9]', '', 'g') = regexp_replace(o.name, '[^1-9]', '', 'g')
left join res_partner_nace_code_rel o_rel on o.id = o_rel.nace_id
where o.id in (select nace_id from res_partner_nace_code_rel) and o.id != 655;


END;
$$ LANGUAGE plpgsql;
