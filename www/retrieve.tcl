# --------------------------------------------------------------- #
#                       RETRIEVING INBOX LIST                     #
#                                                                 #
# LOCATION: packages/webmail-system/www/retrieve.tcl              #
#                                                                 #
# --------------------------------------------------------------- #

ad_page_contract {

        Retrieving the user's email list from their inbox.

	@author Ayman Mohamed (mo2mo@hotmail.com)
	@author Nima Mazloumi (mazloumi@uni-mannheim.de)
	@creation-date 14/9/2002

} {
    finished_p:optional
    folder:optional
    orderby:optional
    rewind:optional
    forward:optional
}

# ------------------------ SET VARIABLES ------------------------ #
ns_log debug "WEBMAIL: Retrieval Started"

set page_title "#webmail-system.Retrieving_email_list#"

set id [ad_get_client_property webmail-system conn_id]

if { [catch { set status [ns_imap status $id] } errmsg] } {
    webmail::notify_user -type "error" -message "[_ webmail-system.Communication_problem_Please_reload_page]"
}
set recent_msgs [ns_imap n_recent $id]
set total_msgs [ns_imap n_msgs $id]
if { ![exists_and_not_null folder] } {
    set folder [ns_imap getparam $id mailbox.name]
}

set bulk_actions [list [_ webmail-system.Delete_selected_emails] "mail-delete" [_ webmail-system.Delete_selected_emails]]
set bulk_actions_export_vars [list "number"]

# Build the list-builder list
template::list::create \
    -name emails \
    -multirow emails \
    -key number \
    -bulk_actions $bulk_actions \
    -bulk_action_export_vars $bulk_actions_export_vars \
    -sub_class {
        tiny
    } -elements {
	number {
	    label ""
	    html "align right"
	} contact {
	    label ""
	    html "align right"
	    display_template {
		<if @emails.last_name@ ne "">
		<a href="contact?first_names=@emails.first_names@&last_name=@emails.last_name@&email_address=@emails.email@" \
		    title="Add @emails.first_names@ @emails.last_name@ to contacts">\
                <IMG SRC="images/add_contact.gif" BORDER=0>
                </a>
		</if>
		<else>
		<a href="contact?last_name=@emails.last_name@&email_address=@emails.email@" \
		    title="Add @emails.email@ to contacts">\ 
                <IMG SRC="images/add_contact.gif" BORDER=0>
                </a>
		</else>
	    }
        } sender {
            label "[_ webmail-system.Sender]"
            html "align left"
        } subject {
            label "[_ webmail-system.Subject]"
            html "align left"
	    link_url_col subject_link
        } date {
            label "[_ webmail-system.Date]"
            html "align left"
        } size {
	    label "[_ webmail-system.File_size]"
	    html "align right"
	} delete {
	    label ""
	    html "align center"
	    display_template {
		<A HREF="mail-delete?number=@emails.number@&last=@emails.max@" title="#webmail-system.Delete#">\
		    <img src="images/trash.gif" width="19" height="19" border="0"></A>
	    }
	}
    } -orderby {
	sender {orderby sender}
	size {orderby size}
	subject {orderby subject}
	date {orderby date}
    } -selected_format csv -formats {
        csv { output csv }
    }

multirow create emails number max sender email first_names last_name subject subject_link date size attachments

# -------------------------- PROCESSING ------------------------- #


# Looping through all messages (num_of_msgs) in the folder
if {![exists_and_not_null finished_p]} {
    set finished_p 0
} else {
    set finished_p 1
}

if { !$finished_p } {
    ad_progress_bar_begin \
	-title "[_ webmail-system.Getting_your_emails]" \
	-message_1 "[_ webmail-system.Depending_on_the_provider_you_use_this_may_take_a_while]" \
	-message_2 "[_ webmail-system.We_will_continue_automatically_when_retrieval_is_complete]" \
	-template "templates/progress-bar"
}

ns_log debug "WEBMAIL: Retrieval started"

#number of messages
set msg [ns_imap n_msgs $id]

# pagination
set limit [parameter::get -parameter "MaxListSize" -default 20]
set count 0
set next [ad_get_client_property webmail-system next]
if {![exists_and_not_null next]} { set next 1 }

#if {[exists_and_not_null forward]} { set next $next }
if {[exists_and_not_null rewind]} {
    set backward [expr $next - 2*$limit]
    if { $backward <= 0 } { set backward 1 }
    set next $backward
}

for {set x $next} {$x <= $total_msgs} {incr x} {

    if { $count == $limit } {
	ad_set_client_property webmail-system next $x
	break
    }

    set number $x
    set sender [ns_imap header $id $x from]

    webmail::parse_sender -sender $sender -array person

    set subject [ns_imap header $id $x subject]
    if { $subject == "" } {
	set subject "#webmail-system.No_Subject#"
    }
    set subject_link "view?number=$number"
    set date [ns_imap header $id $x date]
    set sdate [ns_imap parsedate $date]
    if {$sdate != ""} {
	# If date was parsed correctly set to locale format
	set date [ns_fmttime $sdate "%x %X"]
    } else {
	# If date was not parsed correctly
	set date [lrange [split $date " "] 0 3]
    }
    ns_imap struct $id $number -array struct
    set size [webmail::mail_format_size $struct(size)]
    if { $struct(type) == "multipart" } {
	set attachments 1
    } else {
	set attachments 0
    }

    # Determining whether the current emails is the last in the folder
    if { $number < $msg } {
	set max 0       ;#false
	set next_num [expr $number + 1]
    } else {
	set max 1       ;#true
    }

    multirow append emails $number $max $sender $person(email) $person(first_names) $person(last_name) $subject $subject_link $date $size $attachments

    incr count
}
if { [exists_and_not_null orderby] } {
    regexp {([^,]*),(.*)} $orderby match column order
    
    if { $order == "asc" } {
	template::multirow sort emails -increasing $column
    } elseif { $order == "desc" } {
	template::multirow sort emails -decreasing $column
    }
}

if { !$finished_p } {
    ad_progress_bar_end -url "retrieve?finished_p=1"
}

ns_log debug "WEBMAIL: Retrieval complete"

# --------------------------------------------------------------- #

ad_return_template

# ------------------------- END OF FILE ------------------------- #
