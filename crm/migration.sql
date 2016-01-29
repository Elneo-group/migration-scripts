--delete partner_categories
truncate table res_partner_category cascade;

--set good partner for sale, purchase, and invoice
update sale_order set partner_id = p.parent_id from res_partner p 
where sale_order.partner_id = p.id
and (not p.is_company or p.is_company is null) and p.parent_id is not null;

update purchase_order set partner_id = p.parent_id from res_partner p 
where purchase_order.partner_id = p.id
and (not p.is_company or p.is_company is null) and p.parent_id is not null;

update account_invoice set partner_id = p.parent_id from res_partner p 
where account_invoice.partner_id = p.id
and (not p.is_company or p.is_company is null) and p.parent_id is not null;


-- Set good members in sale teams
delete from sale_member_rel;
insert into sale_member_rel (section_id, member_id) 
select default_section_id, id from res_users where default_section_id is not null;

--Set good attendee list depending on user
insert into calendar_event_res_partner_rel(calendar_event_id,res_partner_id)
(
select e.id, u.partner_id from calendar_event e 
	left join res_users u on e.user_id = u.id
	left join calendar_event_res_partner_rel rel on rel.calendar_event_id = e.id
where rel.res_partner_id is null
);


--Manage calendar event
truncate table calendar_event_type cascade;
insert into calendar_event_type(id,name) 
select id,name from crm_case_categ;

SELECT setval('public.calendar_event_type_id_seq', (select max(id)+1 from calendar_event_type), true);

insert into meeting_category_rel(event_id, type_id)
select id, categ_id from calendar_event where categ_id is not null;
