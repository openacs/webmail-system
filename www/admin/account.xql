<?xml version="1.0"?>

<queryset>

<fullquery name="add_account">
  <querytext>

	insert into webmail_user_accounts (account_id, server_id, user_id,
	email, username, password, active_p, default_p)
	values (:account_id, :server_id, :user_id, :email, :username,
	:password, 't', 't')

  </querytext>
</fullquery>

<fullquery name="edit_account">
  <querytext>
	update webmail_user_accounts
	set email = :email,
	username = :username,
	password = :password
	where account_id = :account_id
  </querytext>
</fullquery>

<fullquery name="get_servers">
  <querytext>
	select * from webmail_servers where active_p = 't'
  </querytext>
</fullquery>

<fullquery name="get_users">
  <querytext>
	select user_id from users where user_id <> 0;
  </querytext>
</fullquery>

<fullquery name="select_account">
  <querytext>
	select * from webmail_user_accounts where account_id = :account_id
  </querytext>
</fullquery>

</queryset>
