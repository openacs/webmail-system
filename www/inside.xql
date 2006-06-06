<?xml version="1.0"?>

<queryset>

<fullquery name="get_server_id">
  <querytext>

        select server_id, host_addr
        from webmail_servers
        where imap_addr = :imap_server

  </querytext>
</fullquery>

</queryset>
