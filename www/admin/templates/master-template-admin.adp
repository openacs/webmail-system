<!---------------------------------------------------------------->
<!--                         ADMIN TEMPLATE                     -->
<!--                                                            -->
<!-- webmail-system/www/template/master-admin-template.adp      -->
<!-- AUTHOR: Nima Mazloumi                                      -->
<!-- CREATION DATE: 15/08/2004                                  -->
<!---------------------------------------------------------------->

<master>
<property name="title">@page_title@</property>

<!-- Let's override listbuilder tiny style -->
<style type="text/css">
.list-tiny
{
font: 10px arial
}
</style>

<table>
<tr class="list-button-bar">
    <td class="list-button-bar">
                <A HREF="users" class="button">#webmail-system.Users#<A>
		<a HREF="servers" class="button">#webmail-system.Servers#</a>
                <A HREF="reset-system" class="button">#webmail-system.Reset_System#<A>
		<A HREF="@parameters_url@" class="button" title="#webmail-system.Set_Parameters#">#webmail-system.Set_Parameters#</A>
                <A HREF="../welcome" class="button">#webmail-system.Exit#<A>
    </td>
  </tr>
<tr>
<td>
<slave>
</td>
</tr>
</TABLE>
