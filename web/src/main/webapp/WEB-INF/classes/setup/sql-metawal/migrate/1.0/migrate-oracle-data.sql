REM ======================================================================
REM ===   Sql Script for Database content: Update METAWAL2012
REM ===
REM === 	
REM ======================================================================
REM === v2.6.4
UPDATE Languages SET isInspire = 'y', isDefault = 'y' where id ='en';
UPDATE Languages SET isInspire = 'y', isDefault = 'n' where id ='fr';
UPDATE Languages SET isInspire = 'y', isDefault = 'n' where id ='es';
UPDATE Languages SET isInspire = 'n', isDefault = 'n' where id ='ru';
UPDATE Languages SET isInspire = 'n', isDefault = 'n' where id ='cn';
UPDATE Languages SET isInspire = 'y', isDefault = 'n' where id ='de';
UPDATE Languages SET isInspire = 'y', isDefault = 'n' where id ='nl';
UPDATE Languages SET isInspire = 'y', isDefault = 'n' where id ='pt';

REM ======================================================================
REM === v2.6.5

ALTER INDEX METAWAL2.SYS_C0019893 REBUILD;

INSERT INTO Settings VALUES (23,20,'protocol','http');
INSERT INTO Settings VALUES (88,80,'defaultGroup', NULL);
INSERT INTO Settings VALUES (113,87,'group',NULL);
INSERT INTO Settings VALUES (178,173,'group',NULL);
INSERT INTO Settings VALUES (179,170,'defaultGroup', NULL);

REM ======================================================================
REM === v2.8.0

INSERT INTO StatusValues VALUES  (0,'unknown','y');
INSERT INTO StatusValues VALUES  (1,'draft','y');
INSERT INTO StatusValues VALUES  (2,'approved','y');
INSERT INTO StatusValues VALUES  (3,'retired','y');
INSERT INTO StatusValues VALUES  (4,'submitted','y');
INSERT INTO StatusValues VALUES  (5,'rejected','y');

REM === English
REM === ISO 3 letter code migration
INSERT INTO Languages VALUES ('eng','English', 'y', 'y');
UPDATE CategoriesDes 			 SET langid='eng' WHERE langid='en';
UPDATE IsoLanguagesDes           SET langid='eng' WHERE langid='en';
UPDATE RegionsDes                SET langid='eng' WHERE langid='en';
UPDATE GroupsDes                 SET langid='eng' WHERE langid='en';
UPDATE OperationsDes             SET langid='eng' WHERE langid='en';
UPDATE StatusValuesDes           SET langid='eng' WHERE langid='en';
UPDATE CswServerCapabilitiesInfo SET langid='eng' WHERE langid='en';
DELETE FROM Languages WHERE id='en';

REM === not mandatory for METAWAL2012
REM === INSERT INTO CategoriesDes VALUES  (11,'z3950servers','y');
REM === INSERT INTO CategoriesDes VALUES  (12,'registers','y');
REM === INSERT INTO CategoriesDes VALUES  (13,'physicalsamples','y');

REM === INSERT INTO CategoriesDes VALUES (11,'eng','Z3950 Servers');
REM === INSERT INTO CategoriesDes VALUES (12,'eng','Registers');
REM === INSERT INTO CategoriesDes VALUES (13,'eng','Physical Samples');

INSERT INTO StatusValuesDes VALUES (0,'eng','Unknown');
INSERT INTO StatusValuesDes VALUES (1,'eng','Draft');
INSERT INTO StatusValuesDes VALUES (2,'eng','Approved');
INSERT INTO StatusValuesDes VALUES (3,'eng','Retired');
INSERT INTO StatusValuesDes VALUES (4,'eng','Submitted');
INSERT INTO StatusValuesDes VALUES (5,'eng','Rejected');

REM === Français
REM === ISO 3 letter code migration
INSERT INTO Languages VALUES ('fre','Français', 'y', 'n');

