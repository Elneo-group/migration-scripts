--change conditions de paiement par défault à "comptant"
update ir_property set value_reference = 'account.payment.term,8' where name = 'property_payment_term' and res_id is null;


-- AJOUTE LES CONDITIONS DE PAIEMNTS FOURNISSEUR A TOUS LES FOURNISSEURS A PARTIR DES CONDITIONS DE PAIEMENT CLIENT (UN CHAMP EN v6)
INSERT INTO ir_property (create_uid, create_date, name, res_id, company_id, fields_id, value_reference, type)

SELECT ip.create_uid, ip.create_date, 'property_supplier_payment_term', ip.res_id, company_id, req3.id, ip.value_reference, 'many2one' FROM ir_property ip ,
(SELECT id FROM res_partner WHERE supplier = True) req1,
(SELECT id FROM ir_model_fields WHERE model = 'res.partner' AND name = 'property_supplier_payment_term') req3


WHERE ip.name = 'property_payment_term'
AND ip.res_id = 'res.partner,' || req1.id
AND ip.res_id NOT IN (SELECT res_id FROM ir_property WHERE name = 'property_supplier_payment_term');

-- CORRIGE LE PARTNER_ID DANS LES FACTURES FOURNISSEUR (PREND LE COMMERCIAL_PARTNER_ID SI IL EST DIFFERENT)
UPDATE account_invoice SET partner_id = req1.comm_id
FROM
(SELECT rp.commercial_partner_id AS comm_id, ai.id AS in_id FROM account_invoice ai
JOIN res_partner rp ON ai.partner_id = rp.id
WHERE ai.type = 'in_invoice'
AND rp.commercial_partner_id IS NOT NULL
AND rp.commercial_partner_id <> ai.partner_id) req1

WHERE req1.in_id = account_invoice.id;

-- CORRIGE LE COMPTE IBAN
UPDATE res_partner_bank SET acc_number = req1.iban_old60
FROM
(SELECT iban_old60, id FROM res_partner_bank
WHERE state = 'iban' AND iban_old60 IS NOT NULL) req1
WHERE req1.id = res_partner_bank.id;


-- AJOUTE LE REGIME FISCAL PAR DEFAUT POUR LES CLIENTS
DO
$$
BEGIN
IF NOT EXISTS (SELECT 1 
               FROM ir_property
               WHERE name = 'property_account_position' AND res_id IS NULL AND fields_id = 1560 AND company_id = 1) THEN

INSERT INTO ir_property (name, company_id, fields_id,res_id, value_reference, type, create_uid)
VALUES ('property_account_position',1,1560,NULL,'account.fiscal.position,5','many2one',1);

END IF;
END
$$;