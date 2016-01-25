delete from ir_translation where res_id = 49 and name = 'email.template,body_html';

update email_template set body_html = '<div>
${object.quotation_address_id.title.name or ''''} ${object.quotation_address_id.name or ''''}, <br /><br />
Thank you for your quote request, we are pleased to send you our proposal (ref : ${object.name}). <br />
It is agreed that we remain at your disposal for any further information or any development that you would like us to make to this offer. <br />
waiting for your news, please accept, ${object.quotation_address_id.title.name or ''''},the expression of our devoted feelings. <br />
</div>
<h3><u>Documentation :</u></h3>
<ul>	
        % for link in object.drive_links:
		<li><a href="${link.link}">${link.name}</a> (${link.product_display})</li>
        % endfor
</ul>' where id = 49;

insert into ir_translation(lang,src,type,value,res_id,name,state)
values (
'fr_BE',
'<div>
${object.quotation_address_id.title.name or ''''} ${object.quotation_address_id.name or ''''}, <br /><br />
Thank you for your quote request, we are pleased to send you our proposal (ref : ${object.name}). <br />
It is agreed that we remain at your disposal for any further information or any development that you would like us to make to this offer. <br />
waiting for your news, please accept, ${object.quotation_address_id.title.name or ''''},the expression of our devoted feelings. <br />
</div>
<h3><u>Documentation :</u></h3>
<ul>	
        % for link in object.drive_links:
		<li><a href="${link.link}">${link.name}</a> (${link.product_display})</li>
        % endfor
</ul>',
'model',
'<div>
${object.quotation_address_id and object.quotation_address_id.title and object.quotation_address_id.title.name or ''''} ${object.quotation_address_id and object.quotation_address_id.name},<br /><br />
Nous vous remercions pour votre demande de prix, nous avons le plaisir de vous envoyer notre proposition (ref : ${object.name}). <br />
Il est entendu que nous restons à votre entière disposition pour tout renseignement complémentaire ou tout aménagement que vous souhaiteriez voir apporter à cette offre.<br />
Nous vous remercions de la suite qu''il vous plaira de réserver à celle-ci et, dans l''attente de vos nouvelles, nous vous prions d''agréer, ${object.quotation_address_id and object.quotation_address_id.title and object.quotation_address_id.title.name}, l''expression de nos sentiments dévoués.<br />
Sincères salutations.</div>

<h3><u>Documentation :</u></h3>
<ul>	
        % for link in object.drive_links:
		<li><a href="${link.link}">${link.name}</a> (${link.product_display})</li>
        % endfor
</ul>', 
49, 
'email.template,body_html', 
'translated');


insert into ir_translation(lang,src,type,value,res_id,name,state)
values (
'nl_BE',
'<div>
${object.quotation_address_id.title.name or ''''} ${object.quotation_address_id.name or ''''}, <br /><br />
Thank you for your quote request, we are pleased to send you our proposal (ref : ${object.name}). <br />
It is agreed that we remain at your disposal for any further information or any development that you would like us to make to this offer. <br />
waiting for your news, please accept, ${object.quotation_address_id.title.name or ''''},the expression of our devoted feelings. <br />
</div>
<h3><u>Documentation :</u></h3>
<ul>	
        % for link in object.drive_links:
		<li><a href="${link.link}">${link.name}</a> (${link.product_display})</li>
        % endfor
</ul>',
'model',
'<div>
${object.quotation_address_id and object.quotation_address_id.title and object.quotation_address_id.title.name or ''''} ${object.quotation_address_id and object.quotation_address_id.name},<br /><br />
Wij danken u voor uw prijsaanvraag en hebben het genoegen u hierna het volgende aan te bieden. (ref : ${object.name}). <br />
Onze technische en commerciële specificaties worden u hierna en in bijlagen meegedeeld. <br />
Natuurlijk blijven we steeds ter beschikking voor alle verdere informatie die u nodig zou hebben of voor elke wijziging die op u deze offerte zou willen toepassen.<br />
Wij hopen u hierbij een passende aanbieding te hebben gemaakt en binnenkort van u te horen.<br />
Met vriendelijke groeten.<br />
</div>

<h3><u>Documentation :</u></h3>
<ul>	
        % for link in object.drive_links:
		<li><a href="${link.link}">${link.name}</a> (${link.product_display})</li>
        % endfor
</ul>', 
49, 
'email.template,body_html', 
'translated');

