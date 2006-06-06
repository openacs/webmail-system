# --------------------------------------------------------------- #
#                            MAIL DELETE                          #
#                                                                 #
# LOCATION: packages/webmail-system/www/mail-delete.tcl           #
#                                                                 #
# --------------------------------------------------------------- #

# ------------------------ PAGE CONTRACT ------------------------ #

ad_page_contract {
	
	Deleting a user's email

	@author Ayman Mohamed (mo2mo@hotmail.com)
	@author Nima Mazloumi (mazloumi@uni-mannheim.de)
	@creation-date 11/10/2002

} {
    {number:integer,multiple,optional}
}

# ------------------- RETRIEVE SESSION PARAMS ------------------- #

ns_log debug "WEBMAIL: Mail Delete started"

# ------------------------ SET VARIABLES ------------------------ #

set id [ad_get_client_property webmail-system conn_id]

# -------------------------- PROCESSING ------------------------- #

if { [info exists number] } {
    foreach num $number {
	#Todo: It works but with an error msg
	set err_p [catch { [ns_imap delete $id $num] } errmsg]
	ns_imap expunge $id
    }
}

ns_log debug "WEBMAIL: Mail Delete complete"

ad_return_template "retrieve"
# ------------------------- END OF FILE ------------------------- #