-- Create generic SPW group
INSERT INTO groups (id, name) VALUES (10000, 'SPW');
INSERT INTO groupsdes (iddes, label, langid) VALUES (10000, 'SPW', 'eng');
INSERT INTO groupsdes (iddes, label, langid) VALUES (10000, 'SPW', 'fre');
INSERT INTO groupsdes (iddes, label, langid) VALUES (10000, 'SPW', 'ger');
INSERT INTO groupsdes (iddes, label, langid) VALUES (10000, 'SPW', 'dut');


-- Delete group labels
DELETE FROM groupsdes WHERE iddes = (SELECT id FROM groups WHERE name = 'GUEST');
DELETE FROM groupsdes WHERE iddes = (SELECT id FROM groups WHERE name = 'VilleLiege');
DELETE FROM groupsdes WHERE iddes = (SELECT id FROM groups WHERE name = 'A_Rediger');
DELETE FROM groupsdes WHERE iddes = (SELECT id FROM groups WHERE name = 'Public');
DELETE FROM groupsdes WHERE iddes = (SELECT id FROM groups WHERE name = 'PROFAM');
DELETE FROM groupsdes WHERE iddes = (SELECT id FROM groups WHERE name = 'BEP');
DELETE FROM groupsdes WHERE iddes = (SELECT id FROM groups WHERE name = 'AGDP');
DELETE FROM groupsdes WHERE iddes = (SELECT id FROM groups WHERE name = 'IMAGE');
DELETE FROM groupsdes WHERE iddes = (SELECT id FROM groups WHERE name = 'OSM');
DELETE FROM groupsdes WHERE iddes = (SELECT id FROM groups WHERE name = 'DGO3_Bruit');
DELETE FROM groupsdes WHERE iddes = (SELECT id FROM groups WHERE name = 'Harvest');
DELETE FROM groupsdes WHERE iddes = (SELECT id FROM groups WHERE name = 'Ergo_S1');
DELETE FROM groupsdes WHERE iddes = (SELECT id FROM groups WHERE name = 'IGN-NGI harvest');
DELETE FROM groupsdes WHERE iddes = (SELECT id FROM groups WHERE name = 'Requasud');
DELETE FROM groupsdes WHERE iddes = (SELECT id FROM groups WHERE name = 'CPDT');
DELETE FROM groupsdes WHERE iddes = (SELECT id FROM groups WHERE name = 'ULG');
DELETE FROM groupsdes WHERE iddes = (SELECT id FROM groups WHERE name = 'test');
DELETE FROM groupsdes WHERE iddes = (SELECT id FROM groups WHERE name = 'ADN');
DELETE FROM groupsdes WHERE iddes = (SELECT id FROM groups WHERE name = 'VilleNamur');
DELETE FROM groupsdes WHERE iddes = (SELECT id FROM groups WHERE name = 'SPGE');
DELETE FROM groupsdes WHERE iddes = (SELECT id FROM groups WHERE name = 'SRWT');
DELETE FROM groupsdes WHERE iddes = (SELECT id FROM groups WHERE name = 'IWEPS');
DELETE FROM groupsdes WHERE iddes = (SELECT id FROM groups WHERE name = 'ADT');
DELETE FROM groupsdes WHERE iddes = (SELECT id FROM groups WHERE name = 'INSPIRE_expert');
DELETE FROM groupsdes WHERE iddes = (SELECT id FROM groups WHERE name = 'UCL');
DELETE FROM groupsdes WHERE iddes = (SELECT id FROM groups WHERE name = 'ISSEP');

-- transfert record to SPW group
UPDATE metadata SET groupowner = 10000 WHERE groupowner IN (SELECT id FROM groups WHERE name IN ('GUEST', 'VilleLiege', 'A_Rediger', 'Public', 'PROFAM', 'BEP', 'AGDP', 'IMAGE', 'OSM', 'DGO3_Bruit', 'Harvest', 'Ergo_S1', 'IGN-NGI harvest', 'Requasud', 'CPDT', 'ULG', 'test', 'ADN', 'VilleNamur', 'SPGE', 'intranet', 'SRWT', 'IWEPS', 'ADT', 'INSPIRE_expert', 'UCL', 'ISSEP'));

-- Drop all privileges related to those groups
DELETE FROM  operationallowed WHERE groupid IN (SELECT id FROM groups WHERE name IN ('GUEST', 'VilleLiege', 'A_Rediger', 'Public', 'PROFAM', 'BEP', 'AGDP', 'IMAGE', 'OSM', 'DGO3_Bruit', 'Harvest', 'Ergo_S1', 'IGN-NGI harvest', 'Requasud', 'CPDT', 'ULG', 'test', 'ADN', 'VilleNamur', 'SPGE', 'intranet', 'SRWT', 'IWEPS', 'ADT', 'INSPIRE_expert', 'UCL', 'ISSEP'));

-- Detach all users from those groups
DELETE FROM  usergroups WHERE groupid IN (SELECT id FROM groups WHERE name IN ('GUEST', 'VilleLiege', 'A_Rediger', 'Public', 'PROFAM', 'BEP', 'AGDP', 'IMAGE', 'OSM', 'DGO3_Bruit', 'Harvest', 'Ergo_S1', 'IGN-NGI harvest', 'Requasud', 'CPDT', 'ULG', 'test', 'ADN', 'VilleNamur', 'SPGE', 'intranet', 'SRWT', 'IWEPS', 'ADT', 'INSPIRE_expert', 'UCL', 'ISSEP'));

