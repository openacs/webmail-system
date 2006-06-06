ad_library {

    Procs for Webmail-System
    @author mazloumi@uni-mannheim.de
    @creation-date 2004-08-15

}

namespace eval webmail {

    ######################################################################
    # Procedure:       activate_account
    # Params:          account_id
    # Description:     Returns activates an account
    ######################################################################

    ad_proc -public activate_account {

	{-account_id:required}
    } {
        @param account_id     The unique account id for the user
        Activates an account and verifies it. the active status is set
    } {
	
	# get account information. make sure the user ids correspond
	set uid [ad_conn user_id]
	
	if {![db_0or1row select_nav_bar_setting {}]} {
	    set nav_bar 1
	}
	
	if {[db_0or1row select_account select_account]} {	  
	    #let's close an active session first
	    set old_server [ad_get_client_property webmail-system neat_name]
	    webmail::close_session
	    
	    if {[exists_and_not_null old_server]} {webmail::notify_user -type "auth" -message "[_ webmail-system.Closed_session_with_old_server]"}
	    
	    set UW_imap_server "\{$imap_addr:$imap_port$type$auth_type\}"
	    ns_log Notice "$UW_imap_server $username $password"
	    set id [ns_imap open -mailbox $UW_imap_server -user $username -password $password -expunge]
	    
	    # now lets verify the account by login in. If successful inform the user about inbox status
	    if [catch { set id [ns_imap open -mailbox $UW_imap_server -user $username -password $password -expunge] } errmsg] {
		
		webmail::notify_user -type "error" -message "[_ webmail-system.Unable_to_connect_to_server]"
		webmail::expired_session "WEBMAIL: Unable to connect with server"
		
		# deactivate account
		webmail::set_account_activity -account_id $account_id -active_p "f"

		webmail::notify_user -type "warning" -message "[_ webmail-system.Bad_account_or_server_down]"
		
	    } else {
		webmail::notify_user -type "auth" -message "[_ webmail-system.Connected_to_serv_neat_name]"
		# set session parameters for this account
		ad_set_client_property webmail-system username $username
		ad_set_client_property webmail-system server_id $server_id
		ad_set_client_property webmail-system server $imap_addr
		ad_set_client_property webmail-system conn_id $id
		ad_set_client_property webmail-system neat_name $neat_name
		ad_set_client_property webmail-system nav_bar $nav_bar
		ad_set_client_property webmail-system email $email
		ad_set_client_property webmail-system password $password
		ad_set_client_property webmail-system smtp_server $smtp_addr
		webmail::get_status
		
		webmail::set_account_activity -account_id $account_id -active_p "t"
	    }
	} else {
	    webmail::notify_user -type "error" -message "[_ webmail-system.No_such_account]"
	}
    }
    
    ######################################################################
    # Procedure: 	set_account_activity
    # Params:           account_id, active_p
    # Description:	Changes the activity status of an account
    ######################################################################

    ad_proc -private set_account_activity {
	{-account_id:required}
	{-active_p:required}
    } {
	@param account_id     The account to affected
	@param active_p       The status to set the account to 't' or 'f'
	Changes the activity status of an account
    } {
	set user_id [ad_conn user_id]
	db_dml set_status {}
    }
    ######################################################################
    # Procedure: 	verify_email
    # Params:           server_id, email
    # Description:	Verifies if a given email address is valid for this server
    ######################################################################

    ad_proc -private verify_email {
	{-server_id:required}
	{-email:required}
	{-username:required}
    } {
	@param server_id     The server to verify with
	@param email         The email the user indicated
	@param username      The username of the account
	Return 1 if it is a vali email address. Depends on the flag host_append_p
	that must be set to 1. Otherwise always 1 is returned.
    } {

	db_1row get_server_info {}
	if { $host_append_p == 1 } {
	    set correct_email "$username@$host_addr"
	    if { $email == $correct_email } {
		return 1
	    } else {
		webmail::notify_user -type "error" -message "[_ webmail-system.Your_email_must_end_with_host_addr]"
		return 0
	    }
	} else {
	    return 1
	}
    }

