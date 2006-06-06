# --------------------------------------------------------------- #
#                         CREATING A FOLDER                       #
#                                                                 #
# LOCATION: packages/webmail-system/www/folder-create.tcl         #
#                                                                 #
# --------------------------------------------------------------- #

ad_page_contract {

        Form to creating a folder.

	@author Ayman Mohamed (mo2mo@hotmail.com)
	@author Nima Mazloumi (mazloumi@uni-mannheim.de)
	@creation-date 7/10/2002

} {
}

# ------------------------ SET VARIABLES ------------------------ #
ns_log debug "WEBMAIL: Folder Create started"

set page_title "#webmail-system.Creating_a_folder#"
set submit_label "[_ webmail-system.Create]"
set target "folder-create-2"
set address "$username@$host"

# ------------------------- CREATE FORM ------------------------- #

form create new_folder -action $target

element create new_folder foldername \
                        -datatype text \
                        -html { size 25 } \
                        -label "#webmail-system.Folder_name#"

element create new_folder submit_button \
                        -widget submit \
                        -label $submit_label

ns_log debug "WEBMAIL: Folder Create complete"

# --------------------------------------------------------------- #

ad_return_template

# ------------------------- END OF FILE ------------------------- #
