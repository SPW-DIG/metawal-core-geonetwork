WITH ns AS (select ARRAY [ARRAY ['xlink', 'http://www.w3.org/1999/xlink'],
                       ARRAY ['mdb', 'http://standards.iso.org/iso/19115/-3/mdb/2.0'],
                       ARRAY ['cit', 'http://standards.iso.org/iso/19115/-3/cit/2.0'],
                       ARRAY ['mri', 'http://standards.iso.org/iso/19115/-3/mri/1.0'],
                       ARRAY ['mco', 'http://standards.iso.org/iso/19115/-3/mco/1.0'],
                       ARRAY ['mrd', 'http://standards.iso.org/iso/19115/-3/mrd/1.0'],
                       ARRAY ['xsi', 'http://www.w3.org/2001/XMLSchema-instance'],
                       ARRAY ['gco', 'http://standards.iso.org/iso/19115/-3/gco/1.0']] AS n)
SELECT * FROM (
                  SELECT distinct(
                                     unnest(xpath('//mdb:identificationInfo/*/mri:citation/*/cit:title/*/text()',
                                                  XMLPARSE(DOCUMENT data), n)))::text AS currentTitle,
                                 uuid                                                 as currentId,
                                 unnest(xpath('count(//mri:descriptiveKeywords/*/mri:thesaurusName/*[count(cit:date) > 1]/cit:title/*/text())',
                                              XMLPARSE(DOCUMENT data), n))::text::int      AS nbThesaurusWithMoreThanOneDate
                  FROM metadata,
                       ns
                  WHERE isharvested = 'n'
                  ORDER BY uuid) AS records
WHERE nbThesaurusWithMoreThanOneDate > 0;