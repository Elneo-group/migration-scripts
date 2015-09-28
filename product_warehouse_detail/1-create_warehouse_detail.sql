insert into product_warehouse_detail(product_tmpl_id, warehouse_id, depreciation_policy, warehouse_description, aisle)
select p.product_tmpl_id, 1, depreciation_policy_awans, warehouse_description_awans, aisle_awans from product_product p where p.active;
insert into product_warehouse_detail(product_tmpl_id, warehouse_id, depreciation_policy, warehouse_description, aisle)
select p.product_tmpl_id, 2, depreciation_policy_wetteren, warehouse_description_wetteren, aisle_wetteren from product_product p where p.active;
