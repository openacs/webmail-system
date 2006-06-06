# --------------------------------------------------------------- #
#                            MAIL REPLY                           #
#                                                                 #
# LOCATION: packages/webmail-system/www/mail-reply.tcl            #
#                                                                 #
# --------------------------------------------------------------- #

# ------------------------ PAGE CONTRACT ------------------------ #

ad_page_contract {
	
	Replying to a user's email

	@author Ayman Mohamed (mo2mo@hotmail.com)
	@author Nima Mazloumi (mazloumi@uni-mannheim.de)
	@creation-date 11/10/2002

} {
	number:notnull
	action:notnull
}


# ------------------------ SET VARIABLES ------------------------ #

ns_log debug "WEBMAIL: Mail Reply started"

set user_id [ad_conn user_id]
# Different settings based on each action (reply or forward)
if { $action == "reply"} {
    set page_title "#webmail-system.Mail_reply#"
    set prefix [_ webmail-system.Re]
} else {
    set page_title "#webmail-system.Mail_forward#"
    set prefix [_ webmail-system.Fwd]
}

set id [ad_get_client_property webmail-system conn_id]
set recipient [ns_imap header $id $number from]
set subject "[_ webmail-system.Re] [ns_imap header $id $number subject]"
set sender [ns_imap header $id $number to]

set content ""

# -------------------------- PROCESSING ------------------------- #

ns_imap struct $id $number -array struct
# Preparing the body format in the reply message
if { $struct(type) == "multipart" } {
    for { set i 1 } { $i <= $struct(part.count) } { incr i } {
        array set part $struct(part.$i)
        if { ![info exists part(body.name)] } {append content [ns_imap body $id $number $i -decode]}
    }
} else {
    set content [ns_imap text $id $number]
}

set body "\n\n\n\n---------------[_ webmail-system.Original_Message]---------------\n\n"
append body "[_ webmail-system.To] $sender\n[_ webmail-system.From] $recipient\n[_ webmail-system.Subject] $subject\n\n"
append body $[ad_html_to_text $content]
append body "\n\n-------------[_ webmail-system.End_Original_Message]-------------\n"

append prefix $subject

# Scanning the recipient line for just the email without any other
# tags or strings such as < > or ""

set found [regexp {([-A-Za-z0-9_.]+@[-A-Za-z0-9_.]+)} $recipient match email]

# Recipient only used if the action is reply
set recipient $email

# ------------------------- CREATE FORM ------------------------- #

set use_wysiwyg_p [parameter::get -parameter "UseWysiwygP" -default "f"]

set opts [list]

db_multirow emails get_emails {} {
  lappend opts [list "$username@$host_addr"]
}

ad_form -name reply_email -form {
    {from:text(select)
        {html {single single}}
        {options $opts}
        {value "[lindex $opts 0]"}
        {label "[_ webmail-system.From]"}}
    {to:text
	{html { size 74 }}
	{label "[_ webmail-system.To]"}}
    {cc:text,optional
	{html { size 74 }}
	{label "[_ webmail-system.Cc]"}}
    {bcc:text,optional
	{html { size 74 }}
	{label "[_ webmail-system.Bcc]"}}
    {subject:text
	{html { size 74 }}
	{label "[_ webmail-system.Subject]"}}
    {attachment:file,optional
	{html { size 37 }}
	{label "[_ webmail-system.Attachment]"}}
    {body:richtext(richtext),optional
	{htmlarea_p $use_wysiwyg_p}
	{html { cols 56 rows 8 wrap soft }}
	{label "[_ webmail-system.Body]"}}
    {submit:text(submit)
        {label "[_ webmail-system.Send]"}
    }
} -action "sending" -on_request {
} -on_request {
    set htmlarea_p $use_wysiwyg_p
    set body [template::util::richtext::create $content "text/html"]
    if { $action == "reply" } {set to $recipient}
}

# --------------------------------------------------------------- #

ns_log debug "WEBMAIL: Mail Reply complete"

ad_return_template

# ------------------------- END OF FILE ------------------------- #
