<?xml version="1.0"?>

<queryset>

<fullquery name="get_auth_types">
  <querytext>
	select * from webmail_auth_types
  </querytext>
</fullquery>

<fullquery name="get_serv_types">
  <querytext>
	select * from webmail_serv_types
  </querytext>
</fullquery>

<fullquery name="select_server">
  <querytext>
	select * from webmail_servers where server_id = :server_id
  </querytext>
</fullquery>

<fullquery name="add_server">
  <querytext>

	insert into webmail_servers (server_id, neat_name,
	host_addr, imap_addr, imap_port, active_p,
	auth_type, server_type, host_append_p, smtp_addr, smtp_auth_p, smtp_port)
	values (:server_id, :neat_name, :host_addr, :imap_addr,
	:imap_port, :active_p, :auth_type, :server_type,
	:host_append_p, :smtp_addr, :smtp_auth_p, :smtp_port)

  </querytext>
</fullquery>

<fullquery name="edit_server">
  <querytext>
	update webmail_servers
	set neat_name = :neat_name,
	host_addr = :host_addr,
	imap_addr = :imap_addr,
	active_p = :active_p,
	imap_port = :imap_port,
	auth_type = :auth_type,
	server_type = :server_type,
	host_append_p = :host_append_p,
	smtp_addr = :smtp_addr,
	smtp_auth_p = :smtp_auth_p,
	smtp_port = :smtp_port
	where server_id = :server_id
  </querytext>
</fullquery>

</queryset>
