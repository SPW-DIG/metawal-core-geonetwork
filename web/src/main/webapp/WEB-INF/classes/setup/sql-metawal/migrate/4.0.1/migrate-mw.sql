
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/server/timeZone', '', 0, 260, 'n');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/users/identicon', 'gravatar:mp', 0, 9110, 'n');

ALTER TABLE usersearch ALTER COLUMN url TYPE text;

UPDATE settings SET internal = 'n' WHERE name = 'system/server/port';

UPDATE metadata
    SET data = replace(data,
                       '>2019-07-02<',
                       '>2019-05-22<')
    WHERE data LIKE '%>2019-07-02<%';


UPDATE Settings SET value='4.0.1' WHERE name='system/platform/version';
UPDATE Settings SET value='SNAPSHOT' WHERE name='system/platform/subVersion';
