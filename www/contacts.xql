<?xml version="1.0"?>

<queryset>

<fullquery name="get_contact_list">
  <querytext>

	select * from webmail_address_book where user_id = :user_id order by first_names asc

  </querytext>
</fullquery>

<fullquery name="delete_contact">
  <querytext>

	delete from webmail_address_book where contact_id = :contact_id and user_id = :user_id

  </querytext>
</fullquery>

</queryset>
