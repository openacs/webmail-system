<?xml version="1.0"?>

<queryset>

<fullquery name="get_emails">
  <querytext>
	select email from webmail_user_accounts where user_id = :user_id and active_p = 't'
  </querytext>
</fullquery>

<fullquery name="select_preferences">
  <querytext>
	select * from webmail_user_prefs where user_id = :user_id
  </querytext>
</fullquery>

<fullquery name="select_contact">
  <querytext>
	select first_names, last_name, email_address from webmail_address_book where contact_id = :contact_id
  </querytext>
</fullquery>

</queryset>
