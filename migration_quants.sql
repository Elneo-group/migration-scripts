update stock_move set product_qty = product_qty_old;



INSERT INTO stock_inventory(
            create_uid, create_date, write_date, write_uid, name, date_done, 
            date, company_id, location_id, state, lot_id, package_id, partner_id, 
            filter, product_id, period_id)
    VALUES (1, now(), now(), 1, 'Import migration Awans', null, 
            now(), 1, 15, 'confirm', null, null, null, 
            'partial', null, null);



INSERT INTO stock_inventory_line(
            create_uid, create_date, write_date, write_uid, product_id, 
            product_uom_id, prod_lot_id, company_id, inventory_id, product_qty, 
            location_id, theoretical_qty, prodlot_name, product_name, location_name, 
            package_id, product_code, partner_id)

SELECT 1, now(), now(), 1, q1.product_id, 
	1, null, 1, (select max(id) from stock_inventory), round(sum(q1.qty_a), 2), 
	15, 0, null, name, 'Awans', 
	null, default_code, null
   FROM              (         SELECT product_product.id AS product_id, product_product.default_code, product_template.name, sum(stock_move.product_qty) AS qty_a
                                           FROM product_product left join product_template on product_product.product_tmpl_id = product_template.id
                                      LEFT JOIN stock_move ON stock_move.product_id = product_product.id
                                     WHERE product_product.active AND stock_move.location_dest_id = 15 AND stock_move.state::text = 'done'::text
                                     GROUP BY product_product.default_code, product_product.id, product_template.name
                                UNION 
                                         SELECT product_product.id AS product_id, product_product.default_code, product_template.name, - sum(stock_move.product_qty) AS qty_a
                                           FROM product_product left join product_template on product_product.product_tmpl_id = product_template.id
                                      LEFT JOIN stock_move ON stock_move.product_id = product_product.id
                                     WHERE product_product.active AND stock_move.location_id = 15 AND stock_move.state::text = 'done'::text
                                     GROUP BY product_product.default_code, product_product.id, product_template.name)
           q1
  GROUP BY q1.product_id, q1.default_code, q1.name
  HAVING sum(q1.qty_a) > 0
  ORDER BY q1.product_id;
  



INSERT INTO stock_inventory(
            create_uid, create_date, write_date, write_uid, name, date_done, 
            date, company_id, location_id, state, lot_id, package_id, partner_id, 
            filter, product_id, period_id)
    VALUES (1, now(), now(), 1, 'Import migration Wetteren', null, 
            now(), 1, 16, 'confirm', null, null, null, 
            'partial', null, null);



INSERT INTO stock_inventory_line(
            create_uid, create_date, write_date, write_uid, product_id, 
            product_uom_id, prod_lot_id, company_id, inventory_id, product_qty, 
            location_id, theoretical_qty, prodlot_name, product_name, location_name, 
            package_id, product_code, partner_id)

SELECT 1, now(), now(), 1, q1.product_id, 
	1, null, 1, (select max(id) from stock_inventory), round(sum(q1.qty_w), 2), 
	16, 0, null, name, 'Wetteren', 
	null, default_code, null
   FROM              (         SELECT product_product.id AS product_id, product_product.default_code, product_template.name, sum(stock_move.product_qty) AS qty_w
                                           FROM product_product left join product_template on product_product.product_tmpl_id = product_template.id
                                      LEFT JOIN stock_move ON stock_move.product_id = product_product.id
                                     WHERE product_product.active AND stock_move.location_dest_id = 16 AND stock_move.state::text = 'done'::text
                                     GROUP BY product_product.default_code, product_product.id, product_template.name
                                UNION 
                                         SELECT product_product.id AS product_id, product_product.default_code, product_template.name, - sum(stock_move.product_qty) AS qty_w
                                           FROM product_product left join product_template on product_product.product_tmpl_id = product_template.id
                                      LEFT JOIN stock_move ON stock_move.product_id = product_product.id
                                     WHERE product_product.active AND stock_move.location_id = 16 AND stock_move.state::text = 'done'::text
                                     GROUP BY product_product.default_code, product_product.id, product_template.name)
           q1
  GROUP BY q1.product_id, q1.default_code, q1.name
  HAVING sum(q1.qty_w) > 0
  ORDER BY q1.product_id;