<!---------------------------------------------------------------->
<!--                          WELCOME                           -->
<!--                                                            -->
<!-- LOCATION: packages/webmail-system/www/welcome.adp          -->
<!-- AUTHOR: Ayman Mohamed                                      -->
<!--         Nima Mazloumi                                      -->
<!-- CREATION DATE: 27/9/2002                                   -->
<!---------------------------------------------------------------->

<master src="templates/master-template">
<property name="title">@page_title@</property>

<H1>#webmail-system.Welcome#</H1>

<if @recent_msgs@ gt 0>
  <img src="images/mailbox.gif"><BR><BR>
  <if @recent_msgs@ eq 1>
    #webmail-system.You_have_recent_msgs_new_mail_message#
  </if>
  <else>
    #webmail-system.You_have_recent_msgs_new_mail_messages#
  </else>
</if>
<else>
  <BR>#webmail-system.You_have_no_new_mail#<BR>
</else>
