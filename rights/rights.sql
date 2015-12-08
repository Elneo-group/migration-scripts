--Add purchase and sale pricelist for all users
insert into res_groups_users_rel(uid, gid)
select id,(select id from res_groups where name = 'Purchase Pricelists') from res_users where id not in
(
select u.id from res_users u left join res_groups_users_rel r on r.uid = u.id where gid = (select id from res_groups where name = 'Purchase Pricelists')
);

insert into res_groups_users_rel(uid, gid)
select id,(select id from res_groups where name = 'Sales Pricelists') from res_users where id not in
(
select u.id from res_users u left join res_groups_users_rel r on r.uid = u.id where gid = (select id from res_groups where name = 'Sales Pricelists')
);
