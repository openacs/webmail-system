# --------------------------------------------------------------- #
#                      NOT LOGGED IN ERROR PAGE                   #
#                                                                 #
# LOCATION: packages/webmail-system/www/not-logged-in.tcl         #
#                                                                 #
# --------------------------------------------------------------- #

ad_page_contract {

        Resulting error page when a page is accessed without \
	the user being logged in. This may also occur if their \
	session has expired.

	@author Ayman Mohamed (mo2mo@hotmail.com)
	@author Nima Mazloumi (mazloumi@uni-mannheim.de)
	@creation-date 14/9/2002

} {
}

# ------------------------ SET VARIABLES ------------------------ #

set page_title  [_ webmail-system.User_not_logged_in]
set context_bar [_ webmail-system.Error_Not_Logged_In]
set allowed_p [parameter::get -parameter "MultipleAccountsAllowedP" -default 0]
# --------------------------------------------------------------- #

ad_return_template

# ------------------------- END OF FILE ------------------------- #


#ns_write "\n\n__________ START OF EMAIL NUMBER $x __________\n\n"

#if { [ns_imap n_msgs $id] >= $x } {

#  ns_write "Debug From [ns_imap header $id $x from] about [ns_imap header $id $x subject]"
#  ns_write "\n"


#  foreach { name value } [ns_imap headers $id $x] {
#    ns_write "Debug HEADER: $name: $value"
#    ns_write "\n"
#  }
#  foreach { name value } [ns_imap struct $id $x] {
#    if { [string range $name 0 3] == "part" } {
#      set no [string range $name 4 end]
#      foreach { name value } $value {
#        ns_write "Debug PART$no: $name: $value"
#	ns_write "\n"
#      }
#      continue
#    }
#    ns_write "Debug $name: $value"
#    ns_write "\n"
#  }

#}

#ns_write "\n\n------ *email body* ------\n\n"

#ns_write "[ns_imap text $id $x]"

#ns_write "\n\n__________ END OF EMAIL NUMBER $x __________\n\n"
