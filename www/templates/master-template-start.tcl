# --------------------------------------------------------------- #
#                                HELP                             #
#                                                                 #
# webmail-system/www/template/master-template-start.tcl           #
#                                                                 #
# --------------------------------------------------------------- #

# ------------------------ PAGE CONTRACT ------------------------ #

ad_page_contract {
	
	Template for pages that don't need active sessions

	@author Nima Mazloumi (mazloumi@uni-mannheim.de)
	@creation-date 15/08/2004

} {
    {admin_url ""}
    {admin_title ""}
}

# ------------------------ SET VARIABLES ------------------------ #

set package_id [ad_conn package_id]

set admin_p [permission::permission_p -object_id $package_id \
                 -privilege admin -party_id [ad_conn untrusted_user_id]]

if { $admin_p } {
    set admin_url "admin"
    set admin_title "#webmail-system.Administration#"
}

# ------------------- RETRIEVE SESSION PARAMS ------------------- #

set id [ad_get_client_property webmail-system conn_id]

ns_log debug "WEBMAIL: Start Master Template"

# -------------------------- PROCESSING ------------------------- #

ns_log debug "WEBMAIL: Start Master Template End"

# --------------------------------------------------------------- #

ad_return_template

# ------------------------- END OF FILE ------------------------- #
