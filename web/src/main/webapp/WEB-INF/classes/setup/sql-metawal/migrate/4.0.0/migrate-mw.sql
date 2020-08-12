UPDATE metadata
    SET data = replace(data,
                       'http://://metawal3.valid.wallonie.be',
                        'http://metawal.wallonie.be')
    WHERE data LIKE '%http://://metawal3.valid.wallonie.be%';


-- Move geoportal theme to hierarchy:

UPDATE metadata SET data = replace(data,
    '<gcx:Anchor xlink:href="http://metawal.wallonie.be/thesaurus/theme-geoportail-wallon">Thèmes du géoportail wallon, version 1.0</gcx:Anchor>',
    '<gcx:Anchor xlink:href="http://metawal.wallonie.be/thesaurus/Themes_geoportail_wallon_hierarchy">Thèmes du géoportail wallon</gcx:Anchor>')
    WHERE data LIKE '%<gcx:Anchor xlink:href="http://metawal.wallonie.be/thesaurus/theme-geoportail-wallon">Thèmes du géoportail wallon, version 1.0</gcx:Anchor>%';

UPDATE metadata SET data = replace(data,
    '<gco:CharacterString>Thèmes du géoportail wallon, version 1.0</gco:CharacterString>',
    '<gcx:Anchor xlink:href="http://metawal.wallonie.be/thesaurus/Themes_geoportail_wallon_hierarchy">Thèmes du géoportail wallon</gcx:Anchor>')
    WHERE data LIKE '%<gco:CharacterString>Thèmes du géoportail wallon, version 1.0</gco:CharacterString>%';

UPDATE metadata SET data = replace(data,
    '<gcx:Anchor xlink:href="http://localhost:8080/geonetwork/srv/api/registries/vocabularies/external.theme.Themes_geoportail_wallon">geonetwork.thesaurus.external.theme.Themes_geoportail_wallon</gcx:Anchor>',
    '<gcx:Anchor xlink:href="http://metawal.wallonie.be/geonetwork/srv/api/registries/vocabularies/external.theme.Themes_geoportail_wallon_hierarchy">geonetwork.thesaurus.external.theme.Themes_geoportail_wallon_hierarchy</gcx:Anchor>')
    WHERE data LIKE '%<gcx:Anchor xlink:href="http://localhost:8080/geonetwork/srv/api/registries/vocabularies/external.theme.Themes_geoportail_wallon">geonetwork.thesaurus.external.theme.Themes_geoportail_wallon</gcx:Anchor>%';


UPDATE metadata SET data = replace(data,
    '<gcx:Anchor xlink:href="http://metawal.wallonie.be/geonetwork/srv/api/registries/vocabularies/external.theme.Themes_geoportail_wallon">geonetwork.thesaurus.external.theme.Themes_geoportail_wallon</gcx:Anchor>',
    '<gcx:Anchor xlink:href="http://metawal.wallonie.be/geonetwork/srv/api/registries/vocabularies/external.theme.Themes_geoportail_wallon_hierarchy">geonetwork.thesaurus.external.theme.Themes_geoportail_wallon_hierarchy</gcx:Anchor>')
    WHERE data LIKE '%<gcx:Anchor xlink:href="http://metawal.wallonie.be/geonetwork/srv/api/registries/vocabularies/external.theme.Themes_geoportail_wallon">geonetwork.thesaurus.external.theme.Themes_geoportail_wallon</gcx:Anchor>%';




UPDATE metadata SET data = replace(data, '>(1010) Faune et flore<', '>Faune et flore<') WHERE data LIKE '%>(1010) Faune et flore<%';
UPDATE metadata SET data = replace(data, '>(1020) Eau<', '>Eau<') WHERE data LIKE '%>(1020) Eau<%';
UPDATE metadata SET data = replace(data, '>(1030) Sol et sous-sol<', '>Sol et sous-sol<') WHERE data LIKE '%>(1030) Sol et sous-sol<%';
UPDATE metadata SET data = replace(data, '>(1040) Air<', '>Air<') WHERE data LIKE '%>(1040) Air<%';
UPDATE metadata SET data = replace(data, '>(10) Nature et environnement<', '>Nature et environnement<') WHERE data LIKE '%>(10) Nature et environnement<%';
UPDATE metadata SET data = replace(data, '>(2010) Plans et règlements<', '>Plans et règlements<') WHERE data LIKE '%>(2010) Plans et règlements<%';
UPDATE metadata SET data = replace(data, '>(2020) Risques et contraintes<', '>Risques et contraintes<') WHERE data LIKE '%>(2020) Risques et contraintes<%';
UPDATE metadata SET data = replace(data, '>(20) Aménagement du territoire<', '>Aménagement du territoire<') WHERE data LIKE '%>(20) Aménagement du territoire<%';
UPDATE metadata SET data = replace(data, '>(3010) Routes<', '>Routes<') WHERE data LIKE '%>(3010) Routes<%';
UPDATE metadata SET data = replace(data, '>(3020) A pied et à vélo<', '>A pied et à vélo<') WHERE data LIKE '%>(3020) A pied et à vélo<%';
UPDATE metadata SET data = replace(data, '>(3030) Voies navigables<', '>Voies navigables<') WHERE data LIKE '%>(3030) Voies navigables<%';
UPDATE metadata SET data = replace(data, '>(3040) Transports en commun<', '>Transports en commun<') WHERE data LIKE '%>(3040) Transports en commun<%';
UPDATE metadata SET data = replace(data, '>(30) Mobilité<', '>Mobilité<') WHERE data LIKE '%>(30) Mobilité<%';
UPDATE metadata SET data = replace(data, '>(4010) Tourisme<', '>Tourisme<') WHERE data LIKE '%>(4010) Tourisme<%';
UPDATE metadata SET data = replace(data, '>(4020) Loisirs<', '>Loisirs<') WHERE data LIKE '%>(4020) Loisirs<%';
UPDATE metadata SET data = replace(data, '>(40) Tourisme et loisirs<', '>Tourisme et loisirs<') WHERE data LIKE '%>(40) Tourisme et loisirs<%';
UPDATE metadata SET data = replace(data, '>(5010) Données topographiques<', '>Données topographiques<') WHERE data LIKE '%>(5010) Données topographiques<%';
UPDATE metadata SET data = replace(data, '>(5020) Limites administratives<', '>Limites administratives<') WHERE data LIKE '%>(5020) Limites administratives<%';
UPDATE metadata SET data = replace(data, '>(5030) Photos et imagerie<', '>Photos et imagerie<') WHERE data LIKE '%>(5030) Photos et imagerie<%';
UPDATE metadata SET data = replace(data, '>(5040) Cartes anciennes<', '>Cartes anciennes<') WHERE data LIKE '%>(5040) Cartes anciennes<%';
UPDATE metadata SET data = replace(data, '>(50) Données de base<', '>Données de base<') WHERE data LIKE '%>(50) Données de base<%';
UPDATE metadata SET data = replace(data, '>(6010) Industrie et services<', '>Industrie et services<') WHERE data LIKE '%>(6010) Industrie et services<%';
UPDATE metadata SET data = replace(data, '>(6020) Agriculture<', '>Agriculture<') WHERE data LIKE '%>(6020) Agriculture<%';
UPDATE metadata SET data = replace(data, '>(6030) Logement et habitat<', '>Logement et habitat<') WHERE data LIKE '%>(6030) Logement et habitat<%';
UPDATE metadata SET data = replace(data, '>(6040) Bruit<', '>Bruit<') WHERE data LIKE '%>(6040) Bruit<%';
UPDATE metadata SET data = replace(data, '>(60) Société et activités<', '>Société et activités<') WHERE data LIKE '%>(60) Société et activités<%';




