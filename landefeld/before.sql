-- SET PARTNER_ID = NULL IF CONTACT DOES NOT EXIST ANYMORE

UPDATE elneo_webshop_account SET partner_id = NULL 
WHERE NOT EXISTS (SELECT 1 FROM res_partner WHERE id = elneo_webshop_account.partner_id);

-- DELETE CONFLICTING WIZARDS

DELETE FROM stock_invoice_onshipping;