    ######################################################################
    # Procedure: 	notify_user
    # Params:           type, message
    # Description:	Create a user message that will be displayed on the next page
    ######################################################################

    ad_proc -public notify_user {
	{-type:required "info"}
	{-message:required ""}
    } {
	@param type        The message type
	@param message     The actual message
	Create a user message that will be displayed on the next page
	Permitted types are: info, warning, cool, error, question, auth
    } {
	set url [ad_conn package_url]
	util_user_message -html -message "$message<img src=\"$url/images/$type.gif\" align=\"middle\" width=\"20\" height=\"20\">"
    }

    ######################################################################
    # Procedure: 	create_account
    # Params:           server_id, username, password, email
    # Description:	Creates a new account for the user
    ######################################################################
    
    ad_proc -public create_account {
	{-server_id:required}
	{-username:required}
	{-password:required}
	{-email:required}
    } {
	@param server_id       The server to create the account for
	@param username        The login for that server
	@param password        The password to authenticate with
	@param email           The email address for the sender header
	
	Creates a new account. Initially the account is set to inactive mode. Returns the account_id
    } {

	set user_id [ad_conn user_id]

	# if the account doesnt exists already
        if {![db_0or1row account_exists {}]} {
	    
	    #we create it
	    set account_id [db_nextval webmail_account_seq]
	    db_dml add_active_account {}
	    webmail::notify_user -type "cool" -message "[_ webmail-system.Account_created]"
	    return $account_id
	} else {
	    #webmail::notify_user -type "info" -message "[_ webmail-system.Account_exists]"
	    return $account_id
	}
    }

    ######################################################################
    # Procedure: 	verify_session
    # Description:	
    ######################################################################

    ad_proc -public verify_session {
	Checks if we have an active session
    } {
	set id [ad_get_client_property webmail-system conn_id]

	# Checking if the user is logged in (ie. session currently running)
	# Also, checking if the connection is still alive
	if { [empty_string_p $id] || [catch { set new_mail [ns_imap ping $id] } errmsg] } {
	    webmail::expired_session "WEBMAIL: No active Session"
	    return
	}
    }
    
    ######################################################################
    # Procedure: 	expired_session
    # Params:	        reason
    # Description:	Redirects the page if the session is expired
    ######################################################################

    ad_proc -public expired_session { reason } {
	Closes the session
    } {
	ns_log Error "$reason"
	webmail::close_session
	ad_returnredirect "not-logged-in"
	return
    }

    ######################################################################
    # Procedure:	close_session
    # Params:	        -
    # Description:	Sets all session params to null
    ######################################################################

    ad_proc -public close_session { } {
	Sets all client properties previously calling ad_get_client_property to empty string
    } {
	ns_log debug "WEBMAIL: Closing the session"

	set url [ad_conn package_url]
        # first we check if there is an open connection. we close everything first.
        set id [ad_get_client_property webmail-system conn_id]
        if { [empty_string_p $id] || [catch { set new_mail [ns_imap ping $id] } errmsg] } {
            #webmail::notify_user -type "warning" -message "[_ webmail-system.No_active_session]"
        } else {
            ns_imap close $id
            #webmail::notify_user -type "info" -message "[_ webmail-system.Active_session_closed]"
        }
	
	#and reset all parameters
	ad_set_client_property webmail-system conn_id ""
	ad_set_client_property webmail-system account_id ""
	ad_set_client_property webmail-system username ""
	ad_set_client_property webmail-system password ""
	ad_set_client_property webmail-system email ""
	ad_set_client_property webmail-system server_id ""
	ad_set_client_property webmail-system server ""
	ad_set_client_property webmail-system neat_name ""
	ad_set_client_property webmail-system host ""
	ad_set_client_property webmail-system next 1
	ad_set_client_property webmail-system nav_bar 0
    }


    ######################################################################
    # Procedure:	get_status
    # Params:	        -
    # Description:	Gets current inbox status
    ######################################################################

