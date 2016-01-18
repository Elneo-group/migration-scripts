update ir_model_data set module='l10n_be_partner' where module='l10n_be_coda' and model='res.bank';
update ir_model_data set module='l10n_be_partner' where module='l10n_be_coa_multilang' and model='res.partner.title';
DELETE FROM ir_model_data WHERE module = 'l10n_be';
delete from ir_ui_view where id in (select v.id from ir_model_data d left join ir_ui_view v on d.res_id = v.id where d.model = 'ir.ui.view' and module = 'l10n_be');