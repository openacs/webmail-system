<!---------------------------------------------------------------->
<!--                            VIEW                            -->
<!--                                                            -->
<!-- LOCATION: packages/webmail-system/www/view.adp             -->
<!-- AUTHOR: Ayman Mohamed                                      -->
<!--         Nima Mazloumi                                      -->
<!-- CREATION DATE: 1/10/2002                                   -->
<!---------------------------------------------------------------->
<if @print_p@ >
@print_version;noquote@
</if>
<else>
<master src="templates/master-template">
<property name="title">@page_title@</property>

<style type="text/css">
TD.header
{
font: 12px arial
}
TD.content
{
font: 76% arial
}
</style>

<!-- Table displaying the user's current folder -->

<TABLE width="800">
  <TR>
    <TD colspan="2" align="left"><small>#webmail-system.Current_Folder#<B>@folder@</B></small></TD>
    <TD ALIGN="right"><small>
    <if @min@ eq 0 and @max@ eq 0>
    <A HREF="view?number=@prev_num@" title="#webmail-system.Previous#"><img src="images/left.gif" border="0" width="12" height="12"></a> @number@ | @msg@<A HREF="view?number=@next_num@" title="#webmail-system.Next#"><img src="images/right.gif" border="0" width="12" height="12"></a>
    </if>
    <if @min@ eq 0 and @max@ eq 1>
    <A HREF="view?number=@prev_num@" title="#webmail-system.Previous#"><img src="images/left.gif" border="0" width="12" height="12"></a> @number@ | @msg@ |
    </if>

    <if @min@ eq 1 and @max@ eq 0>
	 | @number@ | @msg@<A HREF="view?number=@next_num@" title="#webmail-system.Next#"><img src="images/right.gif" border="0" width="12" height="12"></a>
    </if>
    </small>
    </TD>
    </tr>
    <tr>
    <TD colspan="3" ALIGN="right">
        <if @person.last_name@ ne "">
           <a href="contact?first_names=@person.first_names@&last_name=@person.last_name@&email_address=@person.email@" title="Add @person.first_names@ @person.last_name@ to contacts"><IMG SRC="images/add_contact.gif" BORDER=0></a>
        </if>
        <else>
            <a href="contact?last_name=@person.last_name@&email_address=@person.email@" title="Add @person.email@ to contacts"><IMG SRC="images/add_contact.gif" BORDER=0></a>
        </else>

      <if @header_p@ >
	  <A HREF="view?number=@number@" title="#webmail-system.Hide_Headers#"><img src="images/header_hide.gif" width="16" height="18" border="0"></A>
      </if><else>
	<A HREF="view?number=@number@&header=yes" title="#webmail-system.Display_Headers#"><img src="images/header_show.gif" width="16" height="18" border="0"></A>
      </else>

      <A HREF="view?print_p=1&number=@number@" title="#webmail-system.Print#"><img src="images/print.gif" width="16" height="16" border="0"></A>
    </TD</TR>

  <TR class="even">
    <TD align="right" class="header"><b>#webmail-system.From#</b></TD>
    <TD align="left" width="80%" colspan="2" class="header">@sender@</TD>
  </TR>

  <TR class="odd">
    <TD align="right" class="header"><b>#webmail-system.To#</b></TD>
    <TD align="left" colspan="2" class="header">@recipients@</TD>
  </TR>

  <TR class="even">
    <TD align="right" class="header"><b>#webmail-system.Subject#</b></TD>
    <TD align="left" colspan="2" class="header">@subject@</TD>
  </TR>

  <TR class="odd">
    <TD align="right" class="header"><b>#webmail-system.Date#</b></TD>
    <TD align="left" colspan="2" class="header">@date@</TD>
  </TR>
  <if @header_p@ >
  <TR class="even">
    <TD></TD>
    <TD colspan="2" class="header"><small>@header;noquote@</small></TD>
  </TR>
  </if>
  <tr class="list-button-bar">
    <td colspan="3" align="right">
        <A HREF="mail-reply?number=@number@&action=reply" title="#webmail-system.Reply#"><img src="images/reply.gif" width="19" height="19" border="0"></A>
        <A HREF="mail-reply?number=@number@&action=forward" title="#webmail-system.Forward#"><img src="images/forward.gif" width="19" height="19" border="0"></A>
	<A HREF="mail-delete?number=@number@&last=@max@" title="#webmail-system.Delete#"><img src="images/trash.gif" width="19" height="19" border="0"></A>
    </td>
  </TR>
</TABLE>
<TABLE>
  <TR>
    <TD colspan="3">@body;noquote@</TD>
  </TR>
</TABLE>

<if @attachments@>
    <listtemplate name="files"></listtemplate>
</if>
</else>