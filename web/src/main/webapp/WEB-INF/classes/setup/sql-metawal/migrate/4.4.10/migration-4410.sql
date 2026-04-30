
INSERT INTO Settings (name, value, datatype, position, internal) SELECT distinct 'metadata/delete/backupOptions', 'UseAPIParameter', 0, 12012, 'n' from settings WHERE NOT EXISTS (SELECT name FROM Settings WHERE name = 'metadata/delete/backupOptions');

UPDATE Settings SET value='4.4.8' WHERE name='system/platform/version';
UPDATE Settings SET value='0' WHERE name='system/platform/subVersion';

INSERT INTO Settings (name, value, datatype, position, internal) SELECT distinct 'system/publication/doi/doimailnotification', 'false', 2, 100192, 'n' from settings WHERE NOT EXISTS (SELECT name FROM Settings WHERE name = 'system/publication/doi/doimailnotification');

-- Migration to 4.4.5 only removed the old DOI settings, when the DOI server was defined.
-- Related to https://github.com/geonetwork/core-geonetwork/pull/8098
DELETE FROM Settings WHERE name LIKE 'system/publication/doi%' and name != 'system/publication/doi/doienabled';

UPDATE Settings SET value='4.4.9' WHERE name='system/platform/version';
UPDATE Settings SET value='0' WHERE name='system/platform/subVersion';

INSERT INTO Settings (name, value, datatype, position, internal) SELECT distinct 'system/metadatacreate/publishForGroupEditors', 'false', 2, 9101, 'n' from settings WHERE NOT EXISTS (SELECT name FROM Settings WHERE name = 'system/metadatacreate/publishForGroupEditors');
INSERT INTO Settings (name, value, datatype, position, internal) SELECT distinct 'system/metadatacreate/copyAttachments', 'true', 2, 9102, 'n' from settings WHERE NOT EXISTS (SELECT name FROM Settings WHERE name = 'system/metadatacreate/copyAttachments');
INSERT INTO Settings (name, value, datatype, position, internal) SELECT distinct 'system/metadatacreate/skipMetadataCreationPage', 'false', 2, 9103, 'n' from settings WHERE NOT EXISTS (SELECT name FROM Settings WHERE name = 'system/metadatacreate/skipMetadataCreationPage');

INSERT INTO Settings (name, value, datatype, position, internal) SELECT distinct 'system/metadata/edit/supportedFileMimetypes', 'image/png|image/gif|image/jpeg|text/plain|application/xml|application/pdf', 0, 9107, 'n' from settings WHERE NOT EXISTS (SELECT name FROM Settings WHERE name = 'system/metadata/edit/supportedFileMimetypes');

INSERT INTO Settings (name, value, datatype, position, internal) SELECT distinct 'metadata/zipExport/attachmentsSizeLimit', NULL, 1, 12700, 'n' from settings WHERE NOT EXISTS (SELECT name FROM Settings WHERE name = 'metadata/zipExport/attachmentsSizeLimit');

ALTER TABLE groups ADD type VARCHAR(255);
UPDATE groups SET type='RecordPrivilege' WHERE id<2 AND type IS NULL;
UPDATE groups SET type='Workspace' WHERE id>=2 AND type IS NULL;

create sequence anonymous_access_link_id_seq start with 1 increment by 1;

create table anonymousaccesslink
(
  id           integer not null
    primary key,
  hash         varchar(255),
  metadataid   integer not null,
  metadatauuid varchar(255)
    constraint uk_rx48y1s1cjn8f27iwemxsrnty
      unique
);


INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('metadata/url/sitemapDoiFirst', 'false', 2, 9166, 'y');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('metadata/url/dynamicAppLinkUrl', NULL, 0, 9167, 'y');


UPDATE Settings SET value='4.4.10' WHERE name='system/platform/version';
UPDATE Settings SET value='0' WHERE name='system/platform/subVersion';

