update res_partner set lastname = a.last_name, firstname = a.first_name from res_partner_address a where a.partner_id = res_partner.id;
update res_partner set firstname = split_part(u.name,' ',1), lastname = split_part(u.name,' ',2) from res_users u where u.partner_id = res_partner.id;
update res_partner set ref = name where ref = 'TO CORRECT' and name is not null;