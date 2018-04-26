# --------------------------------------------------------------- #
#                        ADMIN ACCOUNT                            #
#                                                                 #
# LOCATION: packages/webmail-system/www/account.tcl               #
#                                                                 #
# --------------------------------------------------------------- #

# ------------------------ PAGE CONTRACT ------------------------ #

ad_page_contract {
	
	Admin Account

	@author Nima Mazloumi (mazloumi@uni-mannheim.de)
	@creation-date 23/08/2004

} {
    account_id:optional
}

# ------------------------ SET VARIABLES ------------------------ #

set page_title "#webmail-system.Adding_an_account#"
set address "Administrator"
set id [ad_get_client_property webmail-system conn_id]

set opts {}

db_multirow -extend { server_line } servers get_servers {} {
    set server_line "$neat_name ($host_addr)"
    lappend opts [list $server_line $server_id ]
}

set uopts {}

db_multirow -extend { name } users get_users {} {
    acs_user::get -user_id $user_id -array user
    set name "$user(first_names) $user(last_name)"
    lappend uopts [list $name $user_id ]
}

ns_log debug "WEBMAIL: Admin Server started"

# ------------------------- CREATE FORM ------------------------- #

ad_form -name account -form {
    account_id:key(webmail_account_seq)
    {user_id:text(select)
	{options $uopts}
	{label "#webmail-system.User#"}
	{html {single single}}}
    {server_id:text(select)
	{options $opts}
	{label "#webmail-system.Server#"}
	{html {single single}}}
    {username:text
	{html { size 30}}
	{label "#webmail-system.Username#"}}
    {password:text(password)
	{label "#webmail-system.Password#"}}
    {email:text
	{label "#webmail-system.Email#"}}
} -select_query_name select_account -on_request {
    # if only default server allowed
} -new_data {
    
    if {![webmail::verify_email -server_id $server_id -email $email -username $username]} {
	ad_return_complaint 1 "[_ webmail-system.Bad_Email]"
	ad_script_abort
    }

    if { [catch { db_dml add_account {} } errmsg] } {
	webmail::notify_user -type "error" -message "[_ webmail-system.This_account_exists_already]"
    } else {
	webmail::notify_user -type "info" -message "[_ webmail-system.Account_created]"
    }

} -edit_data {

    if {![webmail::verify_email -server_id $server_id -email $email -username $username]} {
	ad_return_complaint 1 "[_ webmail-system.Bad_Email]"
	ad_script_abort
    }

    if { [catch { db_dml edit_account {} } errmsg] } {
        webmail::notify_user -type "error" -message "[_ webmail-system.This_account_exists_already]"
    } else {
        webmail::notify_user -type "info" -message "[_ webmail-system.Account_changed]"
    }

} -after_submit {
    ad_returnredirect "users"
    ad_script_abort
}


ns_log debug "WEBMAIL: Admin Account completed"

# --------------------------------------------------------------- #

ad_return_template

# ------------------------- END OF FILE ------------------------- #
