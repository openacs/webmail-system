# --------------------------------------------------------------- #
#                         SENDING AN EMAIL                        #
#                                                                 #
# LOCATION: packages/webmail-system/www/sending.tcl               #
#                                                                 #
# --------------------------------------------------------------- #

# ------------------------ PAGE CONTRACT ------------------------ #

ad_page_contract {
    
    Sending an email
    
    @author Ayman Mohamed (mo2mo@hotmail.com)
    @author Nima Mazloumi (mazloumi@uni-mannheim.de)
    @creation-date Sept 25, 2002
    
} {
    from:notnull
    to:notnull
    cc:optional
    bcc:optional
    subject:optional
    body:optional
    attachment:optional   
}

# ------------------------- SET VARIABLES ----------------------- #

if { $cc == "" } {
	set to_and_cc "$to"
	ns_log debug "WEBMAIL: CC is nil"
} else {
	set to_and_cc "$to, $cc"
	ns_log debug "WEBMAIL: CC not nill: $to_and_cc"
}

# -------------------------- PROCESSING ------------------------- #

ns_log debug "WEBMAIL: $from $to_and_cc $subject $body"

#webmail::mail_send $from $to_and_cc $subject $body
set upload_file [template::util::file::get_property filename $attachment]
set tmpfile [template::util::file::get_property tmp_filename $attachment]
set type [template::util::file::get_property mime_type $attachment]
ns_log Notice "ATTACHMENT: <$attachment> <$upload_file> <$tmpfile> <$type>"


ns_log debug "WEBMAIL: Email processed."

# --------------------------------------------------------------- #

ad_returnredirect "retrieve"

# ------------------------- END OF FILE ------------------------- #
