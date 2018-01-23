-- Migration toward Metawal 3.4 from 2.8 is made using the following approach:
-- * init an empty postgres database by starting the application
-- * ora2pg from production database (TODO command for export)
-- * configuration
-- EXCLUDE CATEGORIES CATEGORIESDES FILES ISOLANGUAGES ISOLANGUAGESDES MAPSERVERS OPERATIONS OPERATIONSDES REGIONS REGIONSDES SELECTIONS SELECTIONSDES SPATIALINDEX USERSAVEDSELECTIONS
--
-- REPLACE_COLS GROUPS(enableallowedcategories:enablecategoriesrestriction) USERS(ENABLED:ISENABLED)
--
-- * migrate using SQL from Oracle to Postgres (TODO script SQL to be provided)
-- * migrate content from 2.8 to 3.4 (see below)
-- * restart the application.
-- * Migration des URL des imagettes pour utiliser l'API https://github.com/geonetwork/core-geonetwork/blob/3.4.x/core/src/main/java/org/fao/geonet/MetadataResourceDatabaseMigration.java à exécuter depuis http://localhost:8080/geonetwork/doc/api/#!/tools/callStep

UPDATE Settings SET value='3.4.2' WHERE name='system/platform/version';
UPDATE Settings SET value='SNAPSHOT' WHERE name='system/platform/subVersion';

-- Migrate from ISO19139 to ISO19115-3
