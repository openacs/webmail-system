# --------------------------------------------------------------- #
#                         COMPOSE AN EMAIL                        #
#                                                                 #
# LOCATION: packages/webmail-system/www/compose.tcl               #
#                                                                 #
# --------------------------------------------------------------- #

# ------------------------ PAGE CONTRACT ------------------------ #
	
ad_page_contract {
	
	Composing an email to be sent.

	@author Ayman Mohamed (mo2mo@hotmail.com)
	@author Nima Mazloumi (mazloumi@uni-mannheim.de)
	@creation-date 12/9/2002

} {
    number:optional
    action:optional
    attachment:trim,optional
    attachment.tmpfile:tmpfile,optional
    contact_id:optional
} -validate {
    max_size -requires {attachment} {
        set n_bytes [file size ${attachment.tmpfile}]
        set max_bytes [ad_parameter "MaximumFileSize"]
        if { $n_bytes > $max_bytes } {
	    set size [util_commify_number $max_bytes]
	    webmail::notify_user -type "error" -message "[_ webmail-system.Your_file_is_larger_than_the_maximum_file_size_allowed_on_this_system]"
            ad_complain "[_ webmail-system.Your_file_is_larger_than_the_maximum_file_size_allowed_on_this_system]"
        }
    }
}

# ------------------------ SET VARIABLES ------------------------ #

ns_log debug "WEBMAIL: Compose started"

set page_title "[_ webmail-system.Composing_an_email]"
set use_wysiwyg_p [parameter::get -parameter "UseWysiwygP" -default "f"]
set user_id [ad_conn user_id]
set package_id [ad_conn package_id]

# ------------------------- CREATE FORM ------------------------- #

#set opts [list]

#db_multirow emails get_emails {} {
#    lappend opts [list $email]
#}
set from [ad_get_client_property webmail-system email]

set max_bytes [ad_parameter "MaximumFileSize"]
set size [util_commify_number $max_bytes]

ad_form -html { enctype multipart/form-data } -name compose_email -form {
    {from:text
	{html {readonly readonly size 50}}
	{label "[_ webmail-system.From]"}}
    {to:text
	{html { size 74 accesskey t }}
	{label "[_ webmail-system.To]"}}
    {cc:text,optional
	{html { size 74 accesskey c }}
	{label "[_ webmail-system.Cc]"}}
    {bcc:text,optional
	{html { size 74 accesskey b }}
	{label "[_ webmail-system.Bcc]"}}
    {subject:text
	{html { size 74 accesskey s }}
	{label "[_ webmail-system.Subject]"}}
    {attachment:file,optional
	{html { size 37 accesskey a }}
	{label "[_ webmail-system.Attachment]"}
	{help_text "[_ webmail-system.Maximum_size_is_limited_to_size]"}}
}

set signature ""
set vcard ""

#As a default we don't simply add an optional vCard
set vcard_p 0

# Check if user has made vCard and Signature settings and extend the form
if { [db_0or1row select_preferences {}] } {
    if {[exists_and_not_null vcard]} {
        ad_form -extend -name compose_email -form {
	    {vcard_p:text(radio),optional
		{label "[_ webmail-system.Add_vCard]"}
		{options {{Yes 1} {No 0}}}}
        }
    }
}

