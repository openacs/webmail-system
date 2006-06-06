<?xml version="1.0"?>

<queryset>

<fullquery name="get_all_servers">
  <querytext>
	select ws.server_id, ws.neat_name, ws.host_addr, ws.smtp_addr, ws.smtp_auth_p, 
  ws.imap_port, ws.active_p, ws.imap_addr, ws.smtp_port, (select type from
  webmail_serv_types where ws.server_type = type_id) as server_type from webmail_servers ws order by ws.neat_name
  </querytext>
</fullquery>

<fullquery name="toggle_activity">
  <querytext>
     update webmail_servers set active_p = :active_p where server_id = :server_id
  </querytext>
</fullquery>

<fullquery name="delete_server">
  <querytext>
     delete from webmail_servers where server_id = :server_id
  </querytext>
</fullquery>

<fullquery name="toggle_smtp_auth_p">
  <querytext>
     update webmail_servers set smtp_auth_p = :smtp_auth_p where server_id = :server_id
  </querytext>
</fullquery>

</queryset>
