


UPDATE metadata
  SET data = REPLACE(
      data,
      'http://standards.iso.org/iso/19115/-3/gmd', 'http://www.isotc211.org/2005/gmd')
  WHERE data LIKE '%http://standards.iso.org/iso/19115/-3/gmd%';

UPDATE Settings SET value='3.6.1' WHERE name='system/platform/version';
UPDATE Settings SET value='SNAPSHOT' WHERE name='system/platform/subVersion';
