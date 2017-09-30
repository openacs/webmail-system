# --------------------------------------------------------------- #
#                           ADMIN ACCOUNTS                        #
#                                                                 #
# LOCATION: packages/webmail-system/www/admin/accounts.tcl        #
#                                                                 #
# --------------------------------------------------------------- #

# ------------------------ PAGE CONTRACT ------------------------ #

ad_page_contract {
	
	Admin accounts             

	@author Nima Mazloumi (mazloumi@uni-mannheim.de)
	@creation-date 20/08/2004

} {
    err:optional
    account_id:optional
    delete_p:optional
    default_p:optional
}

# ------------------------ SET VARIABLES ------------------------ #
ns_log debug "WEBMAIL: Account Administration"

set address "Administrator"
set page_title "#webmail-system.Account_Administration#"
set id [ad_get_client_property webmail-system conn_id]
set user_id [ad_conn user_id]
set max_accounts [parameter::get -parameter "MaximumUserAccounts" -default 0]
set allowed_p [parameter::get -parameter "MultipleAccountsAllowedP" -default 0]
set count [db_string do_count {}]

# -------------------------- PROCESSING ------------------------- #

if { $allowed_p == 1 && $count < $max_accounts } {
    set actions [list [_ webmail-system.Add_Account] "account" [_ webmail-system.Add_Account]]
} else {
    set actions ""
}

# Build the list-builder list
template::list::create \
    -name accounts \
    -key user_id \
    -actions $actions \
    -multirow accounts \
    -sub_class {
        tiny
    } -elements {
	edit {
            label ""
            display_template {
                <img src="/shared/images/Edit16.gif" height="16" width="16" alt="Edit" border="0">
            }
            link_url_eval {[export_vars -base account { account_id {ad_form_mode edit}}]}
            link_html {title "Edit this account"}
        }
	neat_name {
            label "[_ webmail-system.Server_Name]"
            html "align left"
        } username {
            label "[_ webmail-system.Username]"
            html "align left"
        } email {
	    label "[_ webmail-system.Email]"
	    html "align left"
	} default {
            label "[_ webmail-system.Active]"
            html "align center"
            display_template {
                <if @accounts.default_p;literal@ false>
                <a href="@accounts.default_p_url@" title="Make Default">
                <img src="/resources/acs-subsite/radio.gif" height="13" \
                    width="13" border="0" style="background-color: white;"></a>
                </if>
		<else>
		<img src="/resources/acs-subsite/radiochecked.gif" height="13" \
                    width="13" border="0" style="background-color: white;">
		</else>
            }
        } delete {
            label ""
            display_template {
		<if @accounts.default_p;literal@ false>
                <a href="@accounts.delete_url@"
                title="Delete this account"
                onclick="return confirm('Are you sure you want to delete this account at @accounts.neat_name@?');">
                <img src="/shared/images/Delete16.gif" height="16" width="16" alt="Delete" border="0">
                </a>
                </if>
            }
        }

    }

if { [info exists err] != 1 } {
	set err 0
}


#Delete account if requested
if {[exists_and_not_null account_id] && [exists_and_not_null delete_p]} {
    db_dml delete_account {}
}

# Set account as default if requested
if {[exists_and_not_null account_id] && [exists_and_not_null default_p]} {

    #three steps: first reset the other accounts
    db_dml set_all_to_false {}
   
    #make this one as default
    db_dml make_default {}
    
    #and finally create a new session for the new default account
    webmail::activate_account -account_id $account_id
    ad_returnredirect "welcome"
    ad_script_abort
}

db_multirow -extend {default_p_url delete_url} accounts get_all_accounts {} {
    set default_p_url "accounts?[export_vars { account_id {default_p 't'} }]"
    set delete_url "accounts?[export_vars { account_id {delete_p 't'} }]"
}

ns_log debug "WEBMAIL: Accounts Administration completed"

# --------------------------------------------------------------- #

ad_return_template

# ------------------------- END OF FILE ------------------------- #
