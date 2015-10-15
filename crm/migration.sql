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

