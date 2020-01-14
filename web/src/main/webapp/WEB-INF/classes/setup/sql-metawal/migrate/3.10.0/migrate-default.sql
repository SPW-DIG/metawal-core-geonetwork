DROP TABLE linkstatus;
DROP TABLE metadatalink;
DROP TABLE links;

UPDATE Settings SET value='3.10.0' WHERE name='system/platform/version';
UPDATE Settings SET value='SNAPSHOT' WHERE name='system/platform/subVersion';
