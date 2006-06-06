# --------------------------------------------------------------- #
#                         DELETING A FOLDER                       #
#                                                                 #
# LOCATION: packages/webmail-system/www/folder-delete-2.tcl       #
#                                                                 #
# --------------------------------------------------------------- #

ad_page_contract {

        Deleting a folder.

	@author Ayman Mohamed (mo2mo@hotmail.com)
	@author Nima Mazloumi (mazloumi@uni-mannheim.de)
	@creation-date 7/10/2002

} {
    {name:notnull,multiple}
}

# ------------------- RETRIEVE SESSION PARAMS ------------------- #

ns_log debug "WEBMAIL: Folder Delete 2 started"

set id [ad_get_client_property webmail-system conn_id]
set server [ad_get_client_property webmail-system server]

# ------------------ CHECKING SESSION VALIDITY ------------------ #

# Checking if the user is logged in (ie. session currently running)
# Also, checking if the connection is still alive
if { [empty_string_p $id] || [catch { set new_mail [ns_imap ping $id] } errmsg] } {
        webmail::expired_session "WEBMAIL: Add Attachment Error"
        return
}

# -------------------------- PROCESSING ------------------------- #

if { [info exists name] } {
  
    foreach foldername $name {
	set foldername "\{$server\}$foldername"
	
	ns_log debug "WEBMAIL: Deleting folder called $foldername"
	
	if [catch { ns_imap m_delete $id $foldername } errmsg] {
	    ns_log debug "WEBMAIL: Cannot Delete Error: $errmsg"
	}
    }
}

ns_log debug "WEBMAIL: Folder complete"

# --------------------------------------------------------------- #

ad_returnredirect "folders"

# ------------------------- END OF FILE ------------------------- #
