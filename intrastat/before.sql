UPDATE ir_module_module SET state = 'uninstalled' WHERE name = 'l10n_be_intrastat';

UPDATE ir_ui_view SET active = False WHERE xml_id LIKE 'l10n_be_intrastat.%';