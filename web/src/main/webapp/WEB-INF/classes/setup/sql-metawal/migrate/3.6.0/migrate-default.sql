

ALTER TABLE StatusValues ADD type varchar(255);
ALTER TABLE StatusValues ADD notificationLevel varchar(255);


INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/publication/doi/doienabled', 'false', 2, 191, 'n');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/publication/doi/doiurl', '', 0, 192, 'n');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/publication/doi/doiusername', '', 0, 193, 'n');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/publication/doi/doipassword', '', 0, 194, 'n');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/publication/doi/doikey', '', 0, 195, 'n');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/publication/doi/doilandingpagetemplate', 'http://localhost:8080/geonetwork/srv/resources/records/{{uuid}}', 0, 195, 'n');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/metadata/history/enabled', 'false', 2, 9171, 'n');

UPDATE StatusValues SET type = 'workflow';

UPDATE StatusValues SET notificationLevel = 'recordUserAuthor' WHERE name = 'approved';
UPDATE StatusValues SET notificationLevel = 'recordUserAuthor' WHERE name = 'retired';
UPDATE StatusValues SET notificationLevel = 'recordProfileReviewer' WHERE name = 'submitted';
UPDATE StatusValues SET notificationLevel = 'recordUserAuthor' WHERE name = 'rejected';


INSERT INTO StatusValues (id, name, reserved, displayorder, type, notificationLevel) VALUES  (100,'doiCreationTask','n', 100, 'task', 'statusUserOwner');


INSERT INTO StatusValues (id, name, reserved, displayorder, type, notificationLevel) VALUES  (50,'recordcreated','y', 50, 'event', null);
INSERT INTO StatusValues (id, name, reserved, displayorder, type, notificationLevel) VALUES  (51,'recordupdated','y', 51, 'event', null);
INSERT INTO StatusValues (id, name, reserved, displayorder, type, notificationLevel) VALUES  (52,'attachmentadded','y', 52, 'event', null);
INSERT INTO StatusValues (id, name, reserved, displayorder, type, notificationLevel) VALUES  (53,'attachmentdeleted','y', 53, 'event', null);
INSERT INTO StatusValues (id, name, reserved, displayorder, type, notificationLevel) VALUES  (54,'recordownerchange','y', 54, 'event', null);
INSERT INTO StatusValues (id, name, reserved, displayorder, type, notificationLevel) VALUES  (55,'recordgroupownerchange','y', 55, 'event', null);
INSERT INTO StatusValues (id, name, reserved, displayorder, type, notificationLevel) VALUES  (56,'recordprivilegeschange','y', 56, 'event', null);
INSERT INTO StatusValues (id, name, reserved, displayorder, type, notificationLevel) VALUES  (57,'recordcategorychange','y', 57, 'event', null);
INSERT INTO StatusValues (id, name, reserved, displayorder, type, notificationLevel) VALUES  (58,'recordvalidationtriggered','y', 58, 'event', null);
INSERT INTO StatusValues (id, name, reserved, displayorder, type, notificationLevel) VALUES  (59,'recordstatuschange','y', 59, 'event', null);
INSERT INTO StatusValues (id, name, reserved, displayorder, type, notificationLevel) VALUES  (60,'recordprocessingchange','y', 60, 'event', null);
INSERT INTO StatusValues (id, name, reserved, displayorder, type, notificationLevel) VALUES  (61,'recorddeleted','y', 61, 'event', null);
INSERT INTO StatusValues (id, name, reserved, displayorder, type, notificationLevel) VALUES  (62,'recordimported','y', 62, 'event', null);

INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('metadata/vcs/enable', 'false', 2, 9161, 'n');

UPDATE Schematron SET filename = 'schematron-rules-url-check.xsl' WHERE filename = 'schematron-rules-url-check.report_only.xsl';
UPDATE Schematron SET filename = 'schematron-rules-inspire-sds.xsl' WHERE filename = 'schematron-rules-inspire-sds.disabled.xsl';
UPDATE Schematron SET filename = 'schematron-rules-inspire-strict.xsl' WHERE filename = 'schematron-rules-inspire-strict.disabled.xsl';
UPDATE Schematron SET filename = 'schematron-rules-inspire.xsl' WHERE filename = 'schematron-rules-inspire-disabled.xsl';


