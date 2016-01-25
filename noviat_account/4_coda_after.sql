DO
$$
BEGIN
IF EXISTS (SELECT column_name 
               FROM information_schema.columns 
               WHERE table_schema='public' and table_name='coda_bank_account' and column_name='currency') THEN
update coda_bank_account set currency_id=currency, journal_id=journal;
alter table coda_bank_account drop column currency;
alter table coda_bank_account drop column journal;
END IF;
END
$$