    ad_proc -public get_status { } {
	Gets current inbox status
    } {
	set url [ad_conn package_url]
        # first we check if there is an open connection. we close everything first.
        set id [ad_get_client_property webmail-system conn_id]

	set recent_msgs [ns_imap n_recent $id]
	set total_msgs [ns_imap n_msgs $id]
	if { $recent_msgs > 0 && $total_msgs > 0 } {
	    webmail::notify_user -type "cool" -message "[_ webmail-system.You_have_recent_total_email]"
	}
	if { $recent_msgs == 0 && $total_msgs  > 0 } {
	    webmail::notify_user -type "info" -message "[_ webmail-system.You_have_no_new_mail_total_email]"
	}
	if { $recent_msgs == 0 && $total_msgs == 0 } {
	    webmail::notify_user -type "warning" -message "[_ webmail-system.Your_inbox_is_empty]"
	}
    }

    ######################################################################
    # Procedure:        mail_format_body
    # Params:           email body
    # Description:      Formats the body of the message
    ######################################################################

    ad_proc -public mail_format_body { body } {
	Prepares the mail body and wraps it inside a PRE HTML tag
    } {
	#set body [ns_quotehtml $body]  
	#set body [ns_imap striphtml $body]
	return "<pre>$body</pre>"
    }

    ######################################################################
    # Procedure: 	mail_send
    # Params:	        recipients sender subject body
    # Description:	Sends an email from the sender to the recipients
    ######################################################################

    ad_proc -public mail_send { sender recipients subject body } {
	Sends an email over Sendmail installed locally
    } {
	ns_log debug "WEBMAIL: Starting the ns_sendmail command..."
	
	if [catch { ns_sendmail $recipients $sender $subject $body } errmsg] {
	    ns_log debug "WEBMAIL: Email to $recipients failed: $errmsg"
	}
	
	ns_log debug  "WEBMAIL: Ending the ns_sendmail command..."
    }


    ######################################################################
    # Procedure:        change_format
    # Params:           message display_style
    # Description:      Formats the body of the message
    ######################################################################

    ad_proc -public change_format {
	{-body:required}
	{-style:required}
	{-js_enabled:required}
	{-content_type:required}
    } {
	@param body           The content of the email
	@param style          The destined format
	@param js_enabled     Should we allow JavaScript
	Formats the body of the message in accordance to the given style
    } {
	ns_log Error "TYPE: $content_type"
	if { $js_enabled == 0 } {set body [ns_imap striphtml $body]}
	switch $style {
	    0 {
		# Full HTML
		return [util_close_html_tags $body]
	    }
	    1 {
		# No CSS
		if { $content_type == "text/html" } {
		    set body [disable_attributes -html $body -attr [list class style]]
		}
		return [util_close_html_tags $body]
	    }
	    2 {
		# Enhanced Text
		return [ad_text_to_html [ad_html_to_text $body]]
	    }
	    3 {
		# Plain Text
	        #return ad_convert_to_text -html_p "t" $body
		return [ad_html_text_convert -from "text/html" -to "text/plain" $body]
	    }
	}
    }

    ######################################################################
    # Procedure:        mail_decode_hdr
    # Params:           header string
    # Descrption:       Decodes header string
    ######################################################################
    
    ad_proc -public mail_decode_hdr { str } {
	Decodes the email
    } {
	set b [string first "=?" $str]
	if { $b >= 0 } {
	    set b [string first "?" $str [expr $b+2]]
	    if { $b > 0 } {
		set e [string first "?=" $str $b]
		if { $e == -1 } { set e end } else { incr e -1 }
		switch [string index $str [expr $b+1]] {
		    Q {
			set str [ns_imap decode qprint [string range $str [expr $b+3] $e]]
		    }
		    B {
			set str [ns_imap decode base64 [string range $str [expr $b+3] $e]]
		    }
		}
	    }
	}
	return $str
    }
    
    ######################################################################
    # Procedure:       mail_format_size
    # Params:          size of the email
    # Description:     Formats given size in bytes into more user-friendly size text
    ######################################################################


