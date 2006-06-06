<!--------------------------------------------------------------------->
<!--                      MASTER TEMPLATE START                      -->
<!--                                                                 -->
<!-- LOCATION: packages/webmail-system/www/master-template-start.adp -->
<!-- AUTHOR: Ayman Mohamed                                           -->
<!--         Nima Mazloumi                                           -->
<!-- CREATION DATE: 12/9/2002                                        -->
<!--------------------------------------------------------------------->
<master>

<table width="800">
<tr>
    <td class="odd" align="right">
                <img src="images/blank.gif" border="0" width="16" height="16">
                <A HREF="compose" title="#webmail-system.Compose#"><img src="images/compose.gif" border="0" width="16" height="16"></A>
                <img src="images/blank.gif" border="0" width="16" height="16">
                <A HREF="contacts" title="#webmail-system.Contacts#"><img src="images/contacts.gif" border="0" width="16" height="16"></A>
                <A HREF="preferences" title="#webmail-system.Preferences#"><img src="images/prefs.gif" border="0" width="16" height="16"></A>
                <A HREF="accounts" title="#webmail-system.Accounts#"><img src="images/accounts.gif" border="0" width="16" height="16"></A>
                <A HREF="help" title="#webmail-system.Help#"><img src="images/help.gif" border="0" width="16" height="16"></A>
                <if @admin_p@ not nil>
                    <a href="@admin_url@" title="@admin_title@"><img src="images/admin.gif" border="0" width="16" height="16"></A>
                </if>
                <A HREF="index" title="#webmail-system.Login#"><img src="images/login.gif" border="0" width="16" height="16"></A>

    </td>
  </tr>
</TABLE>

<slave>