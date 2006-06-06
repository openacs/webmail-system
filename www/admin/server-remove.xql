<?xml version="1.0"?>

<queryset>

<fullquery name="get_servers">
  <querytext>

	select server_id, neat_name, imap_addr, host_addr
	from webmail_servers

  </querytext>
</fullquery>

<fullquery name="remove_server">
  <querytext>

	delete from webmail_servers where server_id IN (:server_ids)

  </querytext>
</fullquery>

</queryset>