    ad_proc -public mail_format_size { size } {
	@option size   Size is bytes
	Sets the size of the email depending on the number of bytes
    } {
	if { $size > 1048576 } {
	    set size "[format \"%.1f\" [expr $size / 1048576.0]]Mb"
	} elseif { $size > 1024 } {
	    set size "[format \"%.1f\" [expr $size/1024.0]]Kb"
	}
	return $size
    }

    ######################################################################
    # Procedure:       create_boundary
    # Params:          string
    # Description:     creates a unique boundary within the email context
    ######################################################################

    ad_proc -private create_boundary {
	{str ""}
    } {
        param str   An optional string to create the boundary
	Creates a unique boundary within the email context
    } {
	if {[exists_and_not_null str]} {
	    return "OACS-[md5::md5 $str]"
	} else {
	    return "OACS-2e4w7w0k32-0A"
	}
    }

    ######################################################################
    # Procedure:       encode
    # Params:          temporary file
    # Description:     takes a file from local disk and returns it base64 encoded
    ######################################################################


    ad_proc -private encode {
	{-file:required}
    } {
	@param file    Path to a valid file on disk 
	Returns a given file base 64 encoded. Requires mmencode
    } {
	set mmencode "/usr/bin/mmencode"
	set fp [open "|$mmencode -b $file" r]
	set b64 [read $fp]
	close $fp
	return $b64
    }

    ######################################################################
    # Procedure:       create_header
    # Params:          content_type boundary
    # Description:     creates a default header for the email depending on the content_type
    ######################################################################

    ad_proc -public create_header {
	{-content_type:required}
	{-has_attach_p:required}
    } {
	@param content_type   The content_type of the email
	@param has_attach_p   Wether this emails contains attachments or not
	Creates the header depending on the content_type
    } {

	set header [ns_set new]
	ns_set put $header "MIME-Version" "1.0"
	ns_set update $header "X-Mailer" "OpenACS 5.1"

	if { $has_attach_p} {
	    set boundary [webmail::create_boundary]
	    set cnt_type "Multipart/Mixed; boundary=\"$boundary\""
        } else {
	    set cnt_type "$content_type; charset=UNICODE-1-1"
	    ns_set update $header "Content-Transfer-Encoding" "7bit"
	}

	ns_set update $header "Content-Type" "$cnt_type"

	return $header

    }

    ######################################################################
    # Procedure:       create_notice
    # Params:          
    # Description:     creates the notice part for older email clients
    ######################################################################

    ad_proc -private create_notice {
    } {
	Creates the notice for older email clients
    } {

       set notice "This is a multi-part message in MIME format.\n\nThis message is in MIME format. Because your mail reader does not understand this format, some or all of this message may not be legible.\n"
	return $notice
    }

    ######################################################################
    # Procedure:       create_body
    # Params:          body boundary
    # Description:     creates the message part of the email
    ######################################################################

    ad_proc -public create_body {
	{-has_attach_p}
	{-body:required}
    } {
	@param body        The email richtext message, a list with two elements {text} mime_type
	@param boundary    A unique value within the email context
	Creates the message part of the email
    } {

	set body_content [template::util::richtext::get_property contents $body]
	set body_type [template::util::richtext::get_property format $body]

	if {$has_attach_p} {
	    #Email with attachment
	    set boundary [webmail::create_boundary]
	    set notice [webmail::create_notice]
	    set mail_body "--$boundary\nContent-Type: $body_type; charset=\"UNICODE-1-1\"; format=flowed\nContent-Transfer-Encoding: 7bit\n\n$body_content\n\n"
	} else 	{
	    #Email without attachment
	    set notice ""
	    set mail_body $body_content
	}
	return $notice$mail_body

    }


    ######################################################################
    # Procedure:       create_attachment
    # Params:          file
    # Description:     creates the attachment part of the email
    ######################################################################

    ad_proc -public create_attachment {

	{-file:required}

    } {
	@param file           The file retrieved from an ad_form element
	Creates an attachment part for the email
    } {
	set filename [template::util::file::get_property filename $file]
        set tmp_file [template::util::file::get_property tmp_filename $file]
        set mime_type [template::util::file::get_property mime_type $file]
        set b64 [webmail::encode -file $tmp_file]

	set boundary [webmail::create_boundary]
	
	set attach_body "--$boundary\nContent-Type: $mime_type;\n   name=\"$filename\"\nContent-Disposition: attachment;\n   filename=\"$filename\"\nContent-Transfer-Encoding: base64\n\n$b64\n\n"
	return $attach_body
	
    }


