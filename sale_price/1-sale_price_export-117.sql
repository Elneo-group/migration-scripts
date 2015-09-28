copy customer_discount_exception to '/home/openerp/backups/customer_discount_exception.backup';
copy elneo_autocompute_saleprice_category_coefficientlist to '/home/openerp/backups/elneo_autocompute_saleprice_category_coefficientlist.backup';
copy product_discount_type to '/home/openerp/backups/product_discount_type.backup';
copy discount_type_discount to '/home/openerp/backups/discount_type_discount.backup';
copy product_group to '/home/openerp/backups/product_group.backup';
copy product_group_discount to '/home/openerp/backups/product_group_discount.backup';
copy (select id, discount_type_id from res_partner) to '/home/openerp/backups/partner_discount_type.backup';