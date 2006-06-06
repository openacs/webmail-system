<?xml version="1.0"?>

<queryset>

<fullquery name="remove_account">
  <querytext>

	delete from webmail_user_accounts where user_id IN (:accounts)

  </querytext>
</fullquery>

</queryset>