DO
$$
BEGIN
IF NOT EXISTS (SELECT column_name 
               FROM information_schema.columns 
               WHERE table_schema='public' and table_name='product_template' and column_name='cost_price') THEN

ALTER TABLE product_template ADD COLUMN cost_price double precision;
COMMENT ON COLUMN product_template.cost_price IS 'Cost price';

END IF;                                      
END
$$;