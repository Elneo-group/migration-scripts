update ir_model_data set module='l10n_be_partner' where module='l10n_be_coda' and model='res.bank';
update ir_model_data set module='l10n_be_partner' where module='l10n_be_coa_multilang' and model='res.partner.title';
DELETE FROM ir_model_data WHERE module = 'l10n_be';