# --------------------------------------------------------------- #
#                        ADMIN REMOVE USERS                       #
#                                                                 #
# LOCATION: packages/webmail-system/www/admin/user-remove.tcl     #
#                                                                 #
# --------------------------------------------------------------- #

# ------------------------ PAGE CONTRACT ------------------------ #

ad_page_contract {
    
    Admin user functionality - removing a user.
    
    @author Ayman Mohamed (mo2mo@hotmail.com)
    @author Nima Mazloumi (mazloumi@uni-mannheim.de)
    @creation-date 23/10/2002
    
} {
    user_id:multiple
}

# ------------------------ SET VARIABLES ------------------------ #

set address "Administrator"
set page_title "#webmail-system.User_Administration#"

set users [split $user_id " "]
set users [join $users "', '"]

ns_log debug "WEBMAIL: User Administration: Remove"

# -------------------------- PROCESSING ------------------------- #

# Removing the user account from the database
if { [catch { db_dml remove_account {} } errmsg ] } {
        ns_log error "WEBMAIL: User Account Remove: $errmsg"
        ad_returnredirect "users?err=1"
}

# ------------------------- CREATE FORM ------------------------- #


ns_log debug "WEBMAIL: User Administration: Remove"

# --------------------------------------------------------------- #

ad_returnredirect "users"

# ------------------------- END OF FILE ------------------------- #
