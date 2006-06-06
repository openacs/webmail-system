<!------------------------------------------------------------------>
<!--                      ADMIN SYSTEM RESET                      -->
<!--                                                              -->
<!-- LOCATION: packages/webmail-system/www/admin/reset-system.adp -->
<!-- AUTHOR: Ayman Mohamed                                        -->
<!--         Nima Mazloumi                                        -->
<!-- CREATION DATE: 20/10/2002                                    -->
<!------------------------------------------------------------------>

<master src="templates/master-template-admin">
<property name="title">@page_title@</property>

<if @result@ eq "">
<p>#webmail-system.You_can_reset_the_complete_webmail_system_here#</p>
<p>#webmail-system.This_is_an_extreme_action_You_should_know_what_you_are_doing#</p>
<p>#webmail-system.Do_you_really_want_to_reset_the_whole_webmail_system#
<a href="reset-system?confirm_p=t" class="button">#webmail-system.Yes#</a>
<a href="index" class="button">#webmail-system.No1#</a>
</if>
<else>
<small>@result;noquote@</small>
</else>