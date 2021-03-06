-- Set fake product supplier info for all product without
insert into product_supplierinfo (name, product_tmpl_id, delay, min_qty) 
select 1,p.product_tmpl_id,1,1 from product_product p left join product_supplierinfo ps on ps.product_tmpl_id = p.product_tmpl_id where ps.id is null;


insert into product_warehouse_detail(product_id, warehouse_id, depreciation_policy, warehouse_description, aisle)
select p.id, 1, depreciation_policy_awans, warehouse_description_awans, aisle_awans 
from product_product p left join product_warehouse_detail pwd on (pwd.product_id = p.id and pwd.warehouse_id = 1) where p.active and pwd.id is null;


insert into product_warehouse_detail(product_id, warehouse_id, depreciation_policy, warehouse_description, aisle)
select p.id, 2, depreciation_policy_wetteren, warehouse_description_wetteren, aisle_wetteren 
from product_product p left join product_warehouse_detail pwd on (pwd.product_id = p.id and pwd.warehouse_id = 2) where p.active and pwd.id is null;


--Set categ_*** fields


update product_template 
set 
categ_dpt = d.name, 
categ_group = g.name, 
categ_family = f.name, 
categ_subfamily = subf.name
from product_category subf 
	left join product_category f 
		left join product_category g
			left join product_category d
			on g.parent_id = d.id
		on f.parent_id = g.id
	on subf.parent_id = f.id
where subf.id = product_template.categ_id and d.id is not null and d.parent_id is null;


update product_template 
set 
categ_dpt = d.name, 
categ_group = g.name, 
categ_family = f.name
from product_category f 
	left join product_category g
		left join product_category d
		on g.parent_id = d.id
	on f.parent_id = g.id
where f.id = product_template.categ_id and d.id is not null and d.parent_id is null;

update product_template 
set 
categ_dpt = d.name, 
categ_group = g.name
from product_category g
	left join product_category d
	on g.parent_id = d.id	
where g.id = product_template.categ_id and d.id is not null and d.parent_id is null;


update product_template 
set 
categ_dpt = d.name
from product_category d	
where d.id = product_template.categ_id and d.id is not null and d.parent_id is null;