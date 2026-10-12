
ALTER TABLE spg_page ADD COLUMN IF NOT EXISTS showOnNonApproved boolean DEFAULT true NOT NULL;
ALTER TABLE spg_page ADD COLUMN IF NOT EXISTS showOnApproved boolean DEFAULT true NOT NULL;
ALTER TABLE spg_page ADD COLUMN IF NOT EXISTS showWhenWorkflowDisabled boolean DEFAULT true NOT NULL;


INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('metadata/publication/enableScheduledPublication', 'false', 2, 12023, 'n');

INSERT INTO StatusValues (id, name, reserved, displayorder, type, notificationLevel) VALUES  (101,'scheduledPublicationTask','n', 101, 'task', 'statusUserOwner');
INSERT INTO StatusValuesDes  (iddes, langid, label) VALUES (101,'ara','Scheduled publication');
INSERT INTO StatusValuesDes  (iddes, langid, label) VALUES (101,'arm','Scheduled publication');
INSERT INTO StatusValuesDes  (iddes, langid, label) VALUES (101,'aze','Scheduled publication');
INSERT INTO StatusValuesDes  (iddes, langid, label) VALUES (101,'cat','Scheduled publication');
INSERT INTO StatusValuesDes  (iddes, langid, label) VALUES (101,'chi','Scheduled publication');
INSERT INTO StatusValuesDes  (iddes, langid, label) VALUES (101,'dan','Scheduled publication');
INSERT INTO StatusValuesDes  (iddes, langid, label) VALUES (101,'dut','Scheduled publication');
INSERT INTO StatusValuesDes  (iddes, langid, label) VALUES (101,'eng','Scheduled publication');
INSERT INTO StatusValuesDes  (iddes, langid, label) VALUES (101,'fin','Scheduled publication');
INSERT INTO StatusValuesDes  (iddes, langid, label) VALUES (101,'fre','Publication programmée');
INSERT INTO StatusValuesDes  (iddes, langid, label) VALUES (101,'geo','Scheduled publication');
INSERT INTO StatusValuesDes  (iddes, langid, label) VALUES (101,'ger','Scheduled publication');
INSERT INTO StatusValuesDes  (iddes, langid, label) VALUES (101,'ita','Scheduled publication');
INSERT INTO StatusValuesDes  (iddes, langid, label) VALUES (101,'nor','Scheduled publication');
INSERT INTO StatusValuesDes  (iddes, langid, label) VALUES (101,'pol','Scheduled publication');
INSERT INTO StatusValuesDes  (iddes, langid, label) VALUES (101,'por','Scheduled publication');
INSERT INTO StatusValuesDes  (iddes, langid, label) VALUES (101,'rum','Scheduled publication');
INSERT INTO StatusValuesDes  (iddes, langid, label) VALUES (101,'rus','Scheduled publication');
INSERT INTO StatusValuesDes  (iddes, langid, label) VALUES (101,'slo','Scheduled publication');
INSERT INTO StatusValuesDes  (iddes, langid, label) VALUES (101,'spa','Scheduled publication');
INSERT INTO StatusValuesDes  (iddes, langid, label) VALUES (101,'swe','Scheduled publication');
INSERT INTO StatusValuesDes  (iddes, langid, label) VALUES (101,'tur','Scheduled publication');
INSERT INTO StatusValuesDes  (iddes, langid, label) VALUES (101,'ukr','Scheduled publication');
INSERT INTO StatusValuesDes  (iddes, langid, label) VALUES (101,'vie','Scheduled publication');
INSERT INTO StatusValuesDes  (iddes, langid, label) VALUES (101,'wel','Scheduled publication');

alter table public.validation
alter column valtype type varchar(128) using valtype::varchar(128);


-- make sure the xpaths can be longer than currently supported
alter table public.schematroncriteria
alter
column uivalue type varchar using uivalue::varchar;
alter table public.schematroncriteria
alter
column value type varchar using value::varchar;

