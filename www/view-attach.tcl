# --------------------------------------------------------------- #
#                         VIEWING ATTACHMENT                      #
#                                                                 #
# LOCATION: packages/webmail-system/www/view-attach.tcl           #
#                                                                 #
# --------------------------------------------------------------- #

ad_page_contract {

        Viewing an attachment from an email.

	@author Ayman Mohamed (mo2mo@hotmail.com)
	@author Nima Mazloumi (mazloumi@uni-mannheim.de)
	@creation-date 21/10/2002

} {
	number:notnull
	part:notnull
}

# -------------------------- PROCESSING ------------------------- #
ns_log debug "WEBMAIL: View Attach started"

# Retrieving the id from the current session (null = not logged in)
set id [ad_get_client_property webmail-system conn_id]

# Retrieving the attachment and sending it to the HTTP connection
ns_imap body $id $number $part -return

ns_log debug "WEBMAIL: View Attach complete"

# --------------------------------------------------------------- #

ad_returnredirect "view?number=$number"

# ------------------------- END OF FILE ------------------------- #
