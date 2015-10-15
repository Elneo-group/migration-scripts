insert into product_warehouse_detail(product_tmpl_id, warehouse_id, depreciation_policy, warehouse_description, aisle)
select p.product_tmpl_id, 1, depreciation_policy_awans, warehouse_description_awans, aisle_awans from product_product p where p.active;
insert into product_warehouse_detail(product_tmpl_id, warehouse_id, depreciation_policy, warehouse_description, aisle)
select p.product_tmpl_id, 2, depreciation_policy_wetteren, warehouse_description_wetteren, aisle_wetteren from product_product p where p.active;


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