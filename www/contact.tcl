# --------------------------------------------------------------- #
#                            CONTACT                              #
#                                                                 #
# LOCATION: packages/webmail-system/www/contact.tcl               #
#                                                                 #
# --------------------------------------------------------------- #

ad_page_contract {

        Managing contacts

	@author Nima Mazloumi (mazloumi@uni-mannheim.de)
	@creation-date 19/08/2004

} {
    contact_id:optional
    first_names:optional
    last_name:optional
    email_address:optional
}

# ------------------------ SET VARIABLES ------------------------ #

ns_log debug "WEBMAIL: Add Contact started"

set user_id [ad_conn user_id]
set page_title "#webmail-system.Contact Administration#"

# ------------------------- CREATE FORM ------------------------- #

ad_form -name contact -form {
    contact_id:key(webmail_contact_seq)
    {first_names:text
	{html { size 30 }}
	{label "#webmail-system.First_Names#"}}
    {last_name:text
	{html { size 30 }}
	{label "#webmail-system.Last_Name#"}}
    {email_address:text
	{html { size 30 }}
	{label "#webmail-system.Email#"}}
    {nick:text,optional
	{html { size 30 }}
	{label "#webmail-system.Nickname#"}}
} -select_query_name select_contact -on_request {
    # for passing element values on the fly
} -new_data {
    if {![db_0or1row is_nick_unique {}]} {
	db_dml add_contact {}
	webmail::notify_user -type "cool" -message "[_ webmail-system.Contact_added]"
    } else {
	webmail::notify_user -type "error" -message "[_ webmail-system.Nick_already_exists]"
    }
} -edit_data {
    if {![db_0or1row is_edited_nick_unique {}]} {
	db_dml edit_contact {}
	webmail::notify_user -type "info" -message "[_ webmail-system.Contact_changed]"
    } else {
	webmail::notify_user -type "error" -message "[_ webmail-system.Nick_already_exists]"
	#ad_return_complaint 1 "[_ webmail-system.Nick_already_exists]"
    }
} -after_submit {
    ad_returnredirect "contacts"
    ad_script_abort
}


# --------------------------------------------------------------- #

ns_log debug "WEBMAIL: Add Contact complete"
ad_return_template

# ------------------------- END OF FILE ------------------------- #
