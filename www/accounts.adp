<!---------------------------------------------------------------->
<!--                         ADMIN ACCOUNTS                     -->
<!--                                                            -->
<!-- LOCATION: packages/webmail-system/www/admin/accounts.adp   -->
<!-- AUTHOR: Nima Mazloumi                                      -->
<!-- CREATION DATE: 20/08/2004                                  -->
<!---------------------------------------------------------------->

<if @id@ eq "">
<master src="templates/master-template-start">
</if>
<else>
<master src="templates/master-template">
</else>

<property name="title">@page_title@</property>
<property name="email">@address@</property>

<if @err@ eq 1>
  <P class="error-red">Error: Selected account could not be removed as it violates referential integrity</P>
</if>

<listtemplate name="accounts"></listtemplate>
