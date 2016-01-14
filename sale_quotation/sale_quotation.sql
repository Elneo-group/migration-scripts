DO $$
DECLARE 
DB_BACKUP_FILE varchar;
BEGIN
ALTER TABLE sale_quotation_order_text_element
   ALTER COLUMN text_element_id DROP NOT NULL;
update sale_quotation_order_text_element set text_element_id = null;
delete from sale_quotation_text_element where content is null;
copy sale_quotation_text_element from '/home/elneo/sale_quotation_text_element.backup';
END;
$$ LANGUAGE plpgsql;

