-- https://github.com/SPW-DIG/metawal-core-geonetwork/issues/663
INSERT INTO sourcesdes (iddes, label, langid)
SELECT s.value, 'Metawal', l.id
FROM settings s, languages l WHERE s.name = 'system/site/siteId';

-- https://github.com/SPW-DIG/metawal-core-geonetwork/issues/663
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/inspire/remotevalidation/apikey', '', 0, 7213, 'y');

-- https://github.com/SPW-DIG/metawal-core-geonetwork/issues/565
UPDATE metadata SET data = replace(data, 'http://metawal.wallonie.be/', 'https://metawal.wallonie.be/') WHERE data LIKE '%http://metawal.wallonie.be/%';
