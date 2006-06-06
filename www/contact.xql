<?xml version="1.0"?>

<queryset>

<fullquery name="add_contact">
  <querytext>

	insert into webmail_address_book (user_id, contact_id, email_address,
	first_names, last_name, nick)
	values (:user_id, :contact_id, :email_address,
	:first_names, :last_name, :nick)

  </querytext>
</fullquery>

<fullquery name="edit_contact">
  <querytext>

	update webmail_address_book set 
	email_address = :email_address,
	first_names = :first_names,
	last_name = :last_name,
	nick = :nick
	where contact_id = :contact_id and user_id = :user_id

  </querytext>
</fullquery>

<fullquery name="select_contact">
  <querytext>

	select * from webmail_address_book where contact_id = :contact_id and user_id = :user_id

  </querytext>
</fullquery>

<fullquery name="is_nick_unique">
  <querytext>

	select nick from webmail_address_book where user_id = :user_id and nick = :nick

  </querytext>
</fullquery>

<fullquery name="is_edited_nick_unique">
  <querytext>

	select nick from webmail_address_book where user_id = :user_id and contact_id <> :contact_id and nick = :nick

  </querytext>
</fullquery>
</queryset>
