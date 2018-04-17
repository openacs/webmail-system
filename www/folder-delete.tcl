# --------------------------------------------------------------- #
#                         DELETING A FOLDER                       #
#                                                                 #
# LOCATION: packages/webmail-system/www/folder-delete.tcl         #
#                                                                 #
# --------------------------------------------------------------- #

ad_page_contract {

        Form to delete a folder.

	@author Ayman Mohamed (mo2mo@hotmail.com)
	@author Nima Mazloumi (mazloumi@uni-mannheim.de)
	@creation-date 11/10/2002

} {
} 

# ------------------- RETRIEVE SESSION PARAMS ------------------- #

ns_log debug "WEBMAIL: Delete Folder started"

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

set page_title "#webmail-system.Deleting_a_folder#"
set submit_label "[_ webmail-system.Delete]"
set target "folder-delete-2"

set mailbox "\{$server\}"

# -------------------------- PROCESSING ------------------------- #

set folders [ns_imap list $id $mailbox *]
set fnames [list]

foreach {odd even} $folders {
	lappend fnames $odd
}

# Removing the root mail dir and the INBOX dir from the options
set index [lsearch $fnames "mail"]
set fnames [lreplace $fnames $index $index]

set index [lsearch $fnames "INBOX"]
set fnames [lreplace $fnames $index $index]

# Duplicating values so that they can be used in the select
foreach key $fnames {
	lappend opts [list $key $key]
}


# ------------------------- CREATE FORM ------------------------- #

form create remove_folder -action $target

element create remove_folder foldername \
			-widget select \
                        -datatype text \
                        -label "#webmail-system.Folder_name#" \
			-options $opts

element create remove_folder submit_button \
                        -widget submit \
                        -label $submit_label

ns_log debug "WEBMAIL: Delete Folder complete"

# --------------------------------------------------------------- #

ad_return_template

# ------------------------- END OF FILE ------------------------- #
