UPDATE ir_sequence SET number_next = (SELECT MAX(CAST(SUBSTRING(code,2,char_length(code)-1) AS INTEGER)) + 1 FROM account_bank_statement_line_global)
 WHERE code = 'statement.line.global';