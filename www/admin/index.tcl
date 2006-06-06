# --------------------------------------------------------------- #
#                            ADMIN INDEX                          #
#                                                                 #
# LOCATION: packages/webmail-system/www/admin/index.tcl           #
#                                                                 #
# --------------------------------------------------------------- #

# ------------------------ PAGE CONTRACT ------------------------ #

ad_page_contract {
	
	Index for administration tasks.

	@author Ayman Mohamed (mo2mo@hotmail.com)
	@author Nima Mazloumi (mazloumi@uni-mannheim.de)
	@creation-date 20/10/2002

} {
}

# ------------------------ SET VARIABLES ------------------------ #

set address ""

set page_title "#webmail-system.Webmail_Administration#"

set package_id [ad_conn package_id]

permission::require_permission -object_id $package_id -privilege admin

ns_log debug "WEBMAIL: Administration"

# -------------------------- PROCESSING ------------------------- #

# --------------------------------------------------------------- #

ad_return_template

# ------------------------- END OF FILE ------------------------- #