    ######################################################################
    # Procedure:       add_vcard
    # Params:          content
    # Description:     creates a vcard attachment for the email
    ######################################################################

    ad_proc -public add_vcard {

	{-content:required}

    } {
	@param content    content of the vCard as a list: name, type, content
	Creates a vcard for the email
    } {
	#set type [lindex $content 1] not used since results in application/base64

	set boundary [webmail::create_boundary]
	set filename [lindex $content 0]
	set body [lindex $content 2]

	set attach_body "--$boundary\nContent-Type: text/x-vcard; charset=utf8;\n   name=\"$filename\"\nContent-Transfer-Encoding: 7bit\nContent-Disposition: attachment;\n   filename=\"$filename\"\n\n$body\n\n"
        return $attach_body
	
    }


    ######################################################################
    # Procedure:       create_email
    # Params:          content attachment boundary
    # Description:     creates the full email ready to be sent
    ######################################################################

    ad_proc -public create_email {

	{-content:required}
	{-attachment:required}
	{-vcard:required}
    } {
	@param content        The content block of the email
	@param attachment     A given attachment block
	@param vcard          A given vCard block
	Creates the full email ready to be sent
    } {
	if { [exists_and_not_null attachment] || [exists_and_not_null vcard] } {
	    set boundary [webmail::create_boundary]
	    set close_part "--$boundary--\n"
	    return "$content$attachment$vcard$close_part"
	} else {
	    return "$content\n"
        }
    }


    ######################################################################
    # Procedure:       quoted_printable_encode
    # Params:          text charset
    # Description:     Encodes special characters in the message header according to RFC 2047
    ######################################################################

    ad_proc -private quoted_printable_encode { 
        -text:required
        {-charset ""}
    } {
        Encode special characters, like german umlauts, in message headers 
        according to RFC 2047.
    } {
        # First check if there are any characters which need to be quoted at all.
        set encode_p 0
        for { set i 0 } { $i < [string length $text] } { incr i } {
            if { ![string is ascii [string index $text $i]] } {
	         set encode_p 1
            }
        }
        
        if { !$encode_p } { return $text }

        set hex "0123456789ABCDEF"

        if {[empty_string_p $charset]} {
           set end_of_line "="
           set begin_of_line ""
        } else {
           set end_of_line "?="
           set begin_of_line "=?$charset?Q?"
        }

        set result ""
        set line $begin_of_line

        for { set i 0 } { $i < [string length $text] } { incr i } {
            set current [string index $text $i]
            if { ![string is ascii $current] || [string first $current " \t\r\n()<>@,;:/\[\]?.=\"\\"] != -1 } {
	        binary scan $current c x
	        append line "=[string index $hex [expr ($x & 0xf0) >> 4]][string index $hex [expr $x & 0x0f]]"
            } else {
	        append line $current
            }
           if { [string length $line] > 70 } {
	      if { ![empty_string_p $result] } { append result "\n" }
	      append result "${line}$end_of_line"
	      set line $begin_of_line
           }
        }

        if { ![string equal $line $begin_of_line] } {
            if { ![empty_string_p $result] } { append result "\n" }
            append result "${line}$end_of_line"
        }

        return $result
    }


    ######################################################################
    # Procedure:       disable_attribute
    # Params:          html attr
    # Description:     Disables all passed HTML Attributes.
    ######################################################################

