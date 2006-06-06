<?xml version="1.0"?>

<queryset>

<fullquery name="get_users">
  <querytext>

	select wa.user_id, p.first_names, p.last_name, wa.username,
	ws.neat_name, ws.server_id, wa.active_p from
	webmail_user_accounts wa, webmail_servers ws, persons p where
	wa.server_id = ws.server_id and p.person_id = wa.user_id

  </querytext>
</fullquery>

<fullquery name="toggle_activity">
  <querytext>

	update webmail_user_accounts set active_p = :active_p where user_id = :account_id and server_id = :server_id

  </querytext>
</fullquery>

<fullquery name="delete_user">
  <querytext>

	delete from webmail_user_accounts where user_id = :account_id and server_id = :server_id

  </querytext>
</fullquery>

</queryset>
