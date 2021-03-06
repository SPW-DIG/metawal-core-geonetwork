DROP TABLE linkstatus;
DROP TABLE metadatalink;
DROP TABLE links;

DELETE FROM metadata WHERE schemaid = 'iso19115-3';

UPDATE languages SET isDefault = 'n' WHERE id = 'eng';
UPDATE languages SET isDefault = 'y' WHERE id = 'fre';

UPDATE statusvalues SET type = 'task' WHERE id = 100;
UPDATE statusvalues SET type = 'event' WHERE id > 49 AND id <100;

DELETE FROM metadatastatus WHERE statusid IN (SELECT id FROM statusvalues WHERE type = 'workflow')

DELETE FROM cswservercapabilitiesinfo;
DELETE FROM Settings WHERE name = 'system/csw/contactId';
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/csw/capabilityRecordUuid', '-1', 0, 1220, 'y');


UPDATE Settings SET value='3.10.0' WHERE name='system/platform/version';
UPDATE Settings SET value='SNAPSHOT' WHERE name='system/platform/subVersion';