-- define input to be used below
create temporary table _schematron on commit drop
as (
    select *
        from (values ('dcat-ap-vl-200',
                      'schematron-rules-dcat-ap-vl-200-cardinalities.xsl',
                      'dcat-ap',
                      'REQUIRED'),
                     ('dcat-ap-vl-200',
                      'schematron-rules-dcat-ap-vl-200-rec.xsl',
                      'dcat-ap',
                      'REPORT_ONLY'),
                     ('dcat-ap-vl-200',
                      'schematron-rules-dcat-ap-vl-200.xsl',
                      'dcat-ap',
                      'REQUIRED'),
                     ('dcat-ap-vl-300',
                      'schematron-rules-dcat-ap-vl-300-cardinalities.xsl',
                      'dcat-ap',
                      'REQUIRED'),
                     ('dcat-ap-vl-300',
                      'schematron-rules-dcat-ap-vl-300-rec.xsl',
                      'dcat-ap',
                      'REPORT_ONLY'),
                     ('dcat-ap-vl-300',
                      'schematron-rules-dcat-ap-vl-300.xsl',
                      'dcat-ap',
                      'REQUIRED'),
                     ('dcat-ap-200',
                      'schematron-rules-dcat-ap-200-cardinalities.xsl',
                      'dcat-ap',
                      'REQUIRED'),
                     ('dcat-ap-200',
                      'schematron-rules-dcat-ap-200.xsl',
                      'dcat-ap',
                      'REQUIRED'),
                     ('dcat-ap-200',
                      'schematron-rules-dcat-ap-200-rec.xsl',
                      'dcat-ap',
                      'REPORT_ONLY'),
                     ('dcat-ap-300',
                      'schematron-rules-dcat-ap-300-cardinalities.xsl',
                      'dcat-ap',
                      'REQUIRED'),
                     ('dcat-ap-300',
                      'schematron-rules-dcat-ap-300.xsl',
                      'dcat-ap',
                      'REQUIRED'),
                     ('dcat-ap-300',
                      'schematron-rules-dcat-ap-300-rec.xsl',
                      'dcat-ap',
                      'REPORT_ONLY'),
                     ('dcat-ap-mobility',
                      'schematron-rules-dcat-ap-mobility-cardinalities.xsl',
                      'dcat-ap',
                      'REQUIRED'),
                     ('dcat-ap-mobility',
                      'schematron-rules-dcat-ap-mobility.xsl',
                      'dcat-ap',
                      'REQUIRED'),
                     ('dcat-ap-mobility',
                      'schematron-rules-dcat-ap-mobility-rec.xsl',
                      'dcat-ap',
                      'REPORT_ONLY'),
                     ('dcat-ap-hvd',
                      'schematron-rules-dcat-ap-hvd-cardinalities.xsl',
                      'dcat-ap',
                      'REQUIRED'),
                     ('dcat-ap-hvd',
                      'schematron-rules-dcat-ap-hvd.xsl',
                      'dcat-ap',
                      'REQUIRED'),
                     ('dcat-ap-hvd',
                      'schematron-rules-dcat-ap-hvd-rec.xsl',
                      'dcat-ap',
                      'REPORT_ONLY'),
                     ('mdcat-200',
                      'schematron-rules-mdcat-200-cardinalities.xsl',
                      'dcat-ap',
                      'REQUIRED'),
                     ('mdcat-200',
                      'schematron-rules-mdcat-200.xsl',
                      'dcat-ap',
                      'REQUIRED'),
                     ('mdcat-200',
                      'schematron-rules-mdcat-200-rec.xsl',
                      'dcat-ap',
                      'REPORT_ONLY'),
                     ('health-nonpublic-300',
                      'schematron-rules-healthdcat-ap-300-non-public-cardinalities.xsl',
                      'dcat-ap',
                      'REQUIRED'),
                     ('health-nonpublic-300',
                      'schematron-rules-healthdcat-ap-300-non-public.xsl',
                      'dcat-ap',
                      'REQUIRED'),
                     ('health-nonpublic-300',
                      'schematron-rules-healthdcat-ap-300-non-public-rec.xsl',
                      'dcat-ap',
                      'REPORT_ONLY'),
                     ('health-public-300',
                      'schematron-rules-healthdcat-ap-300-public-cardinalities.xsl',
                      'dcat-ap',
                      'REQUIRED'),
                     ('health-public-300',
                      'schematron-rules-healthdcat-ap-300-public.xsl',
                      'dcat-ap',
                      'REQUIRED'),
                     ('health-public-300',
                      'schematron-rules-healthdcat-ap-300-public-rec.xsl',
                      'dcat-ap',
                      'REPORT_ONLY'),
                     ('health-restricted-300',
                      'schematron-rules-healthdcat-ap-300-restricted-cardinalities.xsl',
                      'dcat-ap',
                      'REQUIRED'),
                     ('health-restricted-300',
                      'schematron-rules-healthdcat-ap-300-restricted.xsl',
                      'dcat-ap',
                      'REQUIRED'),
                     ('health-restricted-300',
                      'schematron-rules-healthdcat-ap-300-restricted-rec.xsl',
                      'dcat-ap',
                      'REPORT_ONLY'))
               as t (xpathtarget, filename, schemaname, requirement));

