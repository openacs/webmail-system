# --------------------------------------------------------------- #
#                        CREATING THE FOLDER                      #
#                                                                 #
# LOCATION: packages/webmail-system/www/folder-create-2.tcl       #
#                                                                 #
# --------------------------------------------------------------- #

ad_page_contract {

        Creating the folder.

	@author Ayman Mohamed (mo2mo@hotmail.com)
	@author Nima Mazloumi (mazloumi@uni-mannheim.de)
	@creation-date 7/10/2002

} {
	foldername:notnull
}

# ------------------- RETRIEVE SESSION PARAMS ------------------- #

ns_log debug "WEBMAIL: Folder Create 2 started"

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

set name "\{$server\}mail/$foldername"

if [catch { ns_imap m_create $id $name } errmsg] {
	ns_log error "WEBMAIL: Folder Create 2 Error: $errmsg"
}

ns_log debug "WEBMAIL: Folder Create 2 complete"

# --------------------------------------------------------------- #

ad_returnredirect "folders"

# ------------------------- END OF FILE ------------------------- #
