DO
$$
BEGIN
IF NOT EXISTS (SELECT column_name 
               FROM information_schema.columns 
               WHERE table_schema='public' and table_name='maintenance_intervention' and column_name='project_state') THEN
	ALTER TABLE maintenance_intervention ADD COLUMN project_state character varying;
	COMMENT ON COLUMN maintenance_intervention.project_state IS 'Project state';
END IF;                                      
END
$$;

UPDATE maintenance_intervention
 SET project_state = (SELECT mp.state FROM maintenance_project mp JOIN maintenance_intervention mi ON mp.id = mi.project_id WHERE mi.id = maintenance_intervention.id)
 WHERE project_state IS NULL;