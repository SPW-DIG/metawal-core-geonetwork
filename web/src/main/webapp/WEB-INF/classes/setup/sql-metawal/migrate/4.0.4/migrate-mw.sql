
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

-- https://github.com/SPW-DIG/metawal-core-geonetwork/issues/590
UPDATE metadata
SET data = replace(data,
                   '<gcx:Anchor xlink:href="http://localhost:8080/geonetwork/srv/api/registries/vocabularies/external.theme.httpinspireeceuropaeumetadatacodelistSpatialScope-SpatialScope">geonetwork.thesaurus.external.theme.httpinspireeceuropaeumetadatacodelistSpatialScope-SpatialScope</gcx:Anchor>',
                   '<gcx:Anchor xlink:href="http://metawal.wallonie.be/geonetwork/srv/api/registries/vocabularies/external.theme.httpinspireeceuropaeumetadatacodelistSpatialScope-SpatialScope">geonetwork.thesaurus.external.theme.httpinspireeceuropaeumetadatacodelistSpatialScope-SpatialScope</gcx:Anchor>')
WHERE data LIKE '%<gcx:Anchor xlink:href="http://localhost:8080/geonetwork/srv/api/registries/vocabularies/external.theme.httpinspireeceuropaeumetadatacodelistSpatialScope-SpatialScope">geonetwork.thesaurus.external.theme.httpinspireeceuropaeumetadatacodelistSpatialScope-SpatialScope</gcx:Anchor>%';


-- https://github.com/SPW-DIG/metawal-core-geonetwork/issues/577
UPDATE metadata
SET data = replace(data, 'Conditions d''utilisation et d''accès, version 1.0', 'Conditions d''utilisation et d''accès, version 2.0')
WHERE data LIKE '%Conditions d''utilisation et d''accès, version 1.0%';

UPDATE metadata
SET data = replace(data,
                   'http://metawal.wallonie.be/thesaurus/conditions#CGA',
                   'https://geoportail.wallonie.be/files/documents/ConditionsSPW/DataSPW-CGA.pdf')
WHERE data LIKE '%http://metawal.wallonie.be/thesaurus/conditions#CGA%';

UPDATE metadata
SET data = replace(data,
                   '>Conditions générales d’accès<',
                   '>Les conditions générales d''accès s’appliquent.<')
WHERE data LIKE '%>Conditions générales d’accès<%';

UPDATE metadata
SET data = replace(data,
                   'http://metawal.wallonie.be/thesaurus/conditions#CPA-TypeA1',
                   'https://geoportail.wallonie.be/files/documents/ConditionsSPW/DataSPW-CPA-TypeA1.pdf')
WHERE data LIKE '%http://metawal.wallonie.be/thesaurus/conditions#CPA-TypeA1%';

UPDATE metadata
SET data = replace(data,
                   '>Conditions particulières d’accès  – Type A1 <',
                   '>Les conditions générales d''accès s’appliquent mais sont restreintes ou étendues par les conditions particulières de type A1.<')
WHERE data LIKE '%Conditions particulières d’accès  – Type A1 %';

UPDATE metadata
SET data = replace(data,
                   'http://metawal.wallonie.be/thesaurus/conditions#CPA-TypeB1',
                   'https://geoportail.wallonie.be/files/documents/ConditionsSPW/DataSPW-CPA-TypeB1.pdf')
WHERE data LIKE '%http://metawal.wallonie.be/thesaurus/conditions#CPA-TypeB1%';

UPDATE metadata
SET data = replace(data,
                   '>Conditions particulières d’accès  – Type B1<',
                   '>Les conditions générales d''accès s’appliquent mais sont restreintes ou étendues par les conditions particulières de type B1.<')
WHERE data LIKE '%>Conditions particulières d’accès  – Type B1<%';

UPDATE metadata
SET data = replace(data,
                   'http://metawal.wallonie.be/thesaurus/conditions#CPA-TypeB2',
                   'https://geoportail.wallonie.be/files/documents/ConditionsSPW/DataSPW-CPA-TypeB2.pdf')
WHERE data LIKE '%http://metawal.wallonie.be/thesaurus/conditions#CPA-TypeB2%';

UPDATE metadata
SET data = replace(data,
                   '>Conditions particulières d’accès  – Type B2<',
                   '>Les conditions générales d''accès s’appliquent mais sont restreintes ou étendues par les conditions particulières de type B2.<')
WHERE data LIKE '%>Conditions particulières d’accès  – Type B2<%';

UPDATE metadata
SET data = replace(data,
                   'http://metawal.wallonie.be/thesaurus/conditions#CPA-TypeC1',
                   'https://geoportail.wallonie.be/files/documents/ConditionsSPW/DataSPW-CPA-TypeC1.pdf')
WHERE data LIKE '%http://metawal.wallonie.be/thesaurus/conditions#CPA-TypeC1%';

UPDATE metadata
SET data = replace(data,
                   '>Conditions particulières d’accès  – Type C1<',
                   '>Les conditions générales d''accès s’appliquent mais sont restreintes ou étendues par les conditions particulières de type C1.<')
WHERE data LIKE '%>Conditions particulières d’accès  – Type C1<%';

UPDATE metadata
SET data = replace(data,
                   'http://metawal.wallonie.be/thesaurus/conditions#CPA-TypeC2',
                   'https://geoportail.wallonie.be/files/documents/ConditionsSPW/DataSPW-CPA-TypeC2.pdf')
WHERE data LIKE '%http://metawal.wallonie.be/thesaurus/conditions#CPA-TypeC2%';

