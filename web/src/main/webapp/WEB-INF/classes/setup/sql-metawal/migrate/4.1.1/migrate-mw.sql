INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/security/password/allowAdminReset', 'true', 2, 12004, 'n');

UPDATE Settings SET editable = 'n' WHERE name = 'system/userFeedback/lastNotificationDate';
UPDATE Settings SET editable = 'n' WHERE name = 'system/security/passwordEnforcement/pattern';


UPDATE Settings SET value='4.1.1' WHERE name='system/platform/version';
UPDATE Settings SET value='0' WHERE name='system/platform/subVersion';