UPDATE CategoriesDes             SET langid='fre' WHERE langid='fr';
UPDATE IsoLanguagesDes           SET langid='fre' WHERE langid='fr';
UPDATE RegionsDes                SET langid='fre' WHERE langid='fr';
UPDATE GroupsDes                 SET langid='fre' WHERE langid='fr';
UPDATE OperationsDes             SET langid='fre' WHERE langid='fr';
UPDATE StatusValuesDes           SET langid='fre' WHERE langid='fr';
UPDATE CswServerCapabilitiesInfo SET langid='fre' WHERE langid='fr';
DELETE FROM Languages WHERE id='fr';

REM === not mandatory for METAWAL2012
REM === INSERT INTO CategoriesDes VALUES (11,'fre','Serveurs Z3950');
REM === INSERT INTO CategoriesDes VALUES (12,'fre','Annuaires');
REM === INSERT INTO CategoriesDes VALUES (13,'fre','Echantillons physiques');

INSERT INTO StatusValuesDes VALUES (0,'fre','Inconnu');
INSERT INTO StatusValuesDes VALUES (1,'fre','Brouillon');
INSERT INTO StatusValuesDes VALUES (2,'fre','Validé');
INSERT INTO StatusValuesDes VALUES (3,'fre','Retiré');
INSERT INTO StatusValuesDes VALUES (4,'fre','A valider');
INSERT INTO StatusValuesDes VALUES (5,'fre','Rejeté');

REM === Nederlands
REM === ISO 3 letter code migration
INSERT INTO Languages VALUES ('dut','Nederlands', 'y', 'n');

UPDATE CategoriesDes             SET langid='dut' WHERE langid='nl';
UPDATE IsoLanguagesDes           SET langid='dut' WHERE langid='nl';
UPDATE RegionsDes                SET langid='dut' WHERE langid='nl';
UPDATE GroupsDes                 SET langid='dut' WHERE langid='nl';
UPDATE OperationsDes             SET langid='dut' WHERE langid='nl';
UPDATE StatusValuesDes           SET langid='dut' WHERE langid='nl';
UPDATE CswServerCapabilitiesInfo SET langid='dut' WHERE langid='nl';
DELETE FROM Languages WHERE id='nl';

REM === not mandatory for METAWAL2012
REM === INSERT INTO CategoriesDes VALUES (11,'dut','Z3950 Servers');
REM === INSERT INTO CategoriesDes VALUES (12,'dut','Registers');
REM === INSERT INTO CategoriesDes VALUES (13,'dut','Physical Samples');

INSERT INTO StatusValuesDes VALUES (0,'dut','Unknown');
INSERT INTO StatusValuesDes VALUES (1,'dut','Draft');
INSERT INTO StatusValuesDes VALUES (2,'dut','Approved');
INSERT INTO StatusValuesDes VALUES (3,'dut','Retired');
INSERT INTO StatusValuesDes VALUES (4,'dut','Submitted');
INSERT INTO StatusValuesDes VALUES (5,'dut','Rejected');

REM === Deutsch
REM === ISO 3 letter code migration
INSERT INTO Languages VALUES ('ger','Deutsch', 'y', 'n');

UPDATE CategoriesDes             SET langid='ger' WHERE langid='de';
UPDATE IsoLanguagesDes           SET langid='ger' WHERE langid='de';
UPDATE RegionsDes                SET langid='ger' WHERE langid='de';
UPDATE GroupsDes                 SET langid='ger' WHERE langid='de';
UPDATE OperationsDes             SET langid='ger' WHERE langid='de';
UPDATE StatusValuesDes           SET langid='ger' WHERE langid='de';
UPDATE CswServerCapabilitiesInfo SET langid='ger' WHERE langid='de';
DELETE FROM Languages WHERE id='de';

