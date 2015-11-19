UPDATE account_invoice SET src_dest_country_id = (SELECT country_id FROM res_partner WHERE id = account_invoice.partner_id), 
intrastat_country = (SELECT res_country.intrastat FROM res_country JOIN res_partner ON res_partner.country_id = res_country.id WHERE res_partner.id = account_invoice.partner_id);


-- INTRASTAT CODE FOR PROD CATEGORIES 
INSERT INTO ir_property (create_uid,create_date,write_date,write_uid,name,res_id,company_id,value_reference,fields_id,type)

SELECT 1 create_uid,
CURRENT_TIMESTAMP AS create_date,
CURRENT_TIMESTAMP AS write_date,
1 AS write_uid,
'hs_code_id' AS name,
'product.category,' || pc.id AS res_id,
1 AS company_id,
'hs.code,' || hc.id AS value_reference,
imf.id AS fields_id,
'many2one' AS type

FROM product_category pc
JOIN report_intrastat_code ric
ON pc.intrastat_id = ric.id
JOIN hs_code hc ON ric.intrastat_code = hc.local_code
JOIN ir_model_fields imf ON imf.model = 'product.category' AND imf.name = 'hs_code_id'

WHERE NOT EXISTS (SELECT id FROM ir_property WHERE res_id = 'product.category,' || pc.id AND name = 'hs_code_id');


-- PRODUCT TEMPLATE 
INSERT INTO ir_property (create_uid,create_date,write_date,write_uid,name,res_id,company_id,value_reference,fields_id,type)
SELECT 1 create_uid,
CURRENT_TIMESTAMP AS create_date,
CURRENT_TIMESTAMP AS write_date,
1 AS write_uid,
'hs_code_id' AS name,
'product.template,' || pt.id AS res_id,
1 AS company_id,
'hs.code,' || hc.id AS value_reference,
imf.id AS fields_id,
'many2one' AS type

FROM product_template pt
JOIN report_intrastat_code ric
ON pt.intrastat_id = ric.id
JOIN hs_code hc ON ric.intrastat_code = hc.local_code
JOIN ir_model_fields imf ON imf.model = 'product.template' AND imf.name = 'hs_code_id'

WHERE NOT EXISTS (SELECT id FROM ir_property WHERE res_id = 'product.template,' || pt.id AND name = 'hs_code_id');

-- DEFAULT VALUES
UPDATE res_company SET intrastat = 'extended';
UPDATE res_company SET intrastat_arrivals = 'extended';
UPDATE res_company SET intrastat_dispatches = 'extended';

UPDATE account_invoice SET intrastat = 'extended' WHERE company_id = 1;


-- GET HS CODE FOR INVOICES
CREATE OR REPLACE FUNCTION GetProdIntrastat(ProdId Integer) RETURNS Integer AS
$$
	DECLARE 
		parent integer;
		IntraId integer;
		category_id integer;
	BEGIN
	SELECT intrastat_id into IntraId FROM product_template WHERE id = ProdId;
	IF IntraId IS NOT NULL THEN
		RETURN IntraId;
	END IF;
	
	SELECT categ_id into parent FROM product_template WHERE id = ProdID;
	
	WHILE parent IS NOT NULL
	LOOP
		SELECT id into category_id FROM product_category WHERE id = parent;
		IF category_id IS NOT NULL THEN
			SELECT intrastat_id into IntraID FROM product_category WHERE id = category_id;
			IF IntraID IS NOT NULL THEN
				RETURN IntraID;
			END IF;
		END IF;
		SELECT parent_id INTO parent FROM product_category WHERE id = category_id;
	END LOOP;

	RETURN IntraID;
	

	END;
$$ LANGUAGE plpgsql


-- INVOICES
UPDATE account_invoice_line SET hs_code_id = hc_id
FROM
	(SELECT req1.*, hc.id AS hc_id FROM
		(SELECT ail.id AS id, GetProdIntrastat(pt.id) AS intra_id, pt.id AS pt_id
		FROM account_invoice_line AS ail
			JOIN account_invoice ai ON ail.invoice_id = ai.id AND ai.state = 'draft'
			JOIN product_product pp ON pp.id = ail.product_id
			JOIN product_template pt ON pt.id = pp.product_tmpl_id AND pt.type <> 'service'
		WHERE ail.product_id IS NOT NULL) req1
	JOIN report_intrastat_code ric ON req1.intra_id = ric.id
	JOIN hs_code hc ON hc.local_code = ric.intrastat_code
	) req2
	
WHERE account_invoice_line.id = req2.id