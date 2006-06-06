<?xml version="1.0"?>

<queryset>

<fullquery name="select_prefs">
  <querytext>

	select * from webmail_user_prefs where user_id = :user_id

  </querytext>
</fullquery>

<fullquery name="new_preferences">
  <querytext>

	insert into webmail_user_prefs 
              (user_id, signature, js_enabled, style, vcard, nav_bar)
            values
              (:user_id, :signature, :js_enabled, :style, :vcard, :nav_bar)

  </querytext>
</fullquery>

<fullquery name="update_preferences">
  <querytext>

	update webmail_user_prefs
            set signature = :signature,
            js_enabled = :js_enabled,
            style = :style,
            vcard = :vcard,
            nav_bar = :nav_bar
            where user_id = :user_id

  </querytext>
</fullquery>

</queryset>
