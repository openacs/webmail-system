<!---------------------------------------------------------------->
<!--                         ADMIN USERS                        -->
<!--                                                            -->
<!-- LOCATION: packages/webmail-system/www/admin/users.adp      -->
<!-- AUTHOR: Ayman Mohamed                                      -->
<!--         Nima Mazloumi                                      -->
<!-- CREATION DATE: 20/10/2002                                  -->
<!---------------------------------------------------------------->

<master src="templates/master-template-admin">
<property name="title">@page_title@</property>
<property name="email">@address@</property>

<if @err@ eq 1>
  <P>#webmail-system.Error_Selected_user_could_not_be_removed_as_it_violates_referential_integrity#</P>
</if>
<listtemplate name="users"></listtemplate>