-- Move prioritydataset to hierarchy
-- In admin http://metawal.wallonie.be/geonetwork/srv/fre/admin.console#/classification
-- Replace PriorityDataset.fr.iso19135_v2_trf.rdf
-- By https://github.com/SPW-DIG/metawal-core-geonetwork/blob/metawal-4.0.x/web/src/main/webapp/WEB-INF/data/config/codelist/external/thesauri/theme/httpinspireeceuropaeumetadatacodelistPriorityDataset-PriorityDataset.rdf
-- imported from INSPIRE Registry + copy of english label as french
-- because the thesaurus is not translated into french for now.

UPDATE metadata SET data = replace(data,
    '<gcx:Anchor xlink:href="http://metawal.wallonie.be/geonetwork/srv/eng/thesaurus.download?ref=external.theme.PriorityDataset.fr.iso19135_v2_trf">geonetwork.thesaurus.external.theme.PriorityDataset.fr.iso19135_v2_trf</gcx:Anchor>',
    '<gcx:Anchor xlink:href="http://metawal.wallonie.be/geonetwork/srv/api/registries/vocabularies/external.theme.httpinspireeceuropaeumetadatacodelistPriorityDataset-PriorityDataset">geonetwork.thesaurus.external.theme.httpinspireeceuropaeumetadatacodelistPriorityDataset-PriorityDataset</gcx:Anchor>')
    WHERE data LIKE '%<gcx:Anchor xlink:href="http://metawal.wallonie.be/geonetwork/srv/eng/thesaurus.download?ref=external.theme.PriorityDataset.fr.iso19135_v2_trf">geonetwork.thesaurus.external.theme.PriorityDataset.fr.iso19135_v2_trf</gcx:Anchor>%';


UPDATE metadata SET data = replace(data,
                                   '<gcx:Anchor xlink:href="http://metawal.wallonie.be/geonetwork/srv/api/registries/vocabularies/external.theme.PriorityDataset.fr.iso19135_v2_trf">geonetwork.thesaurus.external.theme.PriorityDataset.fr.iso19135_v2_trf</gcx:Anchor>',
                                   '<gcx:Anchor xlink:href="http://metawal.wallonie.be/geonetwork/srv/api/registries/vocabularies/external.theme.httpinspireeceuropaeumetadatacodelistPriorityDataset-PriorityDataset">geonetwork.thesaurus.external.theme.httpinspireeceuropaeumetadatacodelistPriorityDataset-PriorityDataset</gcx:Anchor>')
WHERE data LIKE '%<gcx:Anchor xlink:href="http://metawal.wallonie.be/geonetwork/srv/api/registries/vocabularies/external.theme.PriorityDataset.fr.iso19135_v2_trf">geonetwork.thesaurus.external.theme.PriorityDataset.fr.iso19135_v2_trf</gcx:Anchor>%';




DROP TABLE metadatanotifications;
DROP TABLE metadatanotifiers;

DELETE FROM Settings WHERE name LIKE 'system/indexoptimizer%';
DELETE FROM Settings WHERE name LIKE 'system/requestedLanguage%';
DELETE FROM Settings WHERE name = 'system/inspire/enableSearchPanel';
DELETE FROM Settings WHERE name = 'system/autodetect/enable';

INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/index/indexingTimeRecordLink', 'false', 2, 9209, 'n');

UPDATE metadata
    SET data = REGEXP_REPLACE(data, '[a-z]{3}\/thesaurus\.download\?ref=', 'api/registries/vocabularies/', 'g')
    WHERE data LIKE '%thesaurus.download?ref=%';

