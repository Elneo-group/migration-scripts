update ir_module_module set state='uninstalled' where name = 'account_bank_statement_extensions';
update ir_model_data set module='account_bank_statement_advanced' where module='account_bank_statement_extensions';