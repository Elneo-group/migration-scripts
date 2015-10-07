--change conditions de paiement par défault à "comptant"
update ir_property set value_reference = 'account.payment.term,8' where name = 'property_payment_term' and res_id is null;