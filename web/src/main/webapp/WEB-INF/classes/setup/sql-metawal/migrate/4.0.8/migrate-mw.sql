ALTER TABLE guf_userfeedbacks_guf_rating DROP COLUMN GUF_UserFeedbacks_uuid;
UPDATE Settings SET value='advanced', datatype=0, position= 2110, internal='n' WHERE name='system/localrating/enable';

UPDATE Settings SET value='4.0.8' WHERE name='system/platform/version';
UPDATE Settings SET value='0' WHERE name='system/platform/subVersion';
