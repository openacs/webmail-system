<?xml version="1.0"?>

<queryset>

<fullquery name="webmail::activate_account.select_account">
  <querytext>

	select wa.username, 
	wa.password,
	wa.email,
	ws.imap_addr, 
	ws.imap_port, 
	ws.server_id,
	ws.smtp_addr,
	ws.neat_name,
	(select type from webmail_serv_types where ws.server_type = type_id) as type,
	(select type from webmail_auth_types where ws.auth_type = type_id) as auth_type
	from webmail_user_accounts wa,
	webmail_servers ws where
	wa.account_id = :account_id and
	wa.user_id = :uid and
	ws.server_id = wa.server_id

  </querytext>
</fullquery>

<fullquery name="webmail::activate_account.select_nav_bar_setting">
  <querytext>

	select nav_bar from webmail_user_prefs where user_id = :uid

  </querytext>
</fullquery>

<fullquery name="webmail::set_account_activity.set_status">
  <querytext>

	update webmail_user_accounts set active_p = :active_p  where account_id = :account_id and user_id = :user_id

  </querytext>
</fullquery>

<fullquery name="webmail::verify_email.get_server_info">
  <querytext>

	select server_id, host_addr, host_append_p from webmail_servers where server_id = :server_id

  </querytext>
</fullquery>

<fullquery name="webmail::create_account.account_exists">
  <querytext>

	select account_id from webmail_user_accounts where server_id = :server_id and user_id = :user_id and username = :username

  </querytext>
</fullquery>

<fullquery name="webmail::create_account.add_active_account">
  <querytext>

	insert into webmail_user_accounts (account_id, user_id, server_id, email, username, password, active_p) values
		(:account_id, :user_id, :server_id, :email, :username, :password, 'f')

  </querytext>
</fullquery>

</queryset>
