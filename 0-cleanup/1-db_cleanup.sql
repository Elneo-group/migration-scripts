update ir_module_module set state = 'uninstalled' where state = 'to upgrade';
update ir_module_module set state = 'to upgrade' where name = 'account_followup';

delete from ir_ui_view where id in 
(
select res_id 
from ir_model_data 
left join ir_module_module on ir_module_module.name = ir_model_data.module
where ir_module_module.state = 'uninstalled'
and ir_model_data.model = 'ir.ui.view'
);

delete from ir_model_fields where id in 
(
select res_id 
from ir_model_data 
left join ir_module_module on ir_module_module.name = ir_model_data.module
where ir_module_module.state = 'uninstalled'
and ir_model_data.model = 'ir.model.fields'
);

delete from ir_ui_menu where id in 
(
select res_id 
from ir_model_data 
left join ir_module_module on ir_module_module.name = ir_model_data.module
where ir_module_module.state = 'uninstalled'
and ir_model_data.model = 'ir.ui.menu'
);


delete from ir_model_constraint where model in 
(
select res_id 
from ir_model_data 
left join ir_module_module on ir_module_module.name = ir_model_data.module
where ir_module_module.state = 'uninstalled'
and ir_model_data.model = 'ir.model'
);

delete from ir_model_relation where model in 
(
select res_id 
from ir_model_data 
left join ir_module_module on ir_module_module.name = ir_model_data.module
where ir_module_module.state = 'uninstalled'
and ir_model_data.model = 'ir.model'
);

delete from jasper_document where model_id in 
(
select res_id 
from ir_model_data 
left join ir_module_module on ir_module_module.name = ir_model_data.module
where ir_module_module.state = 'uninstalled'
and ir_model_data.model = 'ir.model'
);

delete from base_action_rule where model_id in 
(
select res_id 
from ir_model_data 
left join ir_module_module on ir_module_module.name = ir_model_data.module
where ir_module_module.state = 'uninstalled'
and ir_model_data.model = 'ir.model'
);



DO $$
    BEGIN
        BEGIN
		delete from ir_model where id in 
		(
		select res_id 
		from ir_model_data 
		left join ir_module_module on ir_module_module.name = ir_model_data.module
		where ir_module_module.state = 'uninstalled'
		and ir_model_data.model = 'ir.model'
		);
        EXCEPTION
            	WHEN integrity_constraint_violation THEN RAISE NOTICE 'Impossible de supprimer ir_model';
        END;
    END;
$$



/*update ir_module_module set state = 'uninstalled' where name ilike 'elneo%';
update ir_module_module set state = 'uninstalled' where name ilike 'technofluid%';
update ir_module_module set state = 'uninstalled' where name ilike 'maintenance%';
update ir_module_module set state = 'uninstalled' where author ilike '%elneo%';
update ir_module_module set state = 'uninstalled' where author ilike '%technofluid%';*/
