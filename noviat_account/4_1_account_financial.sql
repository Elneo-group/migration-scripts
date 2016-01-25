DO
$$
BEGIN
IF NOT EXISTS (SELECT column_name 
               FROM information_schema.columns 
               WHERE table_schema='public' and table_name='account_move_line' and column_name='last_rec_date') THEN
ALTER TABLE account_move_line ADD COLUMN last_rec_date date;
COMMENT ON COLUMN account_move_line.last_rec_date IS 'Last reconciliation date';
END IF;

                                        
END
$$;


UPDATE account_move_line as acm
                   SET last_rec_date =
                        (SELECT date from account_move_line
                             WHERE reconcile_id =  acm.reconcile_id
                                 AND reconcile_id IS NOT NULL
                             ORDER BY date DESC LIMIT 1)
                    WHERE last_rec_date is null;
                    
UPDATE account_move_line as acm
                   SET last_rec_date =
                        (SELECT date from account_move_line
                             WHERE reconcile_partial_id
                                                = acm.reconcile_partial_id
                                AND reconcile_partial_id IS NOT NULL
                             ORDER BY date DESC LIMIT 1)
                    WHERE last_rec_date is null;

                    
