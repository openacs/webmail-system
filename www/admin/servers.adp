<!---------------------------------------------------------------->
<!--                         ADMIN SERVERS                      -->
<!--                                                            -->
<!-- LOCATION: packages/webmail-system/www/admin/servers.adp    -->
<!-- AUTHOR: Ayman Mohamed                                      -->
<!--         Nima Mazloumi                                      -->
<!-- CREATION DATE: 20/10/2002                                  -->
<!---------------------------------------------------------------->

<master src="templates/master-template-admin">
<property name="title">@page_title@</property>
<property name="email">@address@</property>

<if @err@ eq 1>
  <P class="error-red">Error: Selected server could not be removed as it violates referential integrity</P>
</if>

<listtemplate name="servers"></listtemplate>
