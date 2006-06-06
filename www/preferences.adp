<!---------------------------------------------------------------->
<!--                         PREFERENCES                        -->
<!--                                                            -->
<!-- LOCATION: packages/webmail-system/www/preferences.adp      -->
<!-- AUTHOR: Ayman Mohamed                                      -->
<!--         Nima Mazloumi                                      -->
<!-- CREATION DATE: 11/10/2002                                  -->
<!---------------------------------------------------------------->

<master src="templates/master-template">
<property name="title">@page_title@</property>

<formtemplate id="preferences" style="standard-webmail"></formtemplate>
<if @has_card_p@>
<table border="0">
<tr class="odd"> <td align="left"><b>@card_name@</b></td><td align="right"><b>@card_type@</b></td></tr>
<tr class="even"><td colspan="2"><pre>@card_content@</pre></td></tr>
</table>
</if>
<P>To be implemented:</P>
<ul>
<li>Configuring sent folder
<li>Configuring draft folder
<li>Configuring number of lines per page
</ul>