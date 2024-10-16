alter table spg_page
  add icon varchar(255);

INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('region/getmap/useGeodesicExtents', 'false', 2, 9591, 'n');

ALTER TABLE groups ALTER COLUMN name TYPE varchar(255);

INSERT INTO Settings (name, value, datatype, position, internal) SELECT distinct 'metadata/pdfReport/headerLogoFileName', '', 0, 12508, 'y' from settings WHERE NOT EXISTS (SELECT name FROM Settings WHERE name = 'metadata/pdfReport/headerLogoFileName');

INSERT INTO Settings (name, value, datatype, position, internal) SELECT distinct 'metadata/batchediting/accesslevel', 'Editor', 0, 12020, 'n' from settings WHERE NOT EXISTS (SELECT name FROM Settings WHERE name = 'metadata/batchediting/accesslevel');

UPDATE Settings SET value='4.4.2' WHERE name='system/platform/version';
UPDATE Settings SET value='SNAPSHOT' WHERE name='system/platform/subVersion';
