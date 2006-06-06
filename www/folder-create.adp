<!---------------------------------------------------------------->
<!--                        FOLDER CREATE                       -->
<!--                                                            -->
<!-- LOCATION: packages/webmail-system/www/folder-create.adp    -->
<!-- AUTHOR: Ayman Mohamed                                      -->
<!--         Nima Mazloumi                                      -->
<!-- CREATION DATE: 7/10/2002                                   -->
<!---------------------------------------------------------------->

<master src="templates/master-template">
<property name="title">@page_title@</property>
<property name="email">@address@</property>

<P>#webmail-system.Please_enter_the_name_of_the_new_folder_you_would_like_to_create#</P>

<formtemplate id="new_folder" style="standard-webmail"></formtemplate>