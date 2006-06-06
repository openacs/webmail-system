<!---------------------------------------------------------------->
<!--                         ADMIN USERS                        -->
<!--                                                            -->
<!-- LOCATION: packages/webmail-system/www/server.adp           -->
<!-- AUTHOR: Nima Mazloumi                                      -->
<!-- CREATION DATE: 20/08/2004                                  -->
<!---------------------------------------------------------------->

<master src="templates/master-template-admin">

<property name="title">@page_title@</property>
<property name="email">@address@</property>

<P>#webmail-system.Please_fill_in_the_details_for_the_IMAP_server_you_would_like_to_add#</P>
<formtemplate id="account" style="standard-webmail"></formtemplate>
