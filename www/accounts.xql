<?xml version="1.0"?>

<queryset>

<fullquery name="get_all_accounts">
  <querytext>
	select * from webmail_servers ws, webmail_user_accounts wm where
	ws.server_id = wm.server_id and user_id = :user_id order by
	neat_name, username
  </querytext>
</fullquery>

<fullquery name="do_count">
  <querytext>
	select count(server_id) as server_count from webmail_user_accounts where user_id = :user_id
  </querytext>
</fullquery>

<fullquery name="delete_account">
  <querytext>
	delete from webmail_user_accounts where account_id = :account_id
  </querytext>
</fullquery>

<fullquery name="set_all_to_false">
  <querytext>
	update webmail_user_accounts set default_p = 'f' where account_id <> :account_id and user_id = :user_id
  </querytext>
</fullquery>

<fullquery name="make_default">
  <querytext>
	update webmail_user_accounts set default_p = 't' where account_id = :account_id
  </querytext>
</fullquery>

</queryset>