UPDATE metadata
  SET data = REPLACE(
      data,
      'theme.inspire-theme', 'theme.httpinspireeceuropaeutheme-theme')
  WHERE data LIKE '%theme.inspire-theme%';


UPDATE metadata SET data = replace(data, 'Cellule SIG de la DGARNE (SPW - DGO3 - DEMNA - DCD)', 'Cellule SIG de la DGARNE (SPW - DGO3 - DEMNA - DCoD)')
  WHERE data LIKE '%Cellule SIG de la DGARNE (SPW - DGO3 - DEMNA - DCD)%';
UPDATE metadata SET data = replace(data, 'Direction des Eaux souterraines (SPW - DGO3 - DEE - DESo)', 'Direction des Eaux souterraines (SPW - DGO3 - DEE - DESO)')
  WHERE data LIKE '%Direction des Eaux souterraines (SPW - DGO3 - DEE - DESo)%';
UPDATE metadata SET data = replace(data, 'Direction des Eaux de Surface (SPW - DG03 - DEE)', 'Direction des Eaux de Surface (SPW - DGO3 - DEE)')
  WHERE data LIKE '%Direction des Eaux de Surface (SPW - DG03 - DEE)%';
UPDATE metadata SET data = replace(data, 'Direction de l''intégration des géodonnées (SPW - SG - DIG)', 'Direction de l''intégration des géodonnées (SPW - SG - DGM - DIG)')
  WHERE data LIKE '%Direction de l''intégration des géodonnées (SPW - SG - DIG)%';
UPDATE metadata SET data = replace(data, 'Direction de l''Intégration des géodonnées (SPW - SG - DGM - DIG)', 'Direction de l''intégration des géodonnées (SPW - SG - DGM - DIG)')
  WHERE data LIKE '%Direction de l''Intégration des géodonnées (SPW - SG - DGM - DIG)%';


UPDATE metadata SET data = replace(data, 'SPF Economie, P.M.E., Classes moyennes et Energie, DG Statistique - Statistics Belgium', 'SPF Economie, PME, Classes moyennes et Energie')
  WHERE data LIKE '%SPF Economie, P.M.E., Classes moyennes et Energie, DG Statistique - Statistics Belgium%';
UPDATE metadata SET data = replace(data, 'SPF Economie, PME, Classes Moyennes et Energie', 'SPF Economie, PME, Classes moyennes et Energie')
  WHERE data LIKE '%SPF Economie, PME, Classes Moyennes et Energie%';
UPDATE metadata SET data = replace(data, 'Direction générale Statistique - Statistics Belgium (SPF Economie, PME, Classes Moyennes et Energiel)', 'SPF Economie, PME, Classes moyennes et Energie')
  WHERE data LIKE '%Direction générale Statistique - Statistics Belgium (SPF Economie, PME, Classes Moyennes et Energiel)%';

UPDATE metadata SET data = replace(data, 'http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml', 'https://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml') WHERE data LIKE '%http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml%';

UPDATE metadata SET data = replace(data, '&amp;access=private', '') WHERE data LIKE '%&amp;access=private%';
UPDATE metadata SET data = replace(data, '>ArcGIS Mapping Service<', '>ESRI:REST<') WHERE data LIKE '%ArcGIS Mapping Service%';
UPDATE metadata SET data = replace(data, '>Collection de cartes statiques<', '>Série de cartes statiques<') WHERE data LIKE '%Collection de cartes statiques%';

-- Remove usage of categories
UPDATE groups SET defaultcategory_id = null;
DELETE FROM group_category;
DELETE FROM metadatacateg;
DELETE FROM categoriesdes;
DELETE FROM categories;


UPDATE Settings SET value='3.6.1' WHERE name='system/platform/version';
UPDATE Settings SET value='SNAPSHOT' WHERE name='system/platform/subVersion';
