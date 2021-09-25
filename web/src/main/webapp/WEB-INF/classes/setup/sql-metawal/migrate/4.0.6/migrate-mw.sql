UPDATE metadata SET data = replace(data, 'WWW:DOWNLOAD-OGC:OWS-C', 'OGC:OWS-C') WHERE data LIKE '%WWW:DOWNLOAD-OGC:OWS-C%';

UPDATE Settings SET internal = 'n' WHERE name = 'system/metadata/prefergrouplogo';

INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/inspire/remotevalidation/nodeid', 'inspire', 0, 7212, 'n');

INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/inspire/remotevalidation/apikey', '', 0, 7213, 'y');

INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/harvester/disabledHarvesterTypes', '', 0, 9011, 'n');

-- https://github.com/SPW-DIG/metawal-core-geonetwork/issues/629
UPDATE Metadata SET data = replace(data,' xsi:schemaLocation="http://standards.iso.org/iso/19115/-3/mds/1.0 http://standards.iso.org/iso/19115/-3/mds/1.0/mds.xsd"', '') WHERE data LIKE '%xsi:schemaLocation="http://standards.iso.org/iso/19115/-3/mds/1.0 http://standards.iso.org/iso/19115/-3/mds/1.0/mds.xsd"%';

-- https:re//github.com/SPW-DIG/metawal-core-geonetwork/issues/642
INSERT INTO Users (id, username, password, name, surname, profile, kind, organisation, security, authtype, isenabled) VALUES  (0,'nobody','','nobody','nobody',4,'','','','', 'n');
INSERT INTO Address (id, address, city, country, state, zip) VALUES  (0, '', '', '', '', '');
INSERT INTO UserAddress (userid, addressid) VALUES  (0, 0);

-- https://github.com/SPW-DIG/metawal-core-geonetwork/issues/633
--UPDATE metadata SET data = replace(data, 'local.theme.infraSIG', 'external.theme.infraSIG') WHERE data LIKE '%local.theme.infraSIG%';

-- https://github.com/SPW-DIG/metawal-core-geonetwork/issues/651
UPDATE metadata SET data = replace(data, '>Les conditions générales d''utilisation s''appliquent mais sont restreintes par les conditions particulières de type A.<', '>Les conditions générales d''utilisation s''appliquent et sont étendues par les conditions particulières de type A.<') WHERE data LIKE '%>Les conditions générales d''utilisation s''appliquent mais sont restreintes par les conditions particulières de type A.<%';

UPDATE Settings SET value='4.0.6' WHERE name='system/platform/version';
UPDATE Settings SET value='0' WHERE name='system/platform/subVersion';
