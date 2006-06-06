-->
--  WEBMAIL SYSTEM DROP SQL FILE (webmail-system-drop.sql)
--  
--  Author:		Nima Mazloumi
--  Email:		mazloumi@uni-mannheim.de
--  Creation Date:	2006-03-22
--  Last Modified:	2006-03-22
--
--  Description:
--    Drops all the sequences, tables and references which exist in the webmail system.
--    These tables are dropped in reverse order to that of the create sql file.
--  
--  Tables Dropped:
--    * webmail_address_book
--    * webmail_user_prefs
--    * webmail_user_accounts
--    * webmail_servers
--    * webmail_serv_types
--    * webmail_auth_types
--
--  Sequences Dropped:
--    * webmail_contact_seq
--    * webmail_server_seq
--    * webmail_account_seq
-->

----------------------------------------------------------------------------------------------

-->
--  WEBMAIL ADDRESS BOOK
-->

DROP TABLE webmail_address_book;

----------------------------------------------------------------------------------------------

-->
--  WEBMAIL USER PREFERENCES
-->

DROP TABLE webmail_user_prefs;

----------------------------------------------------------------------------------------------

-->
--  WEBMAIL ACCOUNTS
-->

DROP TABLE webmail_user_accounts;

----------------------------------------------------------------------------------------------

-->
--  WEBMAIL SERVER TYPES
-->

DROP TABLE webmail_serv_types;

----------------------------------------------------------------------------------------------

-->
--  WEBMAIL AUTHENTICATION TYPES
-->

DROP TABLE webmail_auth_types;

----------------------------------------------------------------------------------------------

-->
--  WEBMAIL SERVERS
-->

DROP TABLE webmail_servers CASCADE;

----------------------------------------------------------------------------------------------

DROP SEQUENCE webmail_contact_seq;

DROP SEQUENCE webmail_server_seq;

DROP SEQUENCE webmail_account_seq;