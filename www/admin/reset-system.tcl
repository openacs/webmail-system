# --------------------------------------------------------------- #
#                         ADMIN SYSTEM RESET                      #
#                                                                 #
# LOCATION: packages/webmail-system/www/admin/reset-system.tcl    #
#                                                                 #
# --------------------------------------------------------------- #

# ------------------------ PAGE CONTRACT ------------------------ #

ad_page_contract {
	
	Possible page to reset the entire database.

	@author Ayman Mohamed (mo2mo@hotmail.com)
	@author Nima Mazloumi (mazloumi@uni-mannheim.de)
	@creation-date 20/10/2002

} {
    confirm_p:optional
}

# ------------------------ SET VARIABLES ------------------------ #

set page_title "#webmail-system.System_Reset#"

ns_log debug "WEBMAIL: System Reset"

# -------------------------- PROCESSING ------------------------- #

set result ""
if {[exists_and_not_null confirm_p]} {

    #Deleting all user accounts
    db_dml delete_accounts {delete from webmail_user_accounts}

    append result "[_ webmail-system.All_accounts_deleted]<br>"
    
    #Deleting all user preferences
    db_dml delete_prefs {delete from webmail_user_prefs}

    append result "[_ webmail-system.All_user_preferences_deleted]<br>"

    #Deleting all user contacts
    db_dml delete_contacts {delete from webmail_address_book}

    append result "[_ webmail-system.All_address_books_deleted]<br>"

    #Deleting all servers
    db_dml delete_servers {delete from webmail_servers}

    #append result "[_ webmail-system.All_servers_deleted]<br>"

}
    

# --------------------------------------------------------------- #

ad_return_template

# ------------------------- END OF FILE ------------------------- #
