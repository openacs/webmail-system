# --------------------------------------------------------------- #
#                            ADMIN INDEX                          #
#                                                                 #
# LOC: packages/webmail-system/www/template/master-template.tcl   #
#                                                                 #
# --------------------------------------------------------------- #

# ------------------------ PAGE CONTRACT ------------------------ #

ad_page_contract {

        Master-template

        @author Nima Mazloumi (mazloumi@uni-mannheim.de)
        @creation-date 15/08/2004

} {
    {admin_url ""}
    {admin_title ""}
}

# ------------------------ SET VARIABLES ------------------------ #

set package_id [ad_conn package_id]

set admin_p [permission::permission_p -object_id $package_id \
		 -privilege admin -party_id [auth::require_login]]

if { $admin_p } {
    set admin_url "admin"
    set admin_title "#webmail-system.Administration#"
}
                
# ------------------ CHECKING SESSION VALIDITY ------------------ #
set id [ad_get_client_property webmail-system conn_id] 
set nav_bar_p [ad_get_client_property webmail-system nav_bar]

# Checking if the user is logged in (ie. session currently running)
# Also, checking if the connection is still alive                  
if { [empty_string_p $id] || [catch { set new_mail [ns_imap ping $id] } errmsg] } {
        webmail::expired_session "WEBMAIL: Session Error"                          
        return                                                                     
}               
# --------------------------------------------------------------- #

ad_return_template

# ------------------------- END OF FILE ------------------------- #