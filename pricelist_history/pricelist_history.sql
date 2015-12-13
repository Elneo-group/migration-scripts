insert into pricelist_partnerinfo_history(date, brut_price, price, suppinfo_id, update_method, discount, min_quantity)
select pp.date, pp.brut_price, case when pp.price is not null then  pp.price else 0 end, pp.suppinfo_id, 'manual', pp.discount, pp.min_quantity from product_product p 
left join product_supplierinfo ps 
	left join pricelist_partnerinfo pp on pp.suppinfo_id = ps.id
on ps.product_tmpl_id = p.product_tmpl_id 
where suppinfo_id is not null
order by pp.id;


delete from pricelist_partnerinfo where id in (select pl1.id from pricelist_partnerinfo pl1 left join
(select max(pl.id) as pl_id from pricelist_partnerinfo pl group by pl.suppinfo_id, pl.min_quantity) req
on req.pl_id = pl1.id
where req.pl_id is null);