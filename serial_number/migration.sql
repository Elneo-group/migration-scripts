UPDATE product_template pt SET serialnumber_required = pp.serialnumber_required,
unique_serial_number = pp.serialnumber_required,
track_outgoing = pp.serialnumber_required
FROM product_product pp WHERE pp.product_tmpl_id=pt.id AND pp.serialnumber_required = True;