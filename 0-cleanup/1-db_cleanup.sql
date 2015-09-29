update ir_module_module set state = 'uninstalled' where name ilike 'elneo%';
update ir_module_module set state = 'uninstalled' where name ilike 'technofluid%';
update ir_module_module set state = 'uninstalled' where name ilike 'maintenance%';
update ir_module_module set state = 'uninstalled' where author ilike '%elneo%';
update ir_module_module set state = 'uninstalled' where author ilike '%technofluid%';
