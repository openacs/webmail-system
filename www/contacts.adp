<!---------------------------------------------------------------->
<!--                          CONTACTS                          -->
<!--                                                            -->
<!-- LOCATION: packages/webmail-system/www/contacts.adp         -->
<!-- AUTHOR: Ayman Mohamed                                      -->
<!--         Nima Mazloumi                                      -->
<!-- CREATION DATE: 11/10/2002                                  -->
<!---------------------------------------------------------------->

<master src="templates/master-template">
<property name="title">@page_title@</property>

<if @err@ eq 1>
  <P class="error-red">Error: Selected contacts could not be removed as it
  violates referential integrity</P>
</if>

<listtemplate name="contacts"></listtemplate>
