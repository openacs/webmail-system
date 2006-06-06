# --------------------------------------------------------------- #
#                            ADMIN TEMPLATE                       #
#                                                                 #
# webmail-system/www/template/master-template-admin.tcl           #
#                                                                 #
# --------------------------------------------------------------- #

# ------------------------ PAGE CONTRACT ------------------------ #

ad_page_contract {

        Administration Template

        @author Nima Mazloumi (mazloumi@uni-mannheim.de)
        @creation-date 15/08/2004

    } {

    } -properties {
        page_title:onevalue
        address:onevalue
    }

# ------------------------ SET VARIABLES ------------------------ #

set page_title "\#webmail-system.Webmail_Administration\#"
set package_id [ad_conn package_id]
set parameters_url [export_vars -base "/shared/parameters" {
    package_id { return_url [ad_return_url] }
}]

# -------------------------- PROCESSING ------------------------- #

# --------------------------------------------------------------- #

ad_return_template

# ------------------------- END OF FILE ------------------------- #
