
UPDATE Settings SET value = 'Europe/Brussels'
    WHERE name = 'system/server/timeZone';

CREATE TABLE metadatastatus_backup AS SELECT * FROM metadatastatus;
DROP TABLE metadatastatus;



-- https://github.com/SPW-DIG/metawal-core-geonetwork/issues/572
-- Update protocol to use same value for WWW:LINK
UPDATE metadata SET data = replace(data, 'WWW:LINK-1.0-http--link', 'WWW:LINK') WHERE data LIKE '%WWW:LINK-1.0-http--link%';


UPDATE Settings SET value='4.0.2' WHERE name='system/platform/version';
UPDATE Settings SET value='SNAPSHOT' WHERE name='system/platform/subVersion';


-- For https://github.com/SPW-DIG/metawal-core-geonetwork/issues/583

UPDATE metadata SET data = replace(data, 'http://metawal.wallonie.be/geonetwork/srv/fre/csw?service=CSW&amp;request=GetRecordById&amp;version=2.0.2&amp;outputSchema=http://www.isotc211.org/2005/gmd&amp;elementSetName=full&amp;id=', 'http://metawal.wallonie.be/geonetwork/srv/api/records/') WHERE data LIKE '%http://metawal.wallonie.be/geonetwork/srv/fre/csw?service=CSW&amp;request=GetRecordById%';


UPDATE metadata SET data = replace(data, 'http://metawal.wallonie.be/geonetwork/srv/fre/csw?service=CSW&amp;request=GetRecordById&amp;version=2.0.2&amp;outputSchema=http://standards.iso.org/iso/19115/-3/gmd&amp;elementSetName=full&amp;id=', 'http://metawal.wallonie.be/geonetwork/srv/api/records/') WHERE data LIKE '%http://metawal.wallonie.be/geonetwork/srv/fre/csw?service=CSW&amp;request=GetRecordById%';


UPDATE metadata SET data = replace(data, 'http://metawal3.valid.wallonie.be/geonetwork/srv/fre/csw?service=CSW&amp;request=GetRecordById&amp;version=2.0.2&amp;outputSchema=http://www.isotc211.org/2005/gmd&amp;elementSetName=full&amp;id=', 'http://metawal.wallonie.be/geonetwork/srv/api/records/') WHERE data LIKE '%http://metawal3.valid.wallonie.be/geonetwork/srv/fre/csw?service=CSW&amp;request=GetRecordById%';

UPDATE metadata SET data = replace(data, 'http://metawal.wallonie.be/geonetwork/srv/eng/csw?service=CSW&amp;request=GetRecordById&amp;version=2.0.2&amp;outputSchema=http://www.isotc211.org/2005/gmd&amp;elementSetName=full&amp;id=', 'http://metawal.wallonie.be/geonetwork/srv/api/records/') WHERE data LIKE '%http://metawal.wallonie.be/geonetwork/srv/eng/csw?service=CSW&amp;request=GetRecordById&amp;version=2.0.2&amp;outputSchema=http://www.isotc211.org/2005/gmd&amp;elementSetName=full&amp;id=%'


--
-- WITH ns AS (
--     select ARRAY[ARRAY['xlink', 'http://www.w3.org/1999/xlink'],
--                ARRAY['mri', 'http://standards.iso.org/iso/19115/-3/mri/1.0'],
--                ARRAY['cit', 'http://standards.iso.org/iso/19115/-3/cit/2.0'],
--                ARRAY['srv', 'http://standards.iso.org/iso/19115/-3/srv/2.1'],
--                ARRAY['gcx', 'http://standards.iso.org/iso/19115/-3/gcx/1.0']] AS n
-- )
--
-- SELECT * FROM (
--                   SELECT uuid, schemaid, unnest(xpath('//srv:operatesOn/@xlink:href',
--                                                       XMLPARSE(DOCUMENT data), n))::text AS xlink
--                   FROM metadata, ns
--                   WHERE isTemplate = 'n'
--               ) AS STAT WHERE xlink LIKE '%CSW%';
-- =0



-- https://github.com/SPW-DIG/metawal-core-geonetwork/issues/580
DROP TABLE IF EXISTS metadataRecordLink;
CREATE TABLE metadataRecordLink AS (WITH ns AS (
    select ARRAY[ARRAY['xlink', 'http://www.w3.org/1999/xlink'],
               ARRAY['mri', 'http://standards.iso.org/iso/19115/-3/mri/1.0'],
               ARRAY['cit', 'http://standards.iso.org/iso/19115/-3/cit/2.0'],
               ARRAY['mdb', 'http://standards.iso.org/iso/19115/-3/mdb/2.0'],
               ARRAY['srv', 'http://standards.iso.org/iso/19115/-3/srv/2.1'],
               ARRAY['gcx', 'http://standards.iso.org/iso/19115/-3/gcx/1.0']] AS n
)
SELECT * FROM (
                                            SELECT uuid, schemaid, unnest(xpath('//mdb:metadataLinkage/*/cit:linkage/*/text()',
                                            XMLPARSE(DOCUMENT data), n))::text AS xlink
    FROM metadata, ns
    WHERE isTemplate = 'n'
    ) AS STAT);

UPDATE metadata m
  SET data =
      (SELECT replace(data, xlink, 'http://metawal.wallonie.be/geonetwork/srv/api/records/' || m.uuid) FROM metadataRecordLink l WHERE uuid = m.uuid) WHERE uuid IN (SELECT uuid FROM metadataRecordLink);

