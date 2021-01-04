
UPDATE Settings SET value = 'Europe/Brussels'
    WHERE name = 'system/server/timeZone';

DROP TABLE metadatastatus;



-- https://github.com/SPW-DIG/metawal-core-geonetwork/issues/572
-- Update protocol to use same value for WWW:LINK
UPDATE metadata SET data = replace(data, 'WWW:LINK-1.0-http--link', 'WWW:LINK') WHERE data LIKE '%WWW:LINK-1.0-http--link%';


UPDATE Settings SET value='4.0.2' WHERE name='system/platform/version';
UPDATE Settings SET value='SNAPSHOT' WHERE name='system/platform/subVersion';
