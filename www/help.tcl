# --------------------------------------------------------------- #
#                                HELP                             #
#                                                                 #
# LOCATION: packages/webmail-system/www/help.tcl                  #
#                                                                 #
# --------------------------------------------------------------- #

# ------------------------ PAGE CONTRACT ------------------------ #

ad_page_contract {
	
	A help page for users.

	@author Ayman Mohamed (mo2mo@hotmail.com)
	@author Nima Mazloumi (mazloumi@uni-mannheim.de)
	@creation-date 20/10/2002

} {
}

# ------------------------ SET VARIABLES ------------------------ #
ns_log debug "WEBMAIL: User Help started"

set page_title "#webmail-system.User_Help#"
set id [ad_get_client_property webmail-system conn_id]

# -------------------------- PROCESSING ------------------------- #

ns_log debug "WEBMAIL: User Help complete"

# --------------------------------------------------------------- #

ad_return_template

# ------------------------- END OF FILE ------------------------- #
