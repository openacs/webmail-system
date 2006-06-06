<?xml version="1.0"?>

<queryset>

<fullquery name="remove_contact">
  <querytext>
     delete from webmail_address_book where contact_id IN (:contacts) and user_id = :user_id
  </querytext>
</fullquery>

</queryset>
