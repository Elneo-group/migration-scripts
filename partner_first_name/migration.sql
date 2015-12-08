update res_partner set lastname = a.last_name, firstname = a.first_name from res_partner_address a where a.partner_id = res_partner.id;
update res_partner set firstname = split_part(u.name,' ',1), lastname = split_part(u.name,' ',2) from res_users u where u.partner_id = res_partner.id;
update res_partner set ref = name where ref = 'TO CORRECT' and name is not null;

--Correct PARTNER WITH NO NAME
update res_partner set active = False where id in
(
select c.id from res_partner c left join res_partner p on c.parent_id = p.id where c.name = 'PARTNER WITH NO NAME' and c.street = p.street
)

update res_partner set name = NULL where name = 'PARTNER WITH NO NAME';