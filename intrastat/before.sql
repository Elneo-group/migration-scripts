UPDATE ir_module_module SET state = 'uninstalled' WHERE name = 'l10n_be_intrastat';
UPDATE ir_module_module SET state = 'uninstalled' WHERE name = 'report_intrastat';

DELETE FROM ir_ui_view WHERE id = 2628;
DELETE FROM ir_ui_view WHERE id = 2627;
DELETE FROM ir_ui_view WHERE id = 2632;
DELETE FROM ir_ui_view WHERE id = 2631;
DELETE FROM ir_ui_view WHERE id = 2630;
DELETE FROM ir_ui_view WHERE id = 2629;

DELETE FROM ir_ui_view WHERE id = 2633;
DELETE FROM ir_ui_view WHERE id = 2638;
DELETE FROM ir_ui_view WHERE id = 2639;
DELETE FROM ir_ui_view WHERE id = 2641;
DELETE FROM ir_ui_view WHERE id = 2640;

DELETE FROM ir_ui_view WHERE id = 2637;
DELETE FROM ir_ui_view WHERE id = 2634;
DELETE FROM ir_ui_view WHERE id = 2635;
DELETE FROM ir_ui_view WHERE id = 2636;
DELETE FROM ir_ui_view WHERE id = 2642;