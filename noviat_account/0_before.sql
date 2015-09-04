-- MAIN CURRENCY IS NOT ALLOWED ANYMORE IN BANK JOURNALS
UPDATE account_journal
SET currency = NULL
WHERE id IN(SELECT aj.id FROM account_journal aj
JOIN res_company rc ON aj.company_id = rc.id AND rc.currency_id = aj.currency 
WHERE type = 'bank');