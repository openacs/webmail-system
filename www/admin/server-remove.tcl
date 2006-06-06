# --------------------------------------------------------------- #
#                        ADMIN REMOVE USERS                       #
#                                                                 #
# LOCATION: packages/webmail-system/www/admin/user-remove.tcl     #
#                                                                 #
# --------------------------------------------------------------- #

# ------------------------ PAGE CONTRACT ------------------------ #

ad_page_contract {
	
	Admin user functionality - removing a user.

	@author Nima Mazloumi (mazloumi@uni-mannheim.de)
	@creation-date 23/08/2004

} -query {
	{server_id:multiple,notnull}
}

# ------------------------ SET VARIABLES ------------------------ #

set address "Administrator"
set page_title "#webmail-system.Server_Administration#"

set server_ids [split $server_id " "]
set server_ids [join $server_ids "', '"]

ns_log debug "WEBMAIL: User Administration: Server Remove"

# -------------------------- PROCESSING ------------------------- #

# Removing the servers from the database
if { [catch { db_dml remove_server {} } errmsg ] } {
        ns_log error "WEBMAIL: Server Remove: $errmsg"
        ad_returnredirect "servers?err=1"
}

ns_log debug "WEBMAIL: User Administration: Remove"

# --------------------------------------------------------------- #

ad_returnredirect "servers"
ad_script_abort

# ------------------------- END OF FILE ------------------------- #
