DO
$$
BEGIN
IF NOT EXISTS (SELECT column_name 
               FROM information_schema.columns 
               WHERE table_schema='public' and table_name='account_move_line' and column_name='absolute_balance') THEN
ALTER TABLE account_move_line ADD COLUMN absolute_balance numeric;
COMMENT ON COLUMN account_move_line.absolute_balance IS 'Absolute Amount';
END IF;

                                        
END
$$;

UPDATE account_move_line SET absolute_balance = abs(debit-credit) WHERE absolute_balance IS NULL;