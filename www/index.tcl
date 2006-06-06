# --------------------------------------------------------------- #
#                              INDEX                              #
#                                                                 #
# LOCATION: packages/webmail-system/www/index.tcl                 #
#                                                                 #
# --------------------------------------------------------------- #

# ------------------------ PAGE CONTRACT ------------------------ #

ad_page_contract {
	
	The index page tries to auto login user or to redirect to servers page
	@author Nima Mazloumi (mazloumi@uni-mannheim.de)
	@creation-date 25/08/2004

} {
}

# ------------------------ SET VARIABLES ------------------------ #

ns_log debug "WEBMAIL: Index started"

set user_id [auth::require_login]

#maybe in future add support for default server and autologin...we need user and password for that

# -------------------------- PROCESSING ------------------------- #

# If user has an account redirect to default account
if {[db_0or1row has_account {}]} {
    # ...redirect back to auto login
    rp_form_put username $username
    rp_form_put password $password
    rp_form_put server_id $server_id
    rp_form_put email $email
    rp_internal_redirect "inside"
    ad_script_abort
}

set allowed_p [parameter::get -parameter "MultipleAccountsAllowedP" -default 0]

if { $allowed_p == 1 } {
    rp_internal_redirect "accounts"
    ad_script_abort
}

# --------------------------------------------------------------- #

ns_log debug "WEBMAIL: Index complete"

# ------------------------- END OF FILE ------------------------- #