ad_form -extend -name compose_email -form {
    {body:richtext(richtext),optional
	{htmlarea_p $use_wysiwyg_p}
	{html { cols 56 rows 20 wrap soft accesskey b }}
	{label "[_ webmail-system.Body]"}}
    {submit:text(submit)
        {label "[_ webmail-system.Send]"}
    }
} -on_request {
    set htmlarea_p $use_wysiwyg_p

    set prefix ""
    set body ""
    set type ""
    
    if {[exists_and_not_null action] && [exists_and_not_null number]} {
	# Different settings based on each action (reply or forward)
	if { $action == "reply"} {
	    set prefix [_ webmail-system.Re]
	} else {
	    set prefix [_ webmail-system.Fwd]
	}
	set recipient [ns_imap header $id $number from]
	set subject "[_ webmail-system.Re] [ns_imap header $id $number subject]"
	set sender [ns_imap header $id $number to]
	
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
	
	set subject "$prefix$subject"
	
	# Scanning the recipient line for just the email without any other
	# tags or strings such as < > or ""
	
	set found [regexp {([-A-Za-z0-9_.]+@[-A-Za-z0-9_.]+)} $recipient match email]
	set recipient $email
	if { $action == "reply" } {set to $recipient}
    }
    
    if {[exists_and_not_null signature]} { 
	set body "$body\n\n\n\n[lindex $signature 0]"
	set type [lindex $signature 1]
    } else {
	set body $body
	set type "text/enhanced"
    }

    set body [template::util::richtext::create $body $type]

    if {[exists_and_not_null contact_id]} {
	if {[db_0or1row select_contact {}]} {
	    set to "\"$first_names $last_name\" <$email_address>"
	}
    }

} -on_submit {
    #set content_type [template::util::richtext::get_property format $body]

    if {[exists_and_not_null vcard_p] || [exists_and_not_null attachment] } {
	set has_attach_p 1
    } else {
	set has_attach_p 0
    }

    set emailList [list]
    package require smtp
    package require mime

    set vcard_attach ""
    if  {$vcard_p == 1} {
	#set vcard_attach [webmail::add_vcard -content $vcard]
	set vCardFilename [lindex $vcard 0]
	set vCardContent [lindex $vcard 2]
	set vCardT text/x-vcard [mime::initialize -canonical "text/x-vcard; name=\"$vCardFilename\"" -string $vCardContent]
	lappend emailList $vCardT
    }

    #set attach ""
    if {[exists_and_not_null attachment]} {
	#set attach [webmail::create_attachment -file $attachment]

	set filename [template::util::file::get_property filename $attachment]
        set tmp_file [template::util::file::get_property tmp_filename $attachment]
        set mime_type [template::util::file::get_property mime_type $attachment]
        #set b64 [webmail::encode -file $tmp_file]

	set attachT [mime::initialize -canonical "$mime_type; name=\"$filename\"" -file $tmp_file]
	lappend emailList $attachT
    }

    #set header [webmail::create_header -content_type $content_type -has_attach_p $has_attach_p]
    #set content [webmail::create_body -body $body -has_attach_p $has_attach_p]

    set body_content [template::util::richtext::get_property contents $body]
    set body_type [template::util::richtext::get_property format $body]
    set textT [mime::initialize -canonical $body_type -string $body_content]

    lappend emailList $textT

    #set email [webmail::create_email -content $content -attachment $attach -vcard $vcard_attach]

    set multiT [mime::initialize -canonical multipart/mixed -parts $emailList]

    set sender [ad_get_client_property webmail-system email]

    ns_log Debug "Compose: Sending message from $sender to $to"
    #acs_mail_lite::send -to_addr $to -from_addr $sender -subject $subject -body $email -extraheaders $header -package_id $package_id

    set smtp_server [ad_get_client_property webmail-system smtp_server]
    set username [ad_get_client_property webmail-system username]
    set password [ad_get_client_property webmail-system password]
    mime::setheader $multiT Subject $subject
    mime::setheader $multiT X-Mailer "OpenACS 5.1"
    mime::setheader $multiT Message-ID "[md5::md5 $body_content]$sender"

    smtp::sendmessage $multiT \
	-originator $sender \
	-recipients $to \
	-servers $smtp_server -username $username -password $password \
	-debug 1 \
	-header [list From $sender] \
	-header [list To $to] \
	-header [list Subject $subject] \
	-header [list X-Mailer "OpenACS 5.1"] \
	-header [list Message-ID "[md5::md5 $body_content]$sender"]
    mime::finalize $multiT -subordinates all

    webmail::notify_user -type "cool" -message "[_ webmail-system.Your_email_was_sent]"

} -after_submit {
    ad_returnredirect "welcome"
    ad_script_abort
}

# --------------------------------------------------------------- #

ad_return_template

# ------------------------- END OF FILE ------------------------- #