UPDATE metadata
SET data = replace(data,
                   '>Conditions particulières d’accès  – Type C2<',
                   '>Les conditions générales d''accès s’appliquent mais sont restreintes ou étendues par les conditions particulières de type C2.<')
WHERE data LIKE '%>Conditions particulières d’accès  – Type C2<%';

UPDATE metadata
SET data = replace(data,
                   'http://metawal.wallonie.be/thesaurus/conditions#CPA-TypeC3',
                   'https://geoportail.wallonie.be/files/documents/ConditionsSPW/DataSPW-CPA-TypeC3.pdf')
WHERE data LIKE '%http://metawal.wallonie.be/thesaurus/conditions#CPA-TypeC3%';

UPDATE metadata
SET data = replace(data,
                   '>Conditions particulières d’accès  – Type C3<',
                   '>Les conditions générales d''accès s’appliquent mais sont restreintes ou étendues par les conditions particulières de type C3.<')
WHERE data LIKE '%>Conditions particulières d’accès  – Type C3<%';

UPDATE metadata
SET data = replace(data,
                   'http://metawal.wallonie.be/thesaurus/conditions#CPA-TypeD1',
                   'https://geoportail.wallonie.be/files/documents/ConditionsSPW/DataSPW-CPA-TypeD1.pdf')
WHERE data LIKE '%http://metawal.wallonie.be/thesaurus/conditions#CPA-TypeD1%';

UPDATE metadata
SET data = replace(data,
                   '>Conditions particulières d’accès  – Type D1<',
                   '>Les conditions générales d''accès s’appliquent mais sont restreintes ou étendues par les conditions particulières de type D1.<')
WHERE data LIKE '%>Conditions particulières d’accès  – Type D1<%';

UPDATE metadata
SET data = replace(data,
                   'http://metawal.wallonie.be/thesaurus/conditions#CPA-TypeD2',
                   'https://geoportail.wallonie.be/files/documents/ConditionsSPW/DataSPW-CPA-TypeD2.pdf')
WHERE data LIKE '%http://metawal.wallonie.be/thesaurus/conditions#CPA-TypeD2%';

UPDATE metadata
SET data = replace(data,
                   '>Conditions particulières d’accès  – Type D2<',
                   '>Les conditions générales d''accès s’appliquent mais sont restreintes ou étendues par les conditions particulières de type D2.<')
WHERE data LIKE '%>Conditions particulières d’accès  – Type D2<%';

UPDATE metadata
SET data = replace(data,
                   'http://metawal.wallonie.be/thesaurus/conditions#CGU',
                   'https://geoportail.wallonie.be/files/documents/ConditionsSPW/DataSPW-CGU.pdf')
WHERE data LIKE '%http://metawal.wallonie.be/thesaurus/conditions#CGU%';

UPDATE metadata
SET data = replace(data,
                   '>Conditions générales d’utilisation <',
                   '>Les conditions générales d''utilisation s''appliquent.<')
WHERE data LIKE '%>Conditions générales d’utilisation <%';

UPDATE metadata
SET data = replace(data,
                   'http://metawal.wallonie.be/thesaurus/conditions#CPU-TypeA',
                   'https://geoportail.wallonie.be/files/documents/ConditionsSPW/DataSPW-CPU-TypeA.pdf')
WHERE data LIKE '%http://metawal.wallonie.be/thesaurus/conditions#CPU-TypeA%';

UPDATE metadata
SET data = replace(data,
                   '>Conditions particulières d’utilisation - Type A<',
                   '>Les conditions générales d''utilisation s''appliquent mais sont restreintes par les conditions particulières de type A.<')
WHERE data LIKE '%>Conditions particulières d’utilisation - Type A<%';

UPDATE metadata
SET data = replace(data,
                   'http://metawal.wallonie.be/thesaurus/conditions#CPU-TypeB',
                   'https://geoportail.wallonie.be/files/documents/ConditionsSPW/DataSPW-CPU-TypeB.pdf')
WHERE data LIKE '%http://metawal.wallonie.be/thesaurus/conditions#CPU-TypeB%';

UPDATE metadata
SET data = replace(data,
                   '>Conditions particulières d’utilisation - Type B<',
                   '>Les conditions générales d''utilisation s''appliquent mais sont restreintes par les conditions particulières de type B.<')
WHERE data LIKE '%>Conditions particulières d’utilisation - Type B<%';

UPDATE metadata
SET data = replace(data,
                   'http://metawal.wallonie.be/thesaurus/conditions#CPU-TypeC',
                   'https://geoportail.wallonie.be/files/documents/ConditionsSPW/DataSPW-CPU-TypeC.pdf')
WHERE data LIKE '%http://metawal.wallonie.be/thesaurus/conditions#CPU-TypeC%';

UPDATE metadata
SET data = replace(data,
                   '>Conditions particulières d’utilisation - Type C<',
                   '>Les conditions générales d''utilisation s''appliquent mais sont restreintes par les conditions particulières de type C.<')
WHERE data LIKE '%>Conditions particulières d’utilisation - Type C<%';


-- https://github.com/SPW-DIG/metawal-core-geonetwork/issues/619
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/security/passwordEnforcement/minLength', '6', 1, 12000, 'n');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/security/passwordEnforcement/maxLength', '20', 1, 12001, 'n');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/security/passwordEnforcement/usePattern', 'true', 2, 12002, 'n');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/security/passwordEnforcement/pattern', '^((?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*(_|[^\w])).*)$', 0, 12003, 'n');

