# --------------------------------------------------------------- #
#                           ADD ATTACHMENT                        #
#                                                                 #
# LOCATION: packages/webmail-system/www/add-attach.tcl            #
#                                                                 #
# --------------------------------------------------------------- #

# ------------------------ PAGE CONTRACT ------------------------ #

ad_page_contract {
	
	Adding an attachment the user's composed email

	@author Ayman Mohamed (mo2mo@hotmail.com)
	@author Nima Mazloumi (mazloumi@uni-mannheim.de)
	@creation-date 14/10/2002

} {
}

# ------------------- RETRIEVE SESSION PARAMS ------------------- #

ns_log debug "WEBMAIL: Add attachment started"

set id [ad_get_client_property webmail-system conn_id]
set username [ad_get_client_property webmail-system username]
set server [ad_get_client_property webmail-system server]
set host [ad_get_client_property webmail-system host]

# ------------------ CHECKING SESSION VALIDITY ------------------ #

# Checking if the user is logged in (ie. session currently running)
# Also, checking if the connection is still alive
if { [empty_string_p $id] || [catch { set new_mail [ns_imap ping $id] } errmsg] } {
        webmail::expired_session "WEBMAIL: Add Attachment Error"
        return
}

# ------------------------ SET VARIABLES ------------------------ #

set page_title "#webmail-system.Add_attachment#"
set address "$username@$host"

# -------------------------- PROCESSING ------------------------- #

ns_log debug "WEBMAIL: Add attachment complete"

# --------------------------------------------------------------- #

ad_return_template

# ------------------------- END OF FILE ------------------------- #