    ad_proc -private disable_attributes { 
        {-attr:required}
        {-html:required}
    } {
        @param html       The HTML to parse
        @param attr       The list of attributes to disable
        Disables all passed  HTML Attributes.
    } {
        set attributes [list]
        for { set i [string first < $html] } { $i != -1 } { set i [string first < $html $i] } {
           incr i
           regexp -indices -start $i {\A/?([-_a-zA-Z0-9]+)\s*} $html match name_idx
           set i [expr { [lindex $match 1] + 1}]
           while { $i < [string length $html] && ![string equal [string index $html $i] {>}] } {
	      if { ![regexp -indices -start $i {\A\s*([^\s=>]+)\s*(=?)\s*} $html match attr_name_idx equal_sign_idx] } {
	         regexp -indices -start $i {\A[\s=]*} $html match
	         set i [expr { [lindex $match 1] + 1 }]
	      } {
	         set attr_name [string tolower [string range $html [lindex $attr_name_idx 0] [lindex $attr_name_idx 1]]]
	         set i [expr { [lindex $match 1] + 1}]

	         if { [lindex $equal_sign_idx 1] - [lindex $equal_sign_idx 0] < 0 } {
                    lappend attributes $attr_name
	         } else {
		    switch -- [string index $html $i] {
		       {"} { set exp {\A"([^"]*)"\s*} }
	           {'} { set exp {\A'([^']*)'\s*} }
	           default { set exp {\A([^\s>]*)\s*} }
	        }
	        if { ![regexp -indices -start $i $exp $html match attr_value_idx] } {
		       set attr_value [string range $html [expr {$i+1}] end]
		       set i [string length $html]
		    } else {
		       set attr_value [string range $html [lindex $attr_value_idx 0] [lindex $attr_value_idx 1]]
		       set i [expr { [lindex $match 1] + 1}]
		    }
		    set attr_value [util_expand_entities_ie_style $attr_value]
		    lappend attributes [list $attr_name $attr_value]
	         }
              }
           }
        } 

        foreach pair $attributes {
           ns_log error "PAIR: <$pair>"
           set size [llength $pair]
	   if { $size == 2 } {
              # if the attribute has also a value replace the value
	      set key [lindex $pair 0]
              set value [lindex $pair 1]
              foreach unwanted_attr $attr {
                 if { $key == $unwanted_attr } {
                    regsub -nocase -all "$value" $html "dummy" html
                    regsub -nocase -all "$key" $html "dummy_$key" html
                 }
	      }
           } else {
              # else replace the attribute
              set key [lindex $pair 0]
              foreach unwanted_attr $attr {
                 if { $key == $unwanted_attr } { regsub -nocase -all "$attr" $html "dummy_$attr" html }
              }
          }
        }
      return $html
    }


    ######################################################################
    # Procedure:       read_file
    # Params:          file
    # Description:     Returns the name, type and content of a file as a list
    ######################################################################

    ad_proc -public read_file {

	{-file:required}

    } {
	@param file    full path to a file on disk
        Returns the name, type and content of a file as a list
    } {
	set filename [template::util::file::get_property filename $file]
        set tmp_file [template::util::file::get_property tmp_filename $file]
        set mime_type [template::util::file::get_property mime_type $file]

        set fileId [open "$tmp_file"]
	set content [read $fileId]
        close $fileId
        return [list $filename $mime_type $content]
    }


    ######################################################################
    # Procedure:       parse_sender
    # Params:          sender
    # Description:     Tries to parse first_names, last_name and email from sender
    #                  Returns an array      
    ######################################################################

    ad_proc -public parse_sender {

	{-sender:required}
        {-array:required}
      
    } {
        @param sender      The sender header of an email
        @param array       The array to put the result in
        Tries to parse first_names, last_name and email from sender and creates an array
    } {

    upvar 1 $array result

    regexp {"(.*?)" <(.*?)>} $sender match person email
    if {[exists_and_not_null person]} {
        set person [split $person " "]
        set size [llength $person]
        switch $size {
            1 {
                set first_names ""
                set last_name [lindex $person 0]
            }
            2 {
                set first_names [lindex $person 0]
                set last_name [lindex $person 1]
            }
            default {
                set last_name [lindex $person end]
                set first_names [join [lrange $person 0 [expr $size -2]] " "]
            }
        }
    } else {
        set first_names ""
        set last_name ""
        set email $sender
    }
        set result(first_names) $first_names
        set result(last_name) $last_name
        set result(email) $email

        return
    }


}
# ------------------------- END OF FILE ------------------------- #