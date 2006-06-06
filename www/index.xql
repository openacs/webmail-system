<?xml version="1.0"?>

<queryset>

<fullquery name="get_server_list">
  <querytext>

	select neat_name, server_id from webmail_servers where active_p = 't'
		
  </querytext>
</fullquery>

<fullquery name="has_account">
  <querytext>

	select * from webmail_user_accounts where user_id = :user_id and default_p = 't'
		
  </querytext>
</fullquery>

</queryset>
