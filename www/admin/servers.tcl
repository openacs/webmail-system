# --------------------------------------------------------------- #
#                           ADMIN SERVERS                         #
#                                                                 #
# LOCATION: packages/webmail-system/www/admin/servers.tcl         #
#                                                                 #
# --------------------------------------------------------------- #

# ------------------------ PAGE CONTRACT ------------------------ #

ad_page_contract {
	
	Admin servers

	@author Ayman Mohamed (mo2mo@hotmail.com)
	@author Nima Mazloumi (mazloumi@uni-mannheim.de)
	@creation-date 20/10/2002

} {
    err:optional
    active_p:optional
    server_id:optional
    delete_p:optional
    smtp_auth_p:optional
}

# ------------------------ SET VARIABLES ------------------------ #
ns_log debug "WEBMAIL: Server Administration"

set address "Administrator"
set page_title "#webmail-system.Server_Administration#"

# -------------------------- PROCESSING ------------------------- #

set actions [list [_ webmail-system.Add_Server] "server" [_ webmail-system.Add_Server]]
set bulk_actions [list [_ webmail-system.Remove_Server] "server-remove" [_ webmail-system.Remove_Server]]
set bulk_actions_export_vars [list "server_id"]

# Build the list-builder list
template::list::create \
    -name servers \
    -key server_id \
    -actions $actions \
    -bulk_actions $bulk_actions \
    -multirow servers \
    -sub_class {
        tiny
    } -elements {
	edit {
            label ""
            display_template {
                <img src="/shared/images/Edit16.gif" height="16" width="16" alt="Edit" border="0">
            }
            link_url_eval {[export_vars -base server { server_id {ad_form_mode edit}}]}
            link_html {title "Edit this server"}
        } server_type {
            label "[_ webmail-system.Type]"
            html "align left"
        } neat_name {
            label "[_ webmail-system.Server_Name]"
            html "align left"
        } imap_server {
            label "[_ webmail-system.Imap_Address]"
            html "align left"
	    display_template {
                @servers.imap_addr@:@servers.imap_port@
            }
        } host_addr {
            label "[_ webmail-system.Host_Address]"
            html "align left"
	} smtp_server {
	    label "[_ webmail-system.SMTP] / [_ webmail-system.Authentication]"
            html "align left"
            display_template {
		@servers.smtp_addr@:@servers.smtp_port@
                <if @servers.smtp_auth_p;literal@ true>
                <a href="@servers.smtp_auth_p_url@" title="No SMTP Authentication">
                <img align="right" src="/shared/images/checkboxchecked" height="13" \
                    width="13" border="0" style="background-color: white;"></a>
                </if>
                <else>
                <a href="@servers.smtp_auth_p_url@" title="SMTP Authentication">
                <img align="right" src="/shared/images/checkbox" height="13" width="13" \
                    border="0" style="background-color: white;"></a>
                </else>
            }
	} active {
	    label "[_ webmail-system.Active]"
	    html "align right"
            display_template {
                <if @servers.active_p;literal@ true>
		<a href="@servers.active_p_url@" title="Deactivate">
		<img src="/shared/images/checkboxchecked" height="13" \
		    width="13" border="0" style="background-color: white;"></a>
                </if>
                <else>
		<a href="@servers.active_p_url@" title="Activate">
		<img src="/shared/images/checkbox" height="13" width="13" \
		    border="0" style="background-color: white;"></a>
                </else>
            }
	} delete {
            label ""
            display_template {
		<a href="@servers.delete_url@"
		title="Delete this server"
		onclick="return confirm('Are you sure you want to delete the server @servers.neat_name@?');">
		<img src="/shared/images/Delete16.gif" height="16" width="16" alt="Delete" border="0">
		</a>
                </if>
            }
        }
    }

if { [info exists err] != 1 } {
	set err 0
}

#Deactivate server if requested
if {[exists_and_not_null server_id] && [exists_and_not_null active_p]} {
    db_dml toggle_activity {}
}

#Delete Server if requested
if {[exists_and_not_null server_id] && [exists_and_not_null delete_p]} {
    db_dml delete_server {}
}

#Set SMTP Authentication Mode if requested
if {[exists_and_not_null server_id] && [exists_and_not_null smtp_auth_p]} {
    db_dml toggle_smtp_auth_p {}
}

db_multirow -extend { active_p_url delete_url smtp_auth_p_url} servers get_all_servers {} { 
    set toggle_active_p [ad_decode $active_p "t" "f" "t"]
    set active_p_url "servers?[export_vars { server_id {active_p $toggle_active_p} }]"
    set delete_url   "servers?[export_vars { server_id {delete_p 't'} }]"
    set toggle_smtp_auth_p [ad_decode $smtp_auth_p "t" "f" "t"]
    set smtp_auth_p_url "servers?[export_vars { server_id {smtp_auth_p $toggle_smtp_auth_p} }]"
}

ns_log debug "WEBMAIL: Server Administration complete"

# --------------------------------------------------------------- #

ad_return_template

# ------------------------- END OF FILE ------------------------- #
