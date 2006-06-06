# --------------------------------------------------------------- #
#                              WELCOME                            #
#                                                                 #
# LOCATION: packages/webmail-system/www/welcome.tcl               #
#                                                                 #
# --------------------------------------------------------------- #

# ------------------------ PAGE CONTRACT ------------------------ #

ad_page_contract {
	
	Welcome page for the user.

	@author Ayman Mohamed (mo2mo@hotmail.com)
	@author Nima Mazloumi (mazloumi@uni-mannheim.de)
	@creation-date 27/9/2002

} {
}

# ------------------------ SET VARIABLES ------------------------ #

set page_title "#webmail-system.Welcome#"

ns_log debug "WEBMAIL: Welcome started"

set id [ad_get_client_property webmail-system conn_id]
if { [empty_string_p $id] || [catch { set new_mail [ns_imap ping $id] } errmsg] } {
    webmail::expired_session "WEBMAIL: no active session"
    return
} else {
    set username [ns_imap getparam $id user]
}
# -------------------------- PROCESSING ------------------------- #

# If new_mail is 1, then new mail exists - for ping above
set recent_msgs [ns_imap n_recent $id]

ns_log debug "WEBMAIL: Welcome complete"

# --------------------------------------------------------------- #

ad_return_template

# ------------------------- END OF FILE ------------------------- #
