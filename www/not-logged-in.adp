<!---------------------------------------------------------------->
<!--                       NOT LOGGED IN                        -->
<!--                                                            -->
<!-- LOCATION: packages/webmail-system/www/not-logged-in.adp    -->
<!-- AUTHOR: Ayman Mohamed                                      -->
<!--         Nima Mazloumi                                      -->
<!-- CREATION DATE: 5/10/2002                                   -->
<!---------------------------------------------------------------->

<master>
<property name="title">@page_title@</property>
<property name="context_bar">@context_bar@</property>

<P><B>#webmail-system.This_page_cannot_be_accessed_without_being_logged_in#</B></P>

<P>#webmail-system.One_of_the_following_may_have_happened#</P>
<ul>
      <LI>#webmail-system.The_username_password_you_supplied_is_not_valid#</LI>
      <LI>#webmail-system.Your_current_webmail_session_has_expired#</LI>
      <LI>#webmail-system.You_are_currently_not_logged_in#</LI>
</ul>
<P>#webmail-system.Please_log_in_before_performing_this_action#</P>

<P>
<A HREF="index" class="button">#webmail-system.Login#</A>
<if @allowed_p@><A HREF="accounts" class="button">#webmail-system.Accounts#</a></if>
</P>
