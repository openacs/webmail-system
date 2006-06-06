# --------------------------------------------------------------- #
#                        REMOVING A CONTACT                       #
#                                                                 #
# LOCATION: packages/webmail-system/www/contact-remove.tcl        #
#                                                                 #
# --------------------------------------------------------------- #

ad_page_contract {

        Removing the contact.

	@author Ayman Mohamed (mo2mo@hotmail.com)
	@author Nima Mazloumi (mazloumi@uni-mannheim.de)
	@creation-date 7/10/2002

} {
	contact_id:notnull,multiple
}

# -------------------------- PROCESSING ------------------------- #

ns_log debug "WEBMAIL: Contact Remove started"
set user_id [ad_conn user_id]

set contacts [split $contact_id " "]
set contacts [join $contacts "', '"]

# Removing the contacts from the database
if { [catch { db_dml remove_contacts $remove_contacts } errmsg ] } {
        ns_log error "WEBMAIL: Contacts Remove: $errmsg"
        ad_returnredirect "contacts?err=1"
}
    
ns_log debug "WEBMAIL: Contact Remove complete"

# --------------------------------------------------------------- #

ad_returnredirect "contacts"

# ------------------------- END OF FILE ------------------------- #
