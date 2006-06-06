# --------------------------------------------------------------- #
#                      RETRIEVING FOLDER LIST                     #
#                                                                 #
# LOCATION: packages/webmail-system/www/folders.tcl               #
#                                                                 #
# --------------------------------------------------------------- #

ad_page_contract {

        Retrieving the user's list of folders.

	@author Ayman Mohamed (mo2mo@hotmail.com)
	@author Nima Mazloumi (mazloumi@uni-mannheim.de)
	@creation-date 30/9/2002

} {
}

# ------------------- RETRIEVE SESSION PARAMS ------------------- #

ns_log debug "WEBMAIL: Folders started"

set id [ad_get_client_property webmail-system conn_id]
set username [ad_get_client_property webmail-system username]
set server [ad_get_client_property webmail-system server]
set host [ad_get_client_property webmail-system host]

# ------------------ CHECKING SESSION VALIDITY ------------------ #

# Checking if the user is logged in (ie. session currently running)
# Also, checking if the connection is still alive
if { [empty_string_p $id] || [catch { set new_mail [ns_imap ping $id] } errmsg] } {
        webmail::expired_session "WEBMAIL: Add Attachment Error"
        return
}

# ------------------------ SET VARIABLES ------------------------ #

set page_title "Retrieving folder list"

set mailbox "\{$server\}"

set actions [list [_ webmail-system.Create_Folder] "folder-create" [_ webmail-system.Create_Folder]]
set bulk_actions [list  [_ webmail-system.Delete_Folder] "folder-delete-2" [_ webmail-system.Delete_Folder]]
set bulk_actions_export_vars [list "name"]

template::list::create \
    -name folder_list \
    -key name \
    -multirow folder_list \
    -actions $actions \
    -bulk_actions $bulk_actions \
    -bulk_action_export_vars $bulk_actions_export_vars \
    -sub_class {
	tiny
    } -elements {
        name {
            label "[_ webmail-system.Folder]"
            link_url_col folder_link
            html { align right }
        }
    }

# -------------------------- PROCESSING ------------------------- #

set folders [ns_imap list $id $mailbox *]
set fnames [list]
set number 0
foreach {odd even} $folders {
    incr number
    lappend fnames [list $number $odd "retrieve?folder=$odd"]
}

multirow create folder_list number name folder_link

foreach elm $fnames {
    multirow append folder_list \
        [lindex $elm 0] \
        [lindex $elm 1] \
        [lindex $elm 2]
}

ns_log debug "WEBMAIL: Folders complete"

# --------------------------------------------------------------- #

ad_return_template

# ------------------------- END OF FILE ------------------------- #
