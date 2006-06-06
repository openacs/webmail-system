<?xml version="1.0"?>

<queryset>

<fullquery name="get_emails">
  <querytext>

	select wa.username, ws.host_addr from webmail_user_accounts wa, webmail_servers ws where wa.user_id = :user_id and ws.server_id = wa.server_id and wa.active_p = 't'

  </querytext>
</fullquery>

</queryset>