REM === not mandatory for METAWAL2012
REM === INSERT INTO CategoriesDes VALUES (11,'ger','Z3950 Servers');
REM === INSERT INTO CategoriesDes VALUES (12,'ger','Registers');
REM === INSERT INTO CategoriesDes VALUES (13,'ger','Physischen Proben');

INSERT INTO StatusValuesDes VALUES (0,'ger','Unknown');
INSERT INTO StatusValuesDes VALUES (1,'ger','Draft');
INSERT INTO StatusValuesDes VALUES (2,'ger','Approved');
INSERT INTO StatusValuesDes VALUES (3,'ger','Retired');
INSERT INTO StatusValuesDes VALUES (4,'ger','Submitted');
INSERT INTO StatusValuesDes VALUES (5,'ger','Rejected');

REM ======================================================================
REM === v2.9.0

-- Spring security
UPDATE Users SET security='update_hash_required';

-- Delete LDAP settings
DELETE FROM Settings WHERE parentid=86;
DELETE FROM Settings WHERE parentid=87;
DELETE FROM Settings WHERE parentid=89;
DELETE FROM Settings WHERE parentid=80;
DELETE FROM Settings WHERE id=80;

-- New settings 

INSERT INTO Settings VALUES (920,1,'threadedindexing',NULL);
INSERT INTO Settings VALUES (921,920,'maxthreads','1');

INSERT INTO Settings VALUES (950,1,'autodetect',NULL);
INSERT INTO Settings VALUES (951,950,'enable','false');

INSERT INTO Settings VALUES (952,1,'requestedLanguage',NULL);
INSERT INTO Settings VALUES (953,952,'only','prefer_locale');
INSERT INTO Settings VALUES (954,952,'sorted','false');

INSERT INTO Settings VALUES (24,20,'securePort','8443');
INSERT INTO Settings VALUES (23,20,'protocol','http');


INSERT INTO Settings VALUES (917,1,'metadataprivs',NULL);
INSERT INTO Settings VALUES (918,917,'usergrouponly','false');

INSERT INTO Settings VALUES (722,720,'enableSearchPanel','false');

INSERT INTO Settings VALUES (900,1,'harvester',NULL);
INSERT INTO Settings VALUES (901,900,'enableEditing','false');

INSERT INTO Settings VALUES (910,1,'metadata',NULL);
INSERT INTO Settings VALUES (911,910,'enableSimpleView','true');
INSERT INTO Settings VALUES (912,910,'enableIsoView','true');
INSERT INTO Settings VALUES (913,910,'enableInspireView','false');
INSERT INTO Settings VALUES (914,910,'enableXmlView','true');
INSERT INTO Settings VALUES (915,910,'defaultView','simple');

INSERT INTO Settings VALUES (250,1,'searchStats',NULL);
INSERT INTO Settings VALUES (251,250,'enable','false');

INSERT INTO Settings VALUES (178,173,'group',NULL);
INSERT INTO Settings VALUES (179,170,'defaultGroup', NULL);

INSERT INTO Settings VALUES (956,1,'hidewithheldelements',NULL);
INSERT INTO Settings VALUES (957,956,'enable','false');
INSERT INTO Settings VALUES (958,956,'keepMarkedElement','true');
INSERT INTO Settings VALUES (955,952,'ignored','true');

-- Update schema URI
UPDATE metadata SET data = replace(data, 
'http://157.164.189.177/geonetwork/xml/schemas/iso19139.rw',
'http://metawal.wallonie.be/schemas/3.0'
) WHERE data LIKE '%http://157.164.189.177/geonetwork/xml/schemas/iso19139.rw%';


-- Version update
UPDATE Settings SET value='2.11.0' WHERE name='version';
UPDATE Settings SET value='0' WHERE name='subVersion';
UPDATE Settings SET value='2c0a95c0-9536-11e2-9e96-0800200c9a66' WHERE name='siteId';
UPDATE metadata SET source='2c0a95c0-9536-11e2-9e96-0800200c9a66' WHERE source='dummy';
