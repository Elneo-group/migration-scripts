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
UPDATE res_company SET intrastat = 'standard';
UPDATE res_company SET intrastat_arrivals = 'standard';
UPDATE res_company SET intrastat_dispatches = 'standard';

UPDATE account_invoice SET intrastat = 'standard' WHERE company_id = 1;
UPDATE account_invoice SET intrastat_transaction_id = 1 WHERE company_id = 1;


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
$$ LANGUAGE plpgsql;


-- INVOICES
UPDATE account_invoice_line SET hs_code_id = hc_id
FROM
	(SELECT req1.*, hc.id AS hc_id FROM
		(SELECT ail.id AS id, GetProdIntrastat(pt.id) AS intra_id, pt.id AS pt_id
		FROM account_invoice_line AS ail
			JOIN account_invoice ai ON ail.invoice_id = ai.id AND to_char(ai.date_invoice,'YYYY') = '2015'
			JOIN product_product pp ON pp.id = ail.product_id
			JOIN product_template pt ON pt.id = pp.product_tmpl_id AND pt.type <> 'service'
		WHERE ail.product_id IS NOT NULL) req1
	JOIN report_intrastat_code ric ON req1.intra_id = ric.id
	JOIN hs_code hc ON hc.local_code = ric.intrastat_code
	) req2
	
WHERE account_invoice_line.id = req2.id;

-- IMPORT FORMER INTRASTAT DECLARATIONS

INSERT INTO l10n_be_intrastat_product_declaration(id, company_id,num_decl_lines,total_amount,state,type,revision,reporting_level,note,company_country_code,year,month,year_month,action,create_date,create_uid,write_date,write_uid)

SELECT rib.id,
rib.company_id,
rib.num_lines AS num_decl_lines,
rib.total_amount,
CASE WHEN rib.state = 'edit' THEN 'draft' ELSE rib.state END AS state,
CASE WHEN rib.ttype = 'A' THEN 'arrivals' WHEN rib.ttype = 'D' THEN 'dispatches' ELSE NULL END AS type,
rib.revision,
CASE WHEN rib.extended = True THEN 'extended' WHEN rib.extended = False THEN 'standard' ELSE NULL END AS reporting_level,
rib.notes AS note,
lower(rco.code) AS company_country_code,
CAST(to_char(rib.end_date,'YYYY') AS integer) AS year,
CAST(to_char(rib.end_date,'MM') AS integer) AS month,
to_char(rib.end_date,'YYYY') || '-' || to_char(rib.end_date,'MM') AS year_month,
'replace' AS action,

rib.create_date AS create_date,
rib.create_uid AS create_uid,
rib.write_date AS write_date,
rib.write_uid AS write_uid

FROM report_intrastat_belgium rib
JOIN res_company rc ON rc.id = rib.company_id
JOIN res_partner rp ON rc.partner_id = rp.id
JOIN res_country rco ON rco.id = rp.country_id ;

-- IMPORT FORMER INTRASTAT DECLARATION LINES

INSERT INTO l10n_be_intrastat_product_declaration_line(id,parent_id,transport_id,region_id,weight,amount_company_currency,transaction_id,incoterm_id,hs_code_id,src_dest_country_id,suppl_unit_qty,create_date,create_uid,write_date,write_uid)

SELECT ribl.id,
ribl.parent_id AS parent_id,
ribl.transport AS transport_id,
ribl.gewest AS region_id,
CAST(ribl.weight AS integer) AS weight,
ribl.amount_company_currency,
ribl.transaction AS transaction_id,
ribl.incoterm_id,
hc.id AS hs_code_id,
ribl.country_id AS src_dest_country_id,
CAST(ribl.quantity AS integer) AS suppl_unit_qty,


ribl.create_date AS create_date,
ribl.create_uid AS create_uid,
ribl.write_date AS write_date,
ribl.write_uid AS write_uid


FROM report_intrastat_belgium_line ribl
JOIN hs_code hc ON hc.local_code = ribl.intrastat_code
RIGHT OUTER JOIN report_intrastat_belgium rib ON rib.id = ribl.parent_id
WHERE ribl.id IS NOT NULL;

-- LINK ATTACHMENTS TO NEW MODEL

UPDATE ir_attachment SET res_model = 'l10n.be.intrastat.product.declaration' WHERE res_model = 'report.intrastat.belgium';