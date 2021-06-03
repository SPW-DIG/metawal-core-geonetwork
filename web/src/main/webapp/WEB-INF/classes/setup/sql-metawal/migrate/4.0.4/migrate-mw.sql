
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/server/timeZone', 'Europe/Brussels', 0, 260, 'n');



DELETE FROM Schematrondes WHERE iddes IN (SELECT id FROM schematron WHERE filename LIKE 'schematron-rules-inspire%');
DELETE FROM Schematroncriteria WHERE group_name || group_schematronid IN (SELECT name || schematronid FROM schematroncriteriagroup WHERE schematronid IN (SELECT id FROM schematron WHERE filename LIKE 'schematron-rules-inspire%'));
DELETE FROM Schematroncriteriagroup WHERE schematronid IN (SELECT id FROM schematron WHERE filename LIKE 'schematron-rules-inspire%');
DELETE FROM Schematron WHERE filename LIKE 'schematron-rules-inspire%';

-- https://github.com/SPW-DIG/metawal-core-geonetwork/issues/603
UPDATE Metadata SET data = replace(data, ' xsi:schemaLocation="http://standards.iso.org/iso/19115/-3/mds/1.0 http://standards.iso.org/iso/19115/-3/mds/1.0/mds.xsd"', '') WHERE data LIKE '%xsi:schemaLocation="http://standards.iso.org/iso/19115/-3/mds/1.0 http://standards.iso.org/iso/19115/-3/mds/1.0/mds.xsd"%';

-- https://github.com/SPW-DIG/metawal-core-geonetwork/issues/581
UPDATE Metadata SET data = replace(data, 'http://data.europa.eu/eli/reg/2010/1089/2014-12-31', 'http://data.europa.eu/eli/reg/2010/1089') WHERE data LIKE '%http://data.europa.eu/eli/reg/2010/1089/2014-12-31%';

-- ALTER TABLE Settings ADD COLUMN encrypted VARCHAR(1) DEFAULT 'n';
UPDATE Settings SET encrypted='y' WHERE name='system/proxy/password';
UPDATE Settings SET encrypted='y' WHERE name='system/feedback/mailServer/password';
UPDATE Settings SET encrypted='y' WHERE name='system/publication/doi/doipassword';


UPDATE Settings SET value='4.0.4' WHERE name='system/platform/version';
UPDATE Settings SET value='0' WHERE name='system/platform/subVersion';
