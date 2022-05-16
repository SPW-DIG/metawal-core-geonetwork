INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/security/password/allowAdminReset', 'true', 2, 12004, 'n');

UPDATE Settings SET editable = 'n' WHERE name = 'system/userFeedback/lastNotificationDate';
UPDATE Settings SET editable = 'n' WHERE name = 'system/security/passwordEnforcement/pattern';

INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('metadata/csvReport/csvName', 'metadata_{datetime}.csv', 0, 12607, 'n');

INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('metadata/link/excludedUrlPattern', '', 0, 12010, 'n');

INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/metadata/thesaurusNamespace', 'https://registry.geonetwork-opensource.org/{{type}}/{{filename}}', 0, 9161, 'n');


UPDATE Settings SET value='4.1.1' WHERE name='system/platform/version';
UPDATE Settings SET value='0' WHERE name='system/platform/subVersion';
