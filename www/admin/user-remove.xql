<?xml version="1.0"?>

<queryset>

<fullquery name="get_users">
  <querytext>

	select wa.account_id, wa.server_id, wa.login_name, wa.email_address, wa.first_name, wa.last_name, ws.server_id, ws.neat_name, ws.imap_addr
	from webmail_user_accounts wa, webmail_servers ws
	where ws.server_id = wa.server_id

  </querytext>
</fullquery>

<fullquery name="remove_account">
  <querytext>

	delete from webmail_user_accounts where user_id IN (:users)

  </querytext>
</fullquery>

</queryset>
