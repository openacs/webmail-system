# --------------------------------------------------------------- #
#                              LOGOUT                             #
#                                                                 #
# LOCATION: packages/webmail-system/www/logout.tcl                #
#                                                                 #
# --------------------------------------------------------------- #

# ------------------------ PAGE CONTRACT ------------------------ #

ad_page_contract {
	
	Logs the user out of their current session.

	@author Ayman Mohamed (mo2mo@hotmail.com)
	@author Nima Mazloumi (mazloumi@uni-mannheim.de)
	@creation-date 7/10/2002

} {
}

# ------------------------ SET VARIABLES ------------------------ #

ns_log debug "WEBMAIL: Logout started"

set page_title "#webmail-system.Logout#"

# -------------------------- PROCESSING ------------------------- #
# Close the IMAP connection
webmail::close_session
webmail::notify_user -type "auth" -message "[_ webmail-system.Active_session_closed]"

ns_log debug "WEBMAIL: Logout complete"

# --------------------------------------------------------------- #

ad_return_template

# ------------------------- END OF FILE ------------------------- #
