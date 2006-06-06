# --------------------------------------------------------------- #
#                              INSIDE                             #
#                                                                 #
# LOCATION: packages/webmail-system/www/inside.tcl                #
#                                                                 #
# --------------------------------------------------------------- #

# ------------------------ PAGE CONTRACT ------------------------ #

ad_page_contract {
	
	Logs into the server and enters the user into the system \
	if a correct connection to the server was made.

	@author Ayman Mohamed (mo2mo@hotmail.com)
	@author Nima Mazloumi (mazloumi@uni-mannheim.de)
	@creation-date 26/9/2002
	
} {
	{username:optional {}}
	{password:optional {}}
	{server_id:optional {}}
	{email:optional {}}
}

# ------------------------ SET VARIABLES ------------------------ #

ns_log debug "WEBMAIL: Inside starting $username $password $server_id"

# -------------------------- PROCESSING ------------------------- #

set account_id [webmail::create_account -server_id $server_id -username $username -password $password -email $email]
webmail::activate_account -account_id $account_id

# ---------------------- SET SESSION PARAMS --------------------- #

ns_log debug "WEBMAIL: Inside complete"

# --------------------------------------------------------------- #

ad_returnredirect "welcome"

# ------------------------- END OF FILE ------------------------- #
