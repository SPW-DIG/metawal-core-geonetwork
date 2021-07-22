UPDATE metadata SET data = replace(data, 'WWW:DOWNLOAD-OGC:OWS-C', 'OGC:OWS-C') WHERE data LIKE '%WWW:DOWNLOAD-OGC:OWS-C%';

UPDATE Settings SET internal = 'n' WHERE name = 'system/metadata/prefergrouplogo';

UPDATE Settings SET value='4.0.6' WHERE name='system/platform/version';
UPDATE Settings SET value='0' WHERE name='system/platform/subVersion';
