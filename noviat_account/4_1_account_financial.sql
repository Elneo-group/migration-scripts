ALTER TABLE account_move_line ADD COLUMN last_rec_date date;
COMMENT ON COLUMN account_move_line.last_rec_date IS 'Last reconciliation date';
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