create temporary table _xpaths on commit drop
as (
    select *
        from (values ('dcat-ap-vl-200',
                      '//dcat:CatalogRecord/dct:conformsTo/dct:Standard[@rdf:about=''https://data.vlaanderen.be/doc/applicatieprofiel/DCAT-AP-VL/erkendestandaard/2022-04-21'']'),
                     ('dcat-ap-vl-300',
                      '//dcat:CatalogRecord/dct:conformsTo/dct:Standard[@rdf:about=''https://data.vlaanderen.be/doc/applicatieprofiel/DCAT-AP-VL/erkendestandaard/2026-02-12'']'),
                     ('dcat-ap-200',
                      '//dcat:CatalogRecord/dct:conformsTo/dct:Standard[@rdf:about=''https://joinup.ec.europa.eu/collection/semic-support-centre/solution/dcat-application-profile-data-portals-europe/release/200'' or @rdf:about=''https://data.vlaanderen.be/doc/applicatieprofiel/DCAT-AP-VL/erkendestandaard/2022-04-21'']'),
                     ('dcat-ap-300',
                      '//dcat:CatalogRecord/dct:conformsTo/dct:Standard[@rdf:about=''https://interoperable-europe.ec.europa.eu/collection/semic-support-centre/solution/dcat-application-profile-data-portals-europe/release/300'' or @rdf:about=''https://data.vlaanderen.be/doc/applicatieprofiel/DCAT-AP-VL/erkendestandaard/2026-02-12'']'),
                     ('dcat-ap-mobility',
                      '//dcat:CatalogRecord/dct:conformsTo/dct:Standard[@rdf:about=''https://w3id.org/mobilitydcat-ap/releases/1.1.0/'']'),
                     ('dcat-ap-hvd',
                      '//dcatap:applicableLegislation[@rdf:resource=''http://data.europa.eu/eli/reg_impl/2023/138/oj'']'),
                     ('mdcat-200',
                      '//dcat:CatalogRecord/dct:conformsTo/dct:Standard[@rdf:about=''https://data.vlaanderen.be/doc/applicatieprofiel/DCAT-AP-VL/erkendestandaard/2022-04-21'' or @rdf:about=''https://data.vlaanderen.be/doc/applicatieprofiel/metadata-dcat/erkendestandaard/2022-04-21'']'),
                     ('health-restricted-300',
                      '//dcat:Catalog[dcat:record/*/dct:conformsTo/*/@rdf:about = ''https://healthdataeu.pages.code.europa.eu/healthdcat-ap/releases/release-7/'' and dcat:dataset/*/dct:accessRights/*/@rdf:about = ''http://publications.europa.eu/resource/authority/access-right/RESTRICTED'']'),
                     ('health-public-300',
                      '//dcat:Catalog[dcat:record/*/dct:conformsTo/*/@rdf:about = ''https://healthdataeu.pages.code.europa.eu/healthdcat-ap/releases/release-7/'' and dcat:dataset/*/dct:accessRights/*/@rdf:about = ''http://publications.europa.eu/resource/authority/access-right/PUBLIC'']'),
                     ('health-nonpublic-300',
                      '//dcat:Catalog[dcat:record/*/dct:conformsTo/*/@rdf:about = ''https://healthdataeu.pages.code.europa.eu/healthdcat-ap/releases/release-7/'' and dcat:dataset/*/dct:accessRights/*/@rdf:about = ''http://publications.europa.eu/resource/authority/access-right/NON_PUBLIC'']'))
               as t (xpathtarget, xpath));

-- remove schematrons
delete from schematrondes
  where iddes in (
    select id from schematron s where schemaname = 'dcat-ap');

delete from schematroncriteria
  where group_schematronid in (
    select schematronid from schematroncriteriagroup where schematronid in (
      select id from schematron s where schemaname = 'dcat-ap'));

delete from schematroncriteriagroup
  where schematronid in (
    select id from schematron s where schemaname = 'dcat-ap');

delete from schematron s
  where schemaname = 'dcat-ap';

-- create the schematron entries
insert into schematron (id, displaypriority, filename, schemaname)
  select  nextval('schematron_id_seq'), row_number() over (), filename, schemaname
  from _schematron;

insert into schematroncriteriagroup (name, schematronid, requirement)
  (select '*generated*', schematron.id, requirement
   from _schematron
          inner join schematron using (filename, schemaname));

-- we're only dealing with xpath based criteria at this point
insert into schematroncriteria
  (id, "type", uitype, uivalue, value, group_name, group_schematronid)
  select nextval('schematron_criteria_id_seq'), 'XPATH', 'XPATH', xpath, xpath, g.name, g.schematronid
  from _schematron
         inner join _xpaths using (xpathtarget)
         inner join schematron s using (filename, schemaname)
         inner join schematroncriteriagroup g on g.schematronid = s.id;



-- Update thesaurus id due to DCAT-AP plugin default thesaurus
UPDATE metadata SET data = replace(data, 'external.theme.georeferencing-method', 'external.theme.mobility-georeferencing-method') WHERE data LIKE '%%';
UPDATE metadata SET data = replace(data, 'external.theme.intended-information-service', 'external.theme.mobility-intended-information-service') WHERE data LIKE '%%';

INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('metadata/url/sitemapLinkUrl', NULL, 0, 9165, 'y');

UPDATE Settings SET value='4.4.13' WHERE name='system/platform/version';
UPDATE Settings SET value='SNAPSHOT' WHERE name='system/platform/subVersion';

