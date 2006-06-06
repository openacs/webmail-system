<!---------------------------------------------------------------->
<!--                          RETRIEVE                          -->
<!--                                                            -->
<!-- LOCATION: packages/webmail-system/www/retrieve.adp         -->
<!-- AUTHOR: Ayman Mohamed                                      -->
<!--         Nima Mazloumi                                      -->
<!-- CREATION DATE: 14/9/2002                                   -->
<!---------------------------------------------------------------->

<master src="templates/master-template">
<property name="title">@page_title@</property>

<if @finished_p@ >

<if @emails:rowcount gt 0>

<!-- Table displaying the top -->
<TABLE BORDER=0 WIDTH="800">
  <TR>
    <TD align="left"><small>#webmail-system.Current_Folder# <B>@folder@</B></small></TD>
    <TD align="right"><small>#webmail-system.Total_messages_recent_messages#</small></TD>
</tr>
<tr>
<tr>
<td colspan="2" align="right">
<a href="retrieve?finished_p=1&rewind=1" title="#webmail-system.Previous#"><img src="images/left.gif" border="0"></a>
<a href="retrieve?finished_p=1&forward=1" title="#webmail-system.Next#"><img src="images/right.gif" border="0"></a>
</td>
</tr>
<tr>
<td colspan="2" width="800">
<listtemplate name="emails"></listtemplate>
</td>
</tr>
</if>

<else>
<listtemplate name="emails"></listtemplate>
  #webmail-system.There_are_no_emails_within_this_folder#
</else>

</if>
