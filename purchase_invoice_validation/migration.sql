-- Met a jour les valeurs null
UPDATE account_invoice SET problem_solving_in_progress = False
WHERE problem_solving_in_progress IS NULL;