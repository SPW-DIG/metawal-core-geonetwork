-- Migration toward Metawal 3.4 is made using the following approach:
-- * init an empty postgres database by starting the application
-- * migrate using SQL from Oracle to Postgres (script SQL to be provided)
-- * restart the application.

UPDATE Settings SET value='3.4.2' WHERE name='system/platform/version';
UPDATE Settings SET value='SNAPSHOT' WHERE name='system/platform/subVersion';
