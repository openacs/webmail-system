<!---------------------------------------------------------------->
<!--                             HELP                           -->
<!--                                                            -->
<!-- LOCATION: packages/webmail-system/www/help.adp             -->
<!-- AUTHOR: Ayman Mohamed                                      -->
<!--         Nima Mazloumi                                      -->
<!-- CREATION DATE: 20/10/2002                                  -->
<!---------------------------------------------------------------->

<property name="title">@page_title@</property>

<if @id@ eq "">
  <master>
</if>
<else>
  <master src="templates/master-template">
</else>


<font size="2">
<table width="800">
<tr class="even">
<td>
#webmail-system.The_following_document_is_to_be_used#
<ol>
<h3><li>#webmail-system.Login#</h3>
<ol>
#webmail-system.Login_Help_Text#
</ol>
#webmail-system.The_following_scenarios_can_only_be_performed_if-the_user_is_logged_in#
<h3><li>#webmail-system.Inbox#</h3>
<ol>
#webmail-system.Inbox_Help_Text#
</ol>
<h3><li>#webmail-system.Viewing_email#</h3>
<ol>
#webmail-system.Viewing_Email_Help_Text#
</ol>
<h3><li>#webmail-system.Composing_an_email#</h3>
<ol>
#webmail-system.Composing_Email_Help_Text#
</ol>
<h3><li>#webmail-system.Folder_Management#</h3>
<ol>
#webmail-system.Folder_Management_Help_Text#
</ol>
<h3><li>#webmail-system.Contact_Management#</h3>
<ol>
#webmail-system.Contact_Management_Help_Text#</ol>
<h3><li>#webmail-system.Logout#</h3>
#webmail-system.Logout_Help_Text#
</ol>
</TD>
</TR>
</TABLE>
</font>