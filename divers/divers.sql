
update report_paperformat set 
header_spacing = 30, 
margin_right = 9, 
margin_left = 9, 
margin_top = 30, 
margin_bottom = 28
where name = 'European A4';


--Reports : disable old reports
update ir_act_report_xml set active = False where report_type = 'pdf';