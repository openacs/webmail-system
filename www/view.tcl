#---------------------------------------------------------------- #
#                       VIEWING SELECTED EMAIL                    #
#                                                                 #
# LOCATION: packages/webmail-system/www/view.tcl                  #
#                                                                 #
# --------------------------------------------------------------- #

ad_page_contract {

    Viewing the contents of the user's selected email.
    
    @author Ayman Mohamed (mo2mo@hotmail.com)
    @author Nima Mazloumi (mazloumi@uni-mannheim.de)
    @creation-date 1/10/2002
    
} {
    number:notnull
    header:optional
    print_p:optional
}

# ------------------------ SET VARIABLES ------------------------ #
ns_log debug "WEBMAIL: View started"

set page_title "#webmail-system.Viewing_email#"

set user_id [ad_conn user_id]

set style 0
set js_enabled 0
db_0or1row select_prefs {}

if {[exists_and_not_null print_p]} {
    set print_p 1
} else {
    set print_p 0
}

set id [ad_get_client_property webmail-system conn_id]

if { [exists_and_not_null header] } {
    set header_p 1
    set header [join [ns_imap headers $id $number] <br>]
} else {
    set header_p 0
}

set msg [ns_imap n_msgs $id]
set status [ns_imap status $id]
set folder [ns_imap getparam $id mailbox.name]

# Build the list-builder list
template::list::create \
    -name files \
    -multirow files \
    -elements {
        part_num {
            label ""
            html "align right"
            display_template {
                <A HREF="view-attach?number=@files.part_num@&part=@files.item_no@">
                <IMG SRC="images/attach.gif" ALT="#webmail-system.Attachment# - @files.name@" BORDER=0></A>
                </if>
	    }
        } name {
            label "[_ webmail-system.Filename]"
            html "align left"
            link_url_col file_link
        } type {
            label "[_ webmail-system.File_type]"
            html "align left"
        } size {
            label "[_ webmail-system.File_size]"
            html "align left"
        }
    }


# ------------------------- PROCESSING 1 ------------------------ #

# Looping through all messages in the folder (ie. $msg)

# Determining whether the current email is the first in the folder
if { $number > 1 } {
	set min 0	;# false
	set prev_num [expr $number - 1]
} else {
	set min 1	;# true
}

# Determining whether the current emails is the last in the folder
if { $number < $msg } {
	set max 0	;#false
	set next_num [expr $number + 1]
} else {
	set max 1	;#true
}

# ------------------------- PROCESSING 2 ------------------------ #

# Retrieving all components of the message including attachments
# if they are within the email

ns_imap struct $id $number -array struct

# Basic headers
set recipients [ns_imap header $id $number to]
set cc [ns_imap header $id $number cc]
set date [ns_imap header $id $number date]
set sender [webmail::mail_decode_hdr [ns_imap header $id $number from]]
webmail::parse_sender -sender $sender -array person

set subject [webmail::mail_decode_hdr [ns_imap header $id $number subject]]

if { $subject == "" } {
    set subject "#webmail-system.No_Subject#"
}

set flags $struct(flags)
set attachments 0

set print_version "<h2>[ad_system_name]</h2> \
    [_ webmail-system.From] $sender<br>\
    [_ webmail-system.To] $recipients<br>\
    [_ webmail-system.Subject] <b>$subject</b><br>\
    [_ webmail-system.Date] $date<br><hr><br>"

# For multipart messages show plain text in the body and list of attachments below
if { $struct(type) == "multipart" } {
    set attachments 1
    set body ""
   
    multirow create files part_num name file_link type size item_no
    
    for { set i 1 } { $i <= $struct(part.count) } { incr i } {
	array set part $struct(part.$i)
	if { [info exists part(body.name)] } {
	    set part_type [string tolower "$part(type)/$part(subtype)"]
	    set part_size [webmail::mail_format_size $part(bytes)]
	    multirow append files "$i" "$part(body.name)" "view-attach?number=$number&part=$i" "$part_type" "$part_size" "$number"
	} else {
	    set content [ns_imap body $id $number $i -decode]
	    append body [webmail::mail_format_body [webmail::change_format -content_type $struct(type) -style $style -js_enabled $js_enabled -body $content]]
	    append print_version [webmail::mail_format_body [webmail::change_format -content_type $struct(type) -style 3 -js_enabled 0 -body $content]]
	}
    }
} else {
    set attachments 0
    set content [ns_imap text $id $number]
    set body [webmail::mail_format_body [webmail::change_format -content_type $struct(type) -style $style -js_enabled $js_enabled -body $content]]
    append print_version [webmail::mail_format_body [webmail::change_format -content_type $struct(type) -style 3 -js_enabled 0 -body $content]]
}

set body_size [string length $body]

ns_log debug "WEBMAIL: Viewing complete"

# --------------------------------------------------------------- #

ad_return_template

# ------------------------- END OF FILE ------------------------- #