-- Delete those groups
DELETE FROM groups WHERE NAME = 'GUEST';
DELETE FROM groups WHERE NAME = 'VilleLiege';
DELETE FROM groups WHERE NAME = 'A_Rediger';
DELETE FROM groups WHERE NAME = 'Public';
DELETE FROM groups WHERE NAME = 'PROFAM';
DELETE FROM groups WHERE NAME = 'BEP';
DELETE FROM groups WHERE NAME = 'AGDP';
DELETE FROM groups WHERE NAME = 'IMAGE';
DELETE FROM groups WHERE NAME = 'OSM';
DELETE FROM groups WHERE NAME = 'DGO3_Bruit';
DELETE FROM groups WHERE NAME = 'Harvest';
DELETE FROM groups WHERE NAME = 'Ergo_S1';
DELETE FROM groups WHERE NAME = 'IGN-NGI harvest';
DELETE FROM groups WHERE NAME = 'Requasud';
DELETE FROM groups WHERE NAME = 'CPDT';
DELETE FROM groups WHERE NAME = 'ULG';
DELETE FROM groups WHERE NAME = 'test';
DELETE FROM groups WHERE NAME = 'ADN';
DELETE FROM groups WHERE NAME = 'VilleNamur';
DELETE FROM groups WHERE NAME = 'SPGE';
DELETE FROM groups WHERE NAME = 'SRWT';
DELETE FROM groups WHERE NAME = 'IWEPS';
DELETE FROM groups WHERE NAME = 'ADT';
DELETE FROM groups WHERE NAME = 'INSPIRE_expert';
DELETE FROM groups WHERE NAME = 'UCL';
DELETE FROM groups WHERE NAME = 'ISSEP';

-- Merge DG01 et DG02
DELETE FROM groupsdes WHERE iddes = 8;
DELETE FROM usergroups WHERE groupid = 8;
DELETE FROM operationallowed WHERE groupid = 8;
UPDATE metadata SET groupowner = 7 WHERE groupowner = 8;
DELETE FROM groups WHERE id = 8;


-- Rename some groups
UPDATE groups SET name = 'SPW - Environnement' WHERE id = 3;
UPDATE groups SET name = 'SPW - Territoire' WHERE id = 4;
UPDATE groups SET name = 'SPW - Mobilité' WHERE id = 7;
UPDATE groups SET name = 'SPW - Action sociale' WHERE id = 9;
UPDATE groups SET name = 'SPW - Economie' WHERE id = 35;
UPDATE groups SET name = 'DIG' WHERE id = 25;
UPDATE groups SET name = 'SPW - AWAP' WHERE id = 10100;

UPDATE groups SET description = null;

UPDATE groupsdes SET label = 'SPW - Environnement' WHERE iddes = 3;
UPDATE groupsdes SET label = 'SPW - Territoire' WHERE iddes = 4;
UPDATE groupsdes SET label = 'SPW - Mobilité' WHERE iddes = 7;
UPDATE groupsdes SET label = 'SPW - Action sociale' WHERE iddes = 9;
UPDATE groupsdes SET label = 'SPW - Economie' WHERE iddes = 35;
UPDATE groupsdes SET label = 'DIG' WHERE iddes = 25;
UPDATE groupsdes SET label = 'SPW - AWAP' WHERE iddes = 10100;


-- Transfer ownership
UPDATE metadata SET owner = (SELECT id FROM users WHERE username = 'Admin_Metawal');


DELETE FROM usergroups WHERE userid NOT IN (SELECT id FROM users WHERE username IN ('Admin_Metawal', 'FMEupdate', 'SPBTIT', 'helpdeskcarto'));

DELETE FROM usersearch_group WHERE usersearch_id IN (SELECT id FROM usersearch WHERE creator_id NOT IN (SELECT id FROM users WHERE username IN ('Admin_Metawal', 'FMEupdate', 'SPBTIT', 'helpdeskcarto')));
DELETE FROM usersearchdes WHERE iddes IN (SELECT id FROM usersearch WHERE creator_id NOT IN (SELECT id FROM users WHERE username IN ('Admin_Metawal', 'FMEupdate', 'SPBTIT', 'helpdeskcarto')));
DELETE FROM usersearch WHERE creator_id NOT IN (SELECT id FROM users WHERE username IN ('Admin_Metawal', 'FMEupdate', 'SPBTIT', 'helpdeskcarto'));

DELETE FROM useraddress WHERE userid NOT IN (SELECT id FROM users WHERE username IN ('Admin_Metawal', 'FMEupdate', 'SPBTIT', 'helpdeskcarto'));

DELETE FROM email WHERE user_id NOT IN (SELECT id FROM users WHERE username IN ('Admin_Metawal', 'FMEupdate', 'SPBTIT', 'helpdeskcarto'));

DELETE FROM usersavedselections WHERE userid NOT IN (SELECT id FROM users WHERE username IN ('Admin_Metawal', 'FMEupdate', 'SPBTIT', 'helpdeskcarto'));

DELETE FROM metadatastatus WHERE userid NOT IN (SELECT id FROM users WHERE username IN ('Admin_Metawal', 'FMEupdate', 'SPBTIT', 'helpdeskcarto'));

DELETE FROM users WHERE id NOT IN (SELECT id FROM users WHERE username IN ('Admin_Metawal', 'FMEupdate', 'SPBTIT', 'helpdeskcarto'))
