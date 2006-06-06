<!---------------------------------------------------------------->
<!--                         USER MASTER TEMPLATE               -->
<!--                                                            -->
<!-- webmail-system/www/templates/master-template.adp           -->
<!-- AUTHOR: Nima Mazloumi                                      -->
<!-- CREATION DATE: 15/08/2004                                  -->
<!---------------------------------------------------------------->
<% set template [parameter::get -parameter "MasterTemplate" -default "/www/default-master"] %>
<master src="@template@">
<!-- Let's override listbuilder tiny style -->
<style type="text/css">
.list-tiny
{
font: 10px arial
}
</style>

<if @nav_bar_p@ >
<table width="800">
<tr>
    <td class="odd" align="right">
		<A HREF="retrieve" title="#webmail-system.Inbox#"><img src="images/inbox.gif" border="0" width="16" height="16"></A>
                <A HREF="compose" title="#webmail-system.Compose#"><img src="images/compose.gif" border="0" width="16" height="16"></A>
                <A HREF="folders" title="#webmail-system.Folders#"><img src="images/folders.gif" border="0" width="16" height="16"></A>
                <A HREF="contacts" title="#webmail-system.Contacts#"><img src="images/contacts.gif" border="0" width="16" height="16"></A>
                <A HREF="preferences" title="#webmail-system.Preferences#"><img src="images/prefs.gif" border="0" width="16" height="16"></A>
		<A HREF="accounts" title="#webmail-system.Accounts#"><img src="images/accounts.gif" border="0" width="16" height="16"></A>
                <A HREF="help" title="#webmail-system.Help#"><img src="images/help.gif" border="0" width="16" height="16"></A>
		<if @admin_p@ >
		    <a href="@admin_url@" title="@admin_title@"><img src="images/admin.gif" border="0" width="16" height="16"></A>
		</if>
		<A HREF="logout" title="#webmail-system.Logout#"><img src="images/logout.gif" border="0" width="16" height="16"></A>

    </td>
  </tr>
</TABLE>
</if>
<else>
<table width="800">
<tr>
    <td class="odd" align="right">
                <A HREF="retrieve" title="#webmail-system.Inbox#" class="button" accesskey="I">#webmail-system.Inbox1#</A>
                <A HREF="compose" title="#webmail-system.Compose#" class="button" accesskey="C">#webmail-system.Compose1#</A>
                <A HREF="folders" title="#webmail-system.Folders#" class="button" accesskey="F">#webmail-system.Folders1#</A>
                <A HREF="contacts" title="#webmail-system.Contacts#" class="button" accesskey="N">#webmail-system.Contacts1#</A>
                <A HREF="preferences" title="#webmail-system.Preferences#" class="button" accesskey="P">#webmail-system.Preferences1#</A>
                <A HREF="accounts" title="#webmail-system.Accounts#" class="button" accesskey="A">#webmail-system.Accounts1#</A>
                <A HREF="help" title="#webmail-system.Help#" class="button" accesskey="H">#webmail-system.Help1#</A>
                <if @admin_p@ >
                    <a href="@admin_url@" title="@admin_title@" class="button" accesskey="M">@admin_title@</A>
                </if>
                <A HREF="logout" title="#webmail-system.Logout#" class="button" accesskey="L">#webmail-system.Logout1#</A>
    </td>
  </tr>
</TABLE>
</else>


<slave>