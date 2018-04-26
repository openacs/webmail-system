# --------------------------------------------------------------- #
#                            PREFERENCES                          #
#                                                                 #
# LOCATION: packages/webmail-system/www/preferences.tcl           #
#                                                                 #
# --------------------------------------------------------------- #

# ------------------------ PAGE CONTRACT ------------------------ #

ad_page_contract {
	
	Allows the user to modify their preferences.

	@author Ayman Mohamed (mo2mo@hotmail.com)
	@author Nima Mazloumi (mazloumi@uni-mannheim.de)
	@creation-date 11/10/2002

} {
    user_id:optional    	
}

# ------------------------ SET VARIABLES ------------------------ #

ns_log debug "Preferences started"

set user_id [ad_conn user_id]
set page_title "[_ webmail-system.User_Preferences]"

# ------------------------- CREATE FORM ------------------------- #

set options {}
lappend options [list "[_ webmail-system.Full_HTML]" 0]
lappend options [list "[_ webmail-system.HTML_without_CSS]" 1]
lappend options [list "[_ webmail-system.Enhanced_Text]" 2]
lappend options [list "[_ webmail-system.Plain_Text]" 3]

set opts {}
lappend opts [list "[_ webmail-system.Text]" 0]
lappend opts [list "[_ webmail-system.Icons]" 1]

set use_wysiwyg_p [parameter::get -parameter "UseWysiwygP" -default "f"]
set has_card_p 0

ad_form -html { enctype multipart/form-data } -name preferences -form {
    user_id:key
    {has_pref_p:text(hidden)}
    {old_card:text(hidden),optional}
    {signature:richtext(richtext),optional
	{label "[_ webmail-system.Signature]"}
	{html { cols 50 rows 10 wrap soft accesskey s}}
	{htmlarea_p $use_wysiwyg_p}
	{help_text {[_ webmail-system.You_can_enter_your_signature_here]}}}
    {js_enabled:text(radio),optional
        {label "[_ webmail-system.JavaScript]"}
	{html { accesskey j}}
	{help_text {[_ webmail-system.Should_we_allow_JavaScript_in_emails_sent_to_you]}}
        {options {{Yes 1} {No 0}}}}
    {style:text(select)
	{label "[_ webmail-system.Style]"}
	{html { accesskey t}}
	{help_text {[_ webmail-system.How_should_we_handle_HTML]}}
	{options $options}}
    {vcardfile:file,optional
	{html { size 30  accesskey v }}
	{label "[_ webmail-system.vCard]"}
	{help_text {[_ webmail-system.You_can_upload_a_vcard_here]}}}
    {nav_bar:text(select)
	{options $opts}
	{html { accesskey n}}
	{label "[_ webmail-system.Navigation_bar]"}}
} -edit_request {

    set htmlarea_p $use_wysiwyg_p

    if {[db_0or1row select_prefs {}]} {
	set has_pref_p 1
	if {[exists_and_not_null vcard]} {
	    set has_card_p 1
	    set old_card $vcard
	    set card_name [lindex $old_card 0]
	    set card_type [lindex $old_card 1]
	    set card_content [lindex $old_card 2]
	} else {
	    set has_card_p 0
	    set old_card ""
	}
	
	if {[exists_and_not_null signature]} {
	    set sign_content [lindex $signature 0]
	    set sign_type [lindex $signature 1]
	    set signature [template::util::richtext::create $sign_content $sign_type]
	} else {
	    set signature [template::util::richtext::create "" "text/html"]
	}
    } else {
	set has_pref_p 0
	set old_card ""
	set signature [template::util::richtext::create "" "text/html"]
    }

} -on_submit {
    if {[exists_and_not_null vcardfile]} {
	set vcard [webmail::read_file -file $vcardfile]
    } else {
	if { $has_pref_p == 1 } {
	    set vcard $old_card
	} else {
	    set vcard ""
	}
    }

    if { $has_pref_p == 0 } {
	db_dml new_preferences {}
	ns_log Notice "WRITING PREF"
    } else {
	db_dml update_preferences {}
    }
    if {$js_enabled == 1} {
	webmail::notify_user -type "warning" -message "[_ webmail-system.Are_you_sure_you_want_JavaScript_enabled]"
    }
    ad_set_client_property webmail-system nav_bar $nav_bar
    webmail::notify_user -type "info" -message "[_ webmail-system.Preferences_changed]"
} -after_submit {
    ad_returnredirect "welcome"
    ad_script_abort
}

ns_log debug "WEBMAIL: Preferences  complete"

# --------------------------------------------------------------- #

ad_return_template

# ------------------------- END OF FILE ------------------------- #
