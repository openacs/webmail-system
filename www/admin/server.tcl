# --------------------------------------------------------------- #
#                        ADMIN SERVER                             #
#                                                                 #
# LOCATION: packages/webmail-system/www/server.tcl                #
#                                                                 #
# --------------------------------------------------------------- #

# ------------------------ PAGE CONTRACT ------------------------ #

ad_page_contract {
	
	Admin Server

	@author Nima Mazloumi (mazloumi@uni-mannheim.de)
	@creation-date 23/08/2004

} {
    server_id:optional
}

# ------------------------ SET VARIABLES ------------------------ #

set page_title "#webmail-system.Adding_a_server#"
set address "Administrator"

set user_id [ad_conn user_id]

set opts [list]
db_multirow auth_types get_auth_types {} {
    lappend opts [list $type $type_id]
}

set options [list]
db_multirow server_types get_serv_types {} {
    lappend options [list $type $type_id]
}

ns_log debug "WEBMAIL: Admin Server started"

# ------------------------- CREATE FORM ------------------------- #

ad_form -name server -form {
    server_id:key(webmail_server_seq)
    {neat_name:text
	{label "#webmail-system.Server_Name#"}}
    {imap_addr:text
	{label "#webmail-system.IMAP_Server#"}}
    {host_addr:text
	{label "#webmail-system.Server_Host#"}}
    {host_append_p:text(select)
	{label "#webmail-system.Append_Host#"}
	{options {{Yes 1} {No 0}}}}
    {imap_port:text
	{label "#webmail-system.IMAP_Port#"}}
    {active_p:text(select)
	{options {{Yes t} {No f}}}
	{label "#webmail-system.Active#"}}
    {server_type:text(select)
	{label "#webmail-system.Type#"}
	{options $options}}
    {auth_type:text(select)
	{label "#webmail-system.Authentication_Type#"}
	{options $opts}}
    {smtp_addr:text
	{label "#webmail-system.SMTP#"}}
    {smtp_port:text
        {label "#webmail-system.SMTP_Port#"}}
    {smtp_auth_p:text(select)
	{options {{Yes t} {No f}}}
	{label "#webmail-system.SMTP_Auth#"}}
} -select_query_name select_server -on_request {
    # if only default server allowed
} -new_data {
	db_dml add_server {}
} -edit_data {
    db_dml edit_server {}
} -after_submit {
    ad_returnredirect "servers"
    ad_script_abort
}


ns_log debug "WEBMAIL: Admin Server complete"

# --------------------------------------------------------------- #

ad_return_template

# ------------------------- END OF FILE ------------------------- #
