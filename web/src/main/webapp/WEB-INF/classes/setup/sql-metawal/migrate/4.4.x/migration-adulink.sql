UPDATE metadata  SET data = replace(data, 'https://geoportail.wallonie.be/walonmap/?#ADU', 'https://geoportail.wallonie.be/walonmap/#ADU')WHERE data LIKE  '%https://geoportail.wallonie.be/walonmap/?#ADU%';

WITH ns AS (select ARRAY [ARRAY ['xlink', 'http://www.w3.org/1999/xlink'],
    ARRAY ['mdb', 'http://standards.iso.org/iso/19115/-3/mdb/2.0'],
    ARRAY ['cit', 'http://standards.iso.org/iso/19115/-3/cit/2.0'],
    ARRAY ['mri', 'http://standards.iso.org/iso/19115/-3/mri/1.0'],
    ARRAY ['mco', 'http://standards.iso.org/iso/19115/-3/mco/1.0'],
    ARRAY ['mrd', 'http://standards.iso.org/iso/19115/-3/mrd/1.0'],
    ARRAY ['xsi', 'http://www.w3.org/2001/XMLSchema-instance'],
    ARRAY ['gco', 'http://standards.iso.org/iso/19115/-3/gco/1.0']] AS n)
UPDATE metadata
SET data = REPLACE(data, aduLink, 'https://geoportail.wallonie.be/walonmap#PANIER=' || url_utf8_percent_encode(
        '[{"serviceId":"1","visible":true,"url":"' || esriRest || '","label":' || to_json(currentTitle)::text ||
        ',"type":"AGS_DYNAMIC","metadataUrl":"https://geodata.wallonie.be/doc/' || currentId || '"}]'::text))
    FROM (SELECT distinct(
                         unnest(xpath('//mdb:identificationInfo/*/mri:citation/*/cit:title/*/text()',
                                      XMLPARSE(DOCUMENT data), n)))::text AS currentTitle,
                     data                                                 as currentXml,
                     uuid                                                 as currentId,
                     unnest(xpath('//mrd:onLine/*[cit:protocol/*/text() = ''ESRI:REST'']/cit:linkage/*/text()',
                                  XMLPARSE(DOCUMENT data), n))::text      AS esriRest,
                     unnest(xpath(
                             '//mrd:onLine/*/cit:linkage/*/text()[contains(., ''https://geoportail.wallonie.be/walonmap/#ADU'')]',
                             XMLPARSE(DOCUMENT data), n))::text           AS aduLink,
                     unnest(xpath('//mdb:metadataScope/*/mdb:resourceScope/*/@codeListValue',
                                  XMLPARSE(DOCUMENT data), n))::text      AS resourceScope
      FROM metadata,
           ns
      WHERE data LIKE '%https://geoportail.wallonie.be/walonmap/#ADU%'
      ORDER BY uuid) AS records
WHERE resourceScope != 'service'
  AND metadata.uuid = records.currentId
  AND esriRest != '';
