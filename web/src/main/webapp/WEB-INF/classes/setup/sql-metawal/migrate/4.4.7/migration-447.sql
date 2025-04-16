
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/translation/provider', '', 0, 7301, 'n');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/translation/serviceUrl', '', 0, 7302, 'n');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/translation/apiKey', '', 0, 7303, 'y');

INSERT INTO Settings (name, value, datatype, position, internal) SELECT distinct 'system/feedback/languages', '', 0, 646, 'n' from settings WHERE NOT EXISTS (SELECT name FROM Settings WHERE name = 'system/feedback/languages');
INSERT INTO Settings (name, value, datatype, position, internal) SELECT distinct 'system/feedback/translationFollowsText', '', 0, 647, 'n' from settings WHERE NOT EXISTS (SELECT name FROM Settings WHERE name = 'system/feedback/translationFollowsText');

UPDATE Settings SET value='4.4.5' WHERE name='system/platform/version';
UPDATE Settings SET value='0' WHERE name='system/platform/subVersion';


INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/userSelfRegistration/domainsAllowed', '', 0, 1911, 'y');
UPDATE Settings SET value='4.4.6' WHERE name='system/platform/version';
UPDATE Settings SET value='0' WHERE name='system/platform/subVersion';

INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/banner/enable', 'false', 2, 1920, 'n');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/auditable/enable', 'false', 2, 12010, 'n');

ALTER TABLE Sources ADD COLUMN datahubEnabled BOOLEAN DEFAULT FALSE;
ALTER TABLE Sources ADD COLUMN datahubConfiguration TEXT DEFAULT '';

create table doiservers
(
  id                  integer      not null
    primary key,
  description         varchar(255),
  landingpagetemplate varchar(255) not null,
  name                varchar(32)  not null,
  password            varchar(128),
  pattern             varchar(255) not null,
  prefix              varchar(15)  not null,
  publicurl           varchar(255) not null,
  url                 varchar(255) not null,
  username            varchar(128)
);

create sequence doiserver_id_seq
  start with 100;

create table doiservers_group
(
  doiserver_id integer not null
    constraint fk68kkdbdvxs6np07y6p3gfff5b
      references doiservers,
  group_id     integer not null
    constraint fkk9nywysss6bm8hgccdqoqqyti
      references groups,
  primary key (doiserver_id, group_id)
);

ALTER TABLE groups ADD COLUMN minimumprofileforprivileges varchar(255);

create table revinfo
(
  rev      integer not null
    primary key,
  revtstmp bigint
);

create table userauditable
(
  id                   integer not null
    primary key,
  createdby            varchar(255),
  createddate          timestamp,
  lastmodifiedby       varchar(255),
  lastmodifieddate     timestamp,
  address              varchar(255),
  city                 varchar(255),
  country              varchar(255),
  emailaddress         varchar(255),
  enabled              boolean not null,
  groupseditor         varchar(255),
  groupsregistereduser varchar(255),
  groupsreviewer       varchar(255),
  groupsuseradmin      varchar(255),
  kind                 varchar(255),
  name                 varchar(255),
  organisation         varchar(255),
  profile              varchar(255),
  state                varchar(255),
  surname              varchar(255),
  username             varchar(255),
  zip                  varchar(255)
);

create table userauditable_aud
(
  id                       integer not null,
  rev                      integer not null
    constraint fko4k6fftaj6wriots1r1tnihlp
      references revinfo,
  revtype                  smallint,
  createdby                varchar(255),
  createddate              timestamp,
  lastmodifiedby           varchar(255),
  lastmodifieddate         timestamp,
  address                  varchar(255),
  address_mod              boolean,
  city                     varchar(255),
  city_mod                 boolean,
  country                  varchar(255),
  country_mod              boolean,
  emailaddress             varchar(255),
  emailaddress_mod         boolean,
  enabled                  boolean,
  enabled_mod              boolean,
  groupseditor             varchar(255),
  groupseditor_mod         boolean,
  groupsregistereduser     varchar(255),
  groupsregistereduser_mod boolean,
  groupsreviewer           varchar(255),
  groupsreviewer_mod       boolean,
  groupsuseradmin          varchar(255),
  groupsuseradmin_mod      boolean,
  kind                     varchar(255),
  kind_mod                 boolean,
  name                     varchar(255),
  name_mod                 boolean,
  organisation             varchar(255),
  organisation_mod         boolean,
  profile                  varchar(255),
  profile_mod              boolean,
  state                    varchar(255),
  state_mod                boolean,
  surname                  varchar(255),
  surname_mod              boolean,
  username                 varchar(255),
  username_mod             boolean,
  zip                      varchar(255),
  zip_mod                  boolean,
  primary key (id, rev)
);

create table spg_page_group
(
  language varchar(255) not null,
  linktext varchar(255) not null,
  groupid  integer      not null
    constraint fkb1kxiuynecb84x003nwsrbifs
      references groups,
  primary key (language, linktext, groupid),
  constraint fk9mlx8ch2q2f67w745pjx5ggvg
    foreign key (language, linktext) references spg_page
);


UPDATE Settings SET value='4.4.7' WHERE name='system/platform/version';
UPDATE Settings SET value='0' WHERE name='system/platform/subVersion';

