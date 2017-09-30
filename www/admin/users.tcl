# --------------------------------------------------------------- #
#                            ADMIN USERS                          #
#                                                                 #
# LOCATION: packages/webmail-system/www/admin/users.tcl           #
#                                                                 #
# --------------------------------------------------------------- #

# ------------------------ PAGE CONTRACT ------------------------ #

ad_page_contract {
	
	Admin user functionality.

	@author Nima Mazloumi (mazloumi@uni-mannheim.de)
	@creation-date 15/08/2004

} {
    err:optional
    server_id:optional
    account_id:optional
    active_p:optional
    delete_p:optional
}

# ------------------------ SET VARIABLES ------------------------ #

set address "Administrator"

set page_title "#webmail-system.User_Administration#"

set actions [list [_ webmail-system.Add_Account] "account" [_ webmail-system.Add_Account]]
set bulk_actions [list [_ webmail-system.Remove_User] "user-remove" [_ webmail-system.Remove_User]]
set bulk_action_export_vars [list "user_id"]

# Build the list-builder list
template::list::create \
    -name users \
    -key user_id \
    -actions $actions \
    -bulk_actions $bulk_actions \
    -bulk_action_export_vars $bulk_action_export_vars \
    -multirow users \
    -sub_class {
        tiny
    } -elements {
         user_id {
            label "[_ webmail-system.Id]"
            html "align right"
        } username {
            label "[_ webmail-system.Username]"
            html "align left"
        } first_names {
            label "[_ webmail-system.First_Names]"
            html "align left"
        } last_name {
            label "[_ webmail-system.Last_Name]"
            html "align left"
        } neat_name {
	    label "[_ webmail-system.Server_Name]"
	    html "align left"
	} active {
            label "[_ webmail-system.Active]"
            html "align right"
            display_template {
                <if @users.active_p;literal@ true>
                <a href="@users.active_p_url@" title="Deactivate">
                <img src="/shared/images/checkboxchecked" height="13" \
                    width="13" border="0" style="background-color: white;"></a>
                </if>
                <else>
                <a href="@users.active_p_url@" title="Activate">
                <img src="/shared/images/checkbox" height="13" width="13" \
                    border="0" style="background-color: white;"></a>
                </else>
            }
        } delete {
            label ""
            display_template {
                <a href="@users.delete_url@"
                title="Delete this account"
                onclick="return confirm('Are you sure you want to delete the account for @users.first_names@ @users.last_name@?');">
                <img src="/shared/images/Delete16.gif" height="16" width="16" alt="Delete" border="0">
                </a>
                </if>
            }
         }
    }

#Deactivate user if requested
if {[exists_and_not_null server_id] && [exists_and_not_null account_id] && [exists_and_not_null active_p]} {
    db_dml toggle_activity {}
}

#Delete account if requested
if {[exists_and_not_null server_id] && [exists_and_not_null account_id] && [exists_and_not_null delete_p]} {
    db_dml delete_user {}
}

ns_log debug "WEBMAIL: User Administration"

# -------------------------- PROCESSING ------------------------- #

if { [info exists err] != 1 } {
	set err 0
}

db_multirow -extend { active_p_url delete_url} users get_users {} {
    set toggle_active_p [ad_decode $active_p "t" "f" "t"]
    set active_p_url "users?[export_vars { server_id {account_id $user_id} {active_p $toggle_active_p} }]"
    set delete_url   "users?[export_vars { server_id {account_id $user_id} {delete_p 't'} }]"
}

# --------------------------------------------------------------- #

ad_return_template

# ------------------------- END OF FILE ------------------------- #