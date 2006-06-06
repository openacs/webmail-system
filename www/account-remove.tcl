# --------------------------------------------------------------- #
#                        ADMIN REMOVE ACCOUN                      #
#                                                                 #
# LOCATION: packages/webmail-system/www/admin/account-remove.tcl  #
#                                                                 #
# --------------------------------------------------------------- #

# ------------------------ PAGE CONTRACT ------------------------ #

ad_page_contract {
	
	Admin accounts -- removing an account 

	@author Nima Mazloumi (mazloumi@uni-mannheim.de)
	@creation-date 23/08/2004

    } -query {
	{user_id:multiple,notnull}
    }

# ------------------------ SET VARIABLES ------------------------ #

set address "Administrator"
set page_title "#webmail-system.Account_Administration#"

set accounts [split $user_id " "]
set accounts [join $accounts "', '"]

ns_log debug "WEBMAIL: User Administration: Account Remove"

# -------------------------- PROCESSING ------------------------- #

# Removing the account from the database
if { [catch { db_dml remove_account {} } errmsg ] } {
        ns_log error "WEBMAIL: Account remove: $errmsg"
        ad_returnredirect "accounts?err=1"
}

ns_log debug "WEBMAIL: Account Administration: Remove end"

# --------------------------------------------------------------- #

ad_returnredirect "accounts"
ad_script_abort

# ------------------------- END OF FILE ------------------------- #
