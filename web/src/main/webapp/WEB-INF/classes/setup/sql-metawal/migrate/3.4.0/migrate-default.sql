-- Migration toward Metawal 3.4 is made using the following approach:
-- * init an empty postgres database by starting the application
-- * migrate using SQL from Oracle to Postgres (script SQL to be provided)
-- * restart the application.
-- * Migration des URL des imagettes pour utiliser l'API https://github.com/geonetwork/core-geonetwork/blob/3.4.x/core/src/main/java/org/fao/geonet/MetadataResourceDatabaseMigration.java à exécuter depuis http://localhost:8080/geonetwork/doc/api/#!/tools/callStep

UPDATE Settings SET value='3.4.2' WHERE name='system/platform/version';
UPDATE Settings SET value='SNAPSHOT' WHERE name='system/platform/subVersion';
