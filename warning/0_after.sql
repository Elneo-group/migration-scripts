UPDATE res_partner SET sale_warn_msg = flash_info_content WHERE sale_warn_msg IS NULL AND customer = True;
UPDATE res_partner SET purchase_warn_msg = flash_info_content WHERE purchase_warn_msg IS NULL AND supplier = True;
UPDATE res_partner SET sale_warn = CASE WHEN flash_info THEN 'warning' ELSE 'no-message' END WHERE customer = True;
UPDATE res_partner SET purchase_warn = CASE WHEN flash_info THEN 'warning' ELSE 'no-message' END WHERE supplier = True;