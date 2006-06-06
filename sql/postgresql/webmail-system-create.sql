-->
--  WEBMAIL SYSTEM CREATE SQL FILE (webmail-system-create.sql)
--  
--  Author:		Nima Mazloumi
--  Email:		mazloumi@uni-mannheim.de
--  Creation Date:	2006-03-22
--  Last Modified:	2006-03-22
--
--  Description:
--    Creates all the necessary tables and references required for the webmail system.
--
--  Sequences Created:
--    * webmail_account_seq
--    * webmail_server_seq
--    * webmail_contact_seq
--
--  Tables Created:
--    * webmail_servers
--    * webmail_user_accounts
--    * webmail_user_prefs
--    * webmail_address_book
--    * webmail_serv_types
--    * webmail_auth_types
-->

----------------------------------------------------------------------------------------------

-- Creating the sequences

CREATE SEQUENCE webmail_account_seq;

CREATE SEQUENCE webmail_server_seq;

CREATE SEQUENCE webmail_contact_seq;

----------------------------------------------------------------------------------------------

-->
--  WEBMAIL SERVERS
--
--  Short Description: Available servers for receiving and sending mail.
--
--  Full Description:
--    The set of all IMAP servers available to be used. This table includes their corresponding
--    SMTP server. These servers should be predetermined prior to launching the WebMail system
--    and set by the WebMail administrator.
-->

CREATE TABLE webmail_servers
(
  server_id int4 PRIMARY KEY,
  neat_name varchar(64) NOT NULL,
  imap_addr varchar(64) NOT NULL,
  host_addr varchar(64) NOT NULL,
  imap_port int4,
  smtp_addr varchar(256),
  server_type int4,
  auth_type int4,
  active_p char(1),
  smtp_auth_p char(1),
  smtp_port int4,
  host_append_p char(1)
);

----------------------------------------------------------------------------------------------

-->
--  WEBMAIL USER ACCOUNTS
--
--  Short Description: Details for each account.
--
--  Full Description:
--    The set of all registered accounts. This table includes information about the user
--    for that account including their email address, login name to their corresponding IMAP
--    server, some additional personal information and details of their last visit to the
--    IMAP server via WebMail.
-->

CREATE TABLE webmail_user_accounts
(
  user_id int4 NOT NULL REFERENCES users,
  default_p bool,
  account_id int4 PRIMARY KEY,
  server_id int4 REFERENCES webmail_servers,
  username varchar(20),
  email varchar(256),
  "password" varchar(20),
  active_p bool,
  CONSTRAINT webmail_user_accounts_users_fk FOREIGN KEY (user_id) REFERENCES users (user_id) ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT webmail_user_accounts_servers_fk FOREIGN KEY (server_id) REFERENCES webmail_servers (server_id) ON UPDATE NO ACTION ON DELETE NO ACTION
);

----------------------------------------------------------------------------------------------

-->
--  WEBMAIL USER PREFERENCES
--
--  Short Description: Preferences for each user.
--
--  Full Description:
--    The preferences for each user. The amount of preferences will increase over time
--    however currently the table only contains a few preferences: the number of emails per
--    page the user would like to have when viewing folders (default is 50), the signature
--    to append to outgoing mail and the folder to save draft emails to.
--
--  Notes:
--    * The 'account_id' and 'draft_folder' pair for a FOREIGN KEY reference to the
--      'webmail_folders' table. The FOREIGN KEY constrains the data of those two values
--       based on columns in the 'webmail_folders' table.
-->
CREATE TABLE webmail_user_prefs
(
  draft_folder varchar(32),
  emails_per_page int4,
  signature text,
  nav_bar char(1),
  user_id int4 NOT NULL REFERENCES users,
  style char(1),
  js_enabled char(1),
  vcard text,
  CONSTRAINT webmail_user_prefs_users_fk FOREIGN KEY (user_id) REFERENCES users (user_id) ON UPDATE NO ACTION ON DELETE NO ACTION
);

----------------------------------------------------------------------------------------------

-->
--  WEBMAIL ADDRESS BOOK
--
--  Short Description: Address books for each account.
--
--  Full Description:
--    The address book associated with each account. Each address book entry is associated with
--    an account identifier and each identifier can have more than one corresponding addresses.
-->


CREATE TABLE webmail_address_book
(
  contact_id int4 NOT NULL REFERENCES webmail_user_accounts,
  email_address varchar(64) NOT NULL,
  first_names varchar(50) NOT NULL,
  last_name varchar(50),
  nick varchar(30),
  user_id int4 NOT NULL REFERENCES users
);

----------------------------------------------------------------------------------------------

-->
-- WEBMAIL AUTHENTICATION TYPES AS DESCRIBED IN UW IMAP DOCUMENTATION
-->

CREATE TABLE webmail_auth_types
(
  "type" varchar(20),
  type_id int4 NOT NULL
);

insert into webmail_auth_types ("type", type_id) values ('/notls','1');
insert into webmail_auth_types ("type", type_id) values ('/ssl','2');
insert into webmail_auth_types ("type", type_id) values ('/validate-cert','3');
insert into webmail_auth_types ("type", type_id) values ('/novalidate-cert','4');
insert into webmail_auth_types ("type", type_id) values ('/tls','5');
insert into webmail_auth_types ("type", type_id) values ('/readonly','6');

-->
-- WEBMAIL SERVER TYPES AS DESCRIBED IN UW IMAP DOCUMENTATION
-->

CREATE TABLE webmail_serv_types
(
  "type" varchar(20),
  type_id int4 NOT NULL
);

insert into webmail_serv_types ("type", type_id) values ('/imap','1');
insert into webmail_serv_types ("type", type_id) values ('/pop3','2');
insert into webmail_serv_types ("type", type_id) values ('/nntp','3');
insert into webmail_serv_types ("type", type_id) values ('/imap2','4');
insert into webmail_serv_types ("type", type_id) values ('/imap2bis','5');
insert into webmail_serv_types ("type", type_id) values ('/imap4','6');
insert into webmail_serv_types ("type", type_id) values ('/imap4revl','7');