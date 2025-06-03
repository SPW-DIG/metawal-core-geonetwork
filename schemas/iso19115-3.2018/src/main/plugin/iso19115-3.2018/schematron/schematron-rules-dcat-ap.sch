<?xml version="1.0" encoding="UTF-8"?>
<!--
  ~ Copyright (C) 2001-2016 Food and Agriculture Organization of the
  ~ United Nations (FAO-UN), United Nations World Food Programme (WFP)
  ~ and United Nations Environment Programme (UNEP)
  ~
  ~ This program is free software; you can redistribute it and/or modify
  ~ it under the terms of the GNU General Public License as published by
  ~ the Free Software Foundation; either version 2 of the License, or (at
  ~ your option) any later version.
  ~
  ~ This program is distributed in the hope that it will be useful, but
  ~ WITHOUT ANY WARRANTY; without even the implied warranty of
  ~ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
  ~ General Public License for more details.
  ~
  ~ You should have received a copy of the GNU General Public License
  ~ along with this program; if not, write to the Free Software
  ~ Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA
  ~
  ~ Contact: Jeroen Ticheler - FAO - Viale delle Terme di Caracalla 2,
  ~ Rome - Italy. email: geonetwork@osgeo.org
  -->

<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">

  <sch:title xmlns="http://www.w3.org/2001/XMLSchema">DCAT-AP</sch:title>
  <sch:ns prefix="gml" uri="http://www.opengis.net/gml"/>
  <sch:ns prefix="gmd" uri="http://standards.iso.org/iso/19115/-3/gmd"/>
  <sch:ns prefix="gmx" uri="http://standards.iso.org/iso/19115/-3/gmx"/>
  <sch:ns prefix="geonet" uri="http://www.fao.org/geonetwork"/>
  <sch:ns prefix="skos" uri="http://www.w3.org/2004/02/skos/core#"/>
  <sch:ns prefix="xlink" uri="http://www.w3.org/1999/xlink"/>
  <sch:ns prefix="srv" uri="http://standards.iso.org/iso/19115/-3/srv/2.0"/>
  <sch:ns prefix="mdb" uri="http://standards.iso.org/iso/19115/-3/mdb/2.0"/>
  <sch:ns prefix="mcc" uri="http://standards.iso.org/iso/19115/-3/mcc/1.0"/>
  <sch:ns prefix="mri" uri="http://standards.iso.org/iso/19115/-3/mri/1.0"/>
  <sch:ns prefix="mrs" uri="http://standards.iso.org/iso/19115/-3/mrs/1.0"/>
  <sch:ns prefix="mrd" uri="http://standards.iso.org/iso/19115/-3/mrd/1.0"/>
  <sch:ns prefix="mco" uri="http://standards.iso.org/iso/19115/-3/mco/1.0"/>
  <sch:ns prefix="msr" uri="http://standards.iso.org/iso/19115/-3/msr/2.0"/>
  <sch:ns prefix="lan" uri="http://standards.iso.org/iso/19115/-3/lan/1.0"/>
  <sch:ns prefix="gcx" uri="http://standards.iso.org/iso/19115/-3/gcx/1.0"/>
  <sch:ns prefix="gex" uri="http://standards.iso.org/iso/19115/-3/gex/1.0"/>
  <sch:ns prefix="dqm" uri="http://standards.iso.org/iso/19157/-2/dqm/1.0"/>
  <sch:ns prefix="cit" uri="http://standards.iso.org/iso/19115/-3/cit/2.0"/>
  <sch:ns prefix="mdq" uri="http://standards.iso.org/iso/19157/-2/mdq/1.0"/>
  <sch:ns prefix="mrl" uri="http://standards.iso.org/iso/19115/-3/mrl/2.0"/>
  <sch:ns prefix="gco" uri="http://standards.iso.org/iso/19115/-3/gco/1.0"/>
  <sch:ns prefix="mdUtil" uri="java:org.fao.geonet.api.records.MetadataUtils"/>


  <sch:diagnostic id="rule.dcatap.resourceid.mandatory-failure-en" xml:lang="en">
    Resource identifier is mandatory. Add a citation identifier with a codespace starting with http.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.resourceid.mandatory-failure-fr" xml:lang="fr">
    L'identifiant de la ressource est obligatoire. Ajoutez un identifiant de citation avec un codespace commençant par http.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.resourceid.mandatory-success-en"
                  xml:lang="en">Resource identifier found: <sch:value-of select="string-join($resourceIdentifier, ', ')"/>
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.resourceid.mandatory-success-fr"
                  xml:lang="fr">Identifiant de la ressource encodé: <sch:value-of select="string-join($resourceIdentifier, ', ')"/>
  </sch:diagnostic>


  <sch:diagnostic id="rule.dcatap.resourcetitle.mandatory-failure-en" xml:lang="en">
    Resource title is mandatory.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.resourcetitle.mandatory-failure-fr" xml:lang="fr">
    Le titre de la ressource est obligatoire.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.resourcetitle.mandatory-success-en"
                  xml:lang="en">Resource title found: <sch:value-of select="$resourceTitle"/>
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.resourcetitle.mandatory-success-fr"
                  xml:lang="fr">Titre de la resource encodé : <sch:value-of select="$resourceTitle"/>
  </sch:diagnostic>


  <sch:diagnostic id="rule.dcatap.resourceabstract.mandatory-failure-en" xml:lang="en">
    Resource abstract is mandatory.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.resourceabstract.mandatory-failure-fr" xml:lang="fr">
    Le descriptif de la ressource est obligatoire.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.resourceabstract.mandatory-success-en"
                  xml:lang="en">Resource abstract found.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.resourceabstract.mandatory-success-fr"
                  xml:lang="fr">Descriptif de la resource encodé.
  </sch:diagnostic>



  <sch:diagnostic id="rule.dcatap.resourcerevisiondate.mandatory-failure-en" xml:lang="en">
    Resource revision date is mandatory.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.resourcerevisiondate.mandatory-failure-fr" xml:lang="fr">
    La date de modification de la ressource est obligatoire.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.resourcerevisiondate.mandatory-success-en"
                  xml:lang="en">Resource revision date found: <sch:value-of select="string-join($resourceRevisionDate, ', ')"/>
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.resourcerevisiondate.mandatory-success-fr"
                  xml:lang="fr">Date de modification de la resource encodée : <sch:value-of select="string-join($resourceRevisionDate, ', ')"/>
  </sch:diagnostic>


  <sch:diagnostic id="rule.dcatap.resourcepublicationdate.mandatory-failure-en" xml:lang="en">
    Resource publication date is mandatory.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.resourcepublicationdate.mandatory-failure-fr" xml:lang="fr">
    La date de publication de la ressource est obligatoire.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.resourcepublicationdate.mandatory-success-en"
                  xml:lang="en">Resource publication date found: <sch:value-of select="string-join($resourcePublicationDate, ', ')"/>
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.resourcepublicationdate.mandatory-success-fr"
                  xml:lang="fr">Date de publication de la resource encodée : <sch:value-of select="string-join($resourcePublicationDate, ', ')"/>
  </sch:diagnostic>



  <sch:diagnostic id="rule.dcatap.contactPoint.mandatory-failure-en" xml:lang="en">
    Point of contact for the resource is mandatory. Add a point of contact with a role of pointOfContact.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.contactPoint.mandatory-failure-fr" xml:lang="fr">
    Point de contact pour la ressource est obligatoire. Ajoutez un point de contact avec un rôle de pointOfContact.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.contactPoint.mandatory-success-en"
                  xml:lang="en">
    Point of contact found:<sch:value-of
    select="concat(' ', string-join($resourcePointOfContact, ', '))"/>.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.contactPoint.mandatory-success-fr"
                  xml:lang="fr">
    Point de contact encodé :<sch:value-of
    select="concat(' ', string-join($resourcePointOfContact, ', '))"/>.
  </sch:diagnostic>


  <sch:diagnostic id="rule.dcatap.custodian.mandatory-failure-en" xml:lang="en">
    Custodian for the resource is mandatory. Add a point of contact with a role of custodian.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.custodian.mandatory-failure-fr" xml:lang="fr">
    Gestionnaire pour la ressource est obligatoire. Ajoutez un point de contact avec un rôle gestionnaire (custodian).
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.custodian.mandatory-success-en"
                  xml:lang="en">
    Custodian found:<sch:value-of
    select="concat(' ', string-join($resourceCustodian, ', '))"/>.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.custodian.mandatory-success-fr"
                  xml:lang="fr">
    Gestionnaire encodé :<sch:value-of
    select="concat(' ', string-join($resourceCustodian, ', '))"/>.
  </sch:diagnostic>


  <sch:diagnostic id="rule.dcatap.themes.mandatory-failure-en" xml:lang="en">
    DCAT themes for the resource are mandatory. Add a DCAT theme in keywords.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.themes.mandatory-failure-fr" xml:lang="fr">
    Les thèmes DCAT pour la ressource sont obligatoires. Ajoutez un thème DCAT dans les mots clés.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.themes.mandatory-success-en"
                  xml:lang="en">
    DCAT themes found:<sch:value-of
    select="concat(' ', string-join($dcatThemes, ', '))"/>.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.themes.mandatory-success-fr"
                  xml:lang="fr">
    Thèmes DCAT encodés :<sch:value-of
    select="concat(' ', string-join($dcatThemes, ', '))"/>.
  </sch:diagnostic>


  <sch:diagnostic id="rule.dcatap.keywords.mandatory-failure-en" xml:lang="en">
    Keywords are mandatory.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.keywords.mandatory-failure-fr" xml:lang="fr">
    Les mots clés sont obligatoires.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.keywords.mandatory-success-en"
                  xml:lang="en">
    <sch:value-of
    select="count($keywords)"/> keyword(s) found.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.keywords.mandatory-success-fr"
                  xml:lang="fr">
    <sch:value-of
      select="count($keywords)"/> mot(s) clé(s) encodé(s).
  </sch:diagnostic>

  <sch:pattern>
    <sch:title>DCAT-AP</sch:title>
    <sch:rule
      context="//*:MD_Metadata">

      <sch:let name="resourceIdentifier"
               value="*:identificationInfo/*/*:citation/*/*:identifier/*[*:codeSpace/*[starts-with(text(), 'http')]]/*:code/*[text() != '']"/>
      <sch:let name="hasResourceIdentifier"
               value="count($resourceIdentifier) > 0"/>

      <sch:assert test="$hasResourceIdentifier"
                  diagnostics="rule.dcatap.resourceid.mandatory-failure-en rule.dcatap.resourceid.mandatory-failure-fr"/>
      <sch:report test="$hasResourceIdentifier"
                  diagnostics="rule.dcatap.resourceid.mandatory-success-en rule.dcatap.resourceid.mandatory-success-fr"/>


      <sch:let name="resourceTitle"
               value="*:identificationInfo/*/*:citation/*/*:title/*[text() != '']"/>
      <sch:let name="hasResourceTitle"
               value="count($resourceTitle) > 0"/>

      <sch:assert test="$hasResourceTitle"
                  diagnostics="rule.dcatap.resourcetitle.mandatory-failure-en rule.dcatap.resourcetitle.mandatory-failure-fr"/>
      <sch:report test="$hasResourceTitle"
                  diagnostics="rule.dcatap.resourcetitle.mandatory-success-en rule.dcatap.resourcetitle.mandatory-success-fr"/>


      <sch:let name="resourceAbstract"
               value="*:identificationInfo/*/*:abstract/*[text() != '']"/>
      <sch:let name="hasResourceAbstract"
               value="count($resourceAbstract) > 0"/>

      <sch:assert test="$hasResourceAbstract"
                  diagnostics="rule.dcatap.resourceabstract.mandatory-failure-en rule.dcatap.resourceabstract.mandatory-failure-fr"/>
      <sch:report test="$hasResourceAbstract"
                  diagnostics="rule.dcatap.resourceabstract.mandatory-success-en rule.dcatap.resourceabstract.mandatory-success-fr"/>


      <sch:let name="resourceRevisionDate"
               value="*:identificationInfo/*/*:citation/*/*:date/*[*:dateType/*/@codeListValue = 'revision']/*:date[*/text() != '']"/>
      <sch:let name="hasResourceRevisionDate"
               value="count($resourceRevisionDate) > 0"/>

      <sch:assert test="$hasResourceRevisionDate"
                  diagnostics="rule.dcatap.resourcerevisiondate.mandatory-failure-en rule.dcatap.resourcerevisiondate.mandatory-failure-fr"/>
      <sch:report test="$hasResourceRevisionDate"
                  diagnostics="rule.dcatap.resourcerevisiondate.mandatory-success-en rule.dcatap.resourcerevisiondate.mandatory-success-fr"/>


      <sch:let name="resourcePublicationDate"
               value="*:identificationInfo/*/*:citation/*/*:date/*[*:dateType/*/@codeListValue = 'publication']/*:date[*/text() != '']"/>
      <sch:let name="hasResourcePublicationDate"
               value="count($resourcePublicationDate) > 0"/>

      <sch:assert test="$hasResourcePublicationDate"
                  diagnostics="rule.dcatap.resourcepublicationdate.mandatory-failure-en rule.dcatap.resourcepublicationdate.mandatory-failure-fr"/>
      <sch:report test="$hasResourcePublicationDate"
                  diagnostics="rule.dcatap.resourcepublicationdate.mandatory-success-en rule.dcatap.resourcepublicationdate.mandatory-success-fr"/>


      <sch:let name="resourcePointOfContact"
               value="*:identificationInfo/*/*:pointOfContact/*[*:role/*/@codeListValue = 'pointOfContact']/*:party/*/*:name/*[text() != '']"/>
      <sch:let name="hasOneOrMorePointOfContact"
               value="count($resourcePointOfContact) > 0"/>

      <sch:assert test="$hasOneOrMorePointOfContact"
                  diagnostics="rule.dcatap.contactPoint.mandatory-failure-en rule.dcatap.contactPoint.mandatory-failure-fr"/>
      <sch:report test="$hasOneOrMorePointOfContact"
                  diagnostics="rule.dcatap.contactPoint.mandatory-success-en rule.dcatap.contactPoint.mandatory-success-fr"/>


      <sch:let name="resourceCustodian"
               value="*:identificationInfo/*/*:pointOfContact/*[*:role/*/@codeListValue = 'custodian']/*:party/*/*:name/*[text() != '']"/>
      <sch:let name="hasOneOrMoreCustodian"
               value="count($resourceCustodian) > 0"/>

      <sch:assert test="$hasOneOrMoreCustodian"
                  diagnostics="rule.dcatap.custodian.mandatory-failure-en rule.dcatap.custodian.mandatory-failure-fr"/>
      <sch:report test="$hasOneOrMoreCustodian"
                  diagnostics="rule.dcatap.custodian.mandatory-success-en rule.dcatap.custodian.mandatory-success-fr"/>



      <sch:let name="dcatThemes"
               value="*:identificationInfo/*/*:descriptiveKeywords/*/
                              *:keyword[starts-with(*:Anchor/@xlink:href, 'http://publications.europa.eu/resource/authority/data-theme')]"/>
      <sch:let name="hasDcatThemes"
               value="count($dcatThemes) > 0"/>

      <sch:assert test="$hasDcatThemes"
                  diagnostics="rule.dcatap.themes.mandatory-failure-en rule.dcatap.themes.mandatory-failure-fr"/>
      <sch:report test="$hasDcatThemes"
                  diagnostics="rule.dcatap.themes.mandatory-success-en rule.dcatap.themes.mandatory-success-fr"/>


      <sch:let name="keywords"
               value="*:identificationInfo/*/*:descriptiveKeywords/*/
                              *:keyword[*/text() != '']"/>
      <sch:let name="hasKeywords"
               value="count($keywords) > 0"/>

      <sch:assert test="$hasKeywords"
                  diagnostics="rule.dcatap.keywords.mandatory-failure-en rule.dcatap.keywords.mandatory-failure-fr"/>
      <sch:report test="$hasKeywords"
                  diagnostics="rule.dcatap.keywords.mandatory-success-en rule.dcatap.keywords.mandatory-success-fr"/>

    </sch:rule>
  </sch:pattern>

  <sch:diagnostic id="rule.dcatap.dataset.constraints.mandatory-failure-en" xml:lang="en">
    Access constraints are mandatory.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.dataset.constraints.mandatory-failure-fr" xml:lang="fr">
    Les contraintes d'accès sont obligatoires.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.dataset.constraints.mandatory-success-en"
                  xml:lang="en">
    Access constraints found.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.dataset.constraints.mandatory-success-fr"
                  xml:lang="fr">
    Contraintes d'accès encodées.
  </sch:diagnostic>


  <sch:diagnostic id="rule.dcatap.dataset.lineage.mandatory-failure-en" xml:lang="en">
    Access lineage are mandatory.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.dataset.lineage.mandatory-failure-fr" xml:lang="fr">
    La généalogie est obligatoire.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.dataset.lineage.mandatory-success-en"
                  xml:lang="en">
    Lineage found.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.dataset.lineage.mandatory-success-fr"
                  xml:lang="fr">
    Généalogie encodée.
  </sch:diagnostic>
  <sch:pattern id="dataset">

  <sch:title>DCAT-AP (Dataset)</sch:title>
  <sch:rule context="//*:MD_Metadata[(*:metadataScope/*/*:resourceScope|*:hierarchyLevel)/*/@codeListValue = 'dataset']" >



      <sch:let name="hasConstraintType"
               value="count(*:identificationInfo/*/*:resourceConstraints/*/*:accessConstraints/*/@codeListValue[. != '']) > 0"/>
      <sch:let name="constraints"
               value="*:identificationInfo/*/*:resourceConstraints/*/*:otherConstraints[*/text() != '']"/>

      <sch:let name="hasConstraints"
               value="$hasConstraintType and count($constraints) > 0"/>

      <sch:assert test="$hasConstraints"
                  diagnostics="rule.dcatap.dataset.constraints.mandatory-failure-en rule.dcatap.dataset.constraints.mandatory-failure-fr"/>
      <sch:report test="$hasConstraints"
                  diagnostics="rule.dcatap.dataset.constraints.mandatory-success-en rule.dcatap.dataset.constraints.mandatory-success-fr"/>

      <sch:let name="hasLineage"
               value="count(*:resourceLineage/*/*:statement[*/text() != '']) > 0"/>

      <sch:assert test="$hasLineage"
                  diagnostics="rule.dcatap.dataset.lineage.mandatory-failure-en rule.dcatap.dataset.lineage.mandatory-failure-fr"/>
      <sch:report test="$hasLineage"
                  diagnostics="rule.dcatap.dataset.lineage.mandatory-success-en rule.dcatap.dataset.lineage.mandatory-success-fr"/>
  </sch:rule>
  </sch:pattern>

  <sch:diagnostic id="rule.dcatap.series.has-dataset.mandatory-failure-en" xml:lang="en">
    No related dataset.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.series.has-dataset.mandatory-failure-fr" xml:lang="fr">
    Pas de resource associée.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.series.has-dataset.mandatory-success-en"
                  xml:lang="en">
    Serie associated with one ore more datasets.
    <sch:value-of select="string-join($children/root/resourceIdentifier, ' | ')"/>
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.series.has-dataset.mandatory-success-fr"
                  xml:lang="fr">
    Série associée à une ou plusieures resources.
    <sch:value-of select="string-join($children/root/resourceIdentifier, ' | ')"/>
  </sch:diagnostic>

  <sch:pattern id="series">

    <sch:title>DCAT-AP (Serie)</sch:title>
    <sch:rule context="//*:MD_Metadata[(*:metadataScope/*/*:resourceScope|*:hierarchyLevel)/*/@codeListValue = 'series']" >

     <sch:let name="associations"
              value="mdUtil:getAssociatedAsXml(mdb:metadataIdentifier/*/mcc:code/*/text())/relations" />
     <sch:let name="children"
              value="$associations/*:children" />
     <sch:let name="hasRelatedDataset"
                   value="count($children) > 0"/>

    <sch:assert test="$hasRelatedDataset"
                      diagnostics="rule.dcatap.series.has-dataset.mandatory-failure-en rule.dcatap.series.has-dataset.mandatory-failure-fr"/>
    <sch:report test="$hasRelatedDataset"
                      diagnostics="rule.dcatap.series.has-dataset.mandatory-success-en rule.dcatap.series.has-dataset.mandatory-success-fr"/>



    </sch:rule>
    </sch:pattern>


</sch:schema>
