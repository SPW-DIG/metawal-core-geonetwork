ALTER TABLE guf_userfeedbacks_guf_rating DROP COLUMN GUF_UserFeedbacks_uuid;
UPDATE Settings SET value='advanced', datatype=0, position= 2110, internal='n' WHERE name='system/localrating/enable';

INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/publication/doi/doipublicurl', '', 0, 100196, 'n');

INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/metadatacreate/preferredGroup', '', 1, 9105, 'n');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/metadatacreate/preferredTemplate', '', 0, 9106, 'n');

-- https://github.com/SPW-DIG/metawal-core-geonetwork/issues/619 -- from migration script version 4.0.4 !!!
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/security/passwordEnforcement/minLength', '6', 1, 12000, 'n');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/security/passwordEnforcement/maxLength', '20', 1, 12001, 'n');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/security/passwordEnforcement/usePattern', 'true', 2, 12002, 'n');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/security/passwordEnforcement/pattern', '^((?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*(_|[^\w])).*)$', 0, 12003, 'n');



UPDATE Settings SET value='4.1.0' WHERE name='system/platform/version';
UPDATE Settings SET value='0' WHERE name='system/platform/subVersion';
