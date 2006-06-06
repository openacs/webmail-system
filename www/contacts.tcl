# --------------------------------------------------------------- #
#                             CONTACTS                            #
#                                                                 #
# LOCATION: packages/webmail-system/www/contacts.tcl              #
#                                                                 #
# --------------------------------------------------------------- #

# ------------------------ PAGE CONTRACT ------------------------ #

ad_page_contract {
	
	The user's address (contacts) book.

	@author Ayman Mohamed (mo2mo@hotmail.com)
	@author Nima Mazloumi (mazloumi@uni-mannheim.de)
	@creation-date 11/10/2002

} {
    err:optional
    csv:optional
    delete_p:optional
    contact_id:optional
}

# ------------------------ SET VARIABLES ------------------------ #

ns_log debug "WEBMAIL: Contacts started"

set page_title "[_ webmail-system.User_contacts]"

if { [info exists err] != 1 } {
        set err 0
}

set id [ad_get_client_property webmail-system conn_id]
set user_id [ad_conn user_id]

set actions [list [_ webmail-system.Add_Contact] "contact" [_ webmail-system.Add_Contact] \
		 [_ webmail-system.CSV] "contacts?csv=yes" [_ webmail-system.CSV]]

# Build the list-builder list
template::list::create \
    -name contacts \
    -key  contact_id \
    -multirow contacts \
    -actions $actions \
    -sub_class {
	tiny
    } -elements {
	edit {
            label ""
            display_template {
                <img src="/shared/images/Edit16.gif" height="16" width="16" alt="Edit" border="0">
            }
            link_url_eval {[export_vars -base contact { contact_id {ad_form_mode edit}}]}
            link_html {title "Edit this contact"}
        } compose {
	    label ""
	    html "align right"
	    display_template {
                <if @contacts.email_address@ not nil>
                <A HREF="compose?contact_id=@contacts.contact_id@">
                <IMG SRC="images/closed-envelope.gif\" ALT="#webmail-system.Email_contacts_first_names#" BORDER=0></A>
                </if>
            }
	} nick {
	    label "[_ webmail-system.Nickname]"
            html "align left"
	} first_names {
            label "[_ webmail-system.First_Names]"
            html "align left"
        } last_name {
            label "[_ webmail-system.Last_Name]"
            html "align left"
        } email_address {
            label "[_ webmail-system.Email]"
            html "align right"
        } delete {
            label ""
            display_template {
                <a href="@contacts.delete_url@"
                title="Delete this contact"
                onclick="return confirm('Are you sure you want to delete your contact @contacts.first_names@ @contacts.last_name@?');">
                <img src="/shared/images/Delete16.gif" height="16" width="16" alt="Delete" border="0">
                </a>
                </if>
            }
            sub_class narrow
        }

    } -selected_format csv -formats {
        csv { output csv }
    }

# -------------------------- PROCESSING ------------------------- #

#Delete account if requested
if {[exists_and_not_null contact_id] && [exists_and_not_null delete_p]} {
    db_dml delete_contact {}
    webmail::notify_user -type "info" -message "[_ webmail-system.Contact_deleted]"
}

db_multirow -extend {delete_url} contacts get_contact_list {} {
    set delete_url "contacts?[export_vars { contact_id {delete_p 't'} }]"
}

if { [exists_and_not_null csv] } {
    template::list::write_output -name contacts
}

ns_log debug "WEBMAIL: Contacts complete"

# --------------------------------------------------------------- #

ad_return_template

# ------------------------- END OF FILE ------------------------- #
