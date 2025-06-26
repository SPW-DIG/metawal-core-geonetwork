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

  <sch:title xmlns="http://www.w3.org/2001/XMLSchema">DCAT-AP - Recommended</sch:title>
  <sch:ns prefix="gml" uri="http://www.opengis.net/gml/3.2"/>
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
  <sch:ns prefix="mmi" uri="http://standards.iso.org/iso/19115/-3/mmi/1.0"/>
  <sch:ns prefix="mdUtil" uri="java:org.fao.geonet.api.records.MetadataUtils"/>

   <!-- Resource Revision date -->
    <sch:diagnostic id="rule.dcatap.resourcerevisiondate.mandatory-failure-en" xml:lang="en">
      Enter the revision date of the resource.
    </sch:diagnostic>
    <sch:diagnostic id="rule.dcatap.resourcerevisiondate.mandatory-failure-fr" xml:lang="fr">
      Renseignez la date de révision de la ressource.
    </sch:diagnostic>
    <sch:diagnostic id="rule.dcatap.resourcerevisiondate.mandatory-success-en"
                    xml:lang="en">Resource revision date found:
      <sch:value-of select="string-join($resourceRevisionDate, ', ')"/>
    </sch:diagnostic>
    <sch:diagnostic id="rule.dcatap.resourcerevisiondate.mandatory-success-fr"
                    xml:lang="fr">Date de modification de la resource encodée:
      <sch:value-of select="string-join($resourceRevisionDate, ', ')"/>
    </sch:diagnostic>
    <sch:pattern id="resource-revision-date">
      <sch:title xml:lang="en">It is recommended to enter the last modification date of the resource</sch:title>
      <sch:title xml:lang="fr">Il est recommandé d'indiquer la date de dernière modification de la ressource</sch:title>
      <sch:rule
        context="//*:MD_Metadata[not ((*:metadataScope/*/*:resourceScope|*:hierarchyLevel)/*/@codeListValue = ('series','service'))]">

        <sch:let name="resourceRevisionDate"
                 value="*:identificationInfo/*/*:citation/*/*:date/*[*:dateType/*/@codeListValue = 'revision']/*:date[*/text() != '']"/>
        <sch:let name="hasResourceRevisionDate"
                 value="count($resourceRevisionDate) > 0"/>

        <sch:assert test="$hasResourceRevisionDate"
                    diagnostics="rule.dcatap.resourcerevisiondate.mandatory-failure-en rule.dcatap.resourcerevisiondate.mandatory-failure-fr"/>
        <sch:report test="$hasResourceRevisionDate"
                    diagnostics="rule.dcatap.resourcerevisiondate.mandatory-success-en rule.dcatap.resourcerevisiondate.mandatory-success-fr"/>
      </sch:rule>
    </sch:pattern>

    <!-- Resource Publication date-->
      <sch:diagnostic id="rule.dcatap.resourcepublicationdate.mandatory-failure-en" xml:lang="en">
       Enter the publication date.
      </sch:diagnostic>
      <sch:diagnostic id="rule.dcatap.resourcepublicationdate.mandatory-failure-fr" xml:lang="fr">
       Renseignez la date de publication de la ressource.
      </sch:diagnostic>
      <sch:diagnostic id="rule.dcatap.resourcepublicationdate.mandatory-success-en"
                      xml:lang="en">Resource publication date found:
        <sch:value-of select="string-join($resourcePublicationDate, ', ')"/>
      </sch:diagnostic>
      <sch:diagnostic id="rule.dcatap.resourcepublicationdate.mandatory-success-fr"
                      xml:lang="fr">Date de publication de la resource encodée:
        <sch:value-of select="string-join($resourcePublicationDate, ', ')"/>
      </sch:diagnostic>
      <sch:pattern id="resource-publication-date">
        <sch:title xml:lang="en">It is recommended to enter the publication date of the resource</sch:title>
        <sch:title xml:lang="fr">Il est recommandé d'indiquer la date de publication de la ressource</sch:title>
        <sch:rule
          context="//*:MD_Metadata[(*:metadataScope/*/*:resourceScope|*:hierarchyLevel)/*/@codeListValue != 'series']">

          <sch:let name="resourcePublicationDate"
                   value="*:identificationInfo/*/*:citation/*/*:date/*[*:dateType/*/@codeListValue = 'publication']/*:date[*/text() != '']"/>
          <sch:let name="hasResourcePublicationDate"
                   value="count($resourcePublicationDate) > 0"/>

          <sch:assert test="$hasResourcePublicationDate"
                      diagnostics="rule.dcatap.resourcepublicationdate.mandatory-failure-en rule.dcatap.resourcepublicationdate.mandatory-failure-fr"/>
          <sch:report test="$hasResourcePublicationDate"
                      diagnostics="rule.dcatap.resourcepublicationdate.mandatory-success-en rule.dcatap.resourcepublicationdate.mandatory-success-fr"/>
        </sch:rule>
      </sch:pattern>

    <!-- Contact Point-->
    <sch:diagnostic id="rule.dcatap.contactPoint.mandatory-failure-en" xml:lang="en">
      Add a Responsible Party with the role of 'point of contact'.
    </sch:diagnostic>
    <sch:diagnostic id="rule.dcatap.contactPoint.mandatory-failure-fr" xml:lang="fr">
     Ajoutez un Responsable avec le rôle "point de contact"
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
    <sch:pattern id="resource-contact">
      <sch:title xml:lang="en">It is recommended to define a point of contact</sch:title>
      <sch:title xml:lang="fr">Il est recommandé de définir un point de contact</sch:title>
      <sch:rule context="//*:MD_Metadata">
        <sch:let name="resourcePointOfContact"
                 value="*:identificationInfo/*/*:pointOfContact/*[*:role/*/@codeListValue = 'pointOfContact']/*:party/*/*:name/*[text() != '']"/>
        <sch:let name="hasOneOrMorePointOfContact"
                 value="count($resourcePointOfContact) > 0"/>

        <sch:assert test="$hasOneOrMorePointOfContact"
                    diagnostics="rule.dcatap.contactPoint.mandatory-failure-en rule.dcatap.contactPoint.mandatory-failure-fr"/>
        <sch:report test="$hasOneOrMorePointOfContact"
                    diagnostics="rule.dcatap.contactPoint.mandatory-success-en rule.dcatap.contactPoint.mandatory-success-fr"/>
      </sch:rule>
    </sch:pattern>

  <!-- Custodian -->
    <sch:diagnostic id="rule.dcatap.custodian.mandatory-failure-en" xml:lang="en">
      Add a Responsible Party with the role of 'custodian'.
    </sch:diagnostic>
    <sch:diagnostic id="rule.dcatap.custodian.mandatory-failure-fr" xml:lang="fr">
       Ajoutez un Responsable avec le rôle "gestionnaire".
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
    <sch:pattern id="resource-custodian">
      <sch:title xml:lang="en">It is recommended to define the custodian</sch:title>
      <sch:title xml:lang="fr">Il est recommandé de définir le gestionnaire de la ressource</sch:title>
      <sch:rule context="//*:MD_Metadata">
        <sch:let name="resourceCustodian"
                 value="*:identificationInfo/*/*:pointOfContact/*[*:role/*/@codeListValue = 'custodian']/*:party/*/*:name/*[text() != '']"/>
        <sch:let name="hasOneOrMoreCustodian"
                 value="count($resourceCustodian) > 0"/>

        <sch:assert test="$hasOneOrMoreCustodian"
                    diagnostics="rule.dcatap.custodian.mandatory-failure-en rule.dcatap.custodian.mandatory-failure-fr"/>
        <sch:report test="$hasOneOrMoreCustodian"
                    diagnostics="rule.dcatap.custodian.mandatory-success-en rule.dcatap.custodian.mandatory-success-fr"/>
      </sch:rule>
    </sch:pattern>

    <!-- Geospatial extent -->
    <sch:diagnostic id="rule.dcatap.geospatial-extent.recommended-failure-en" xml:lang="en">
     Add the geographic extent of the resource.
    </sch:diagnostic>
    <sch:diagnostic id="rule.dcatap.geospatial-extent.recommended-failure-fr" xml:lang="fr">
      Ajoutez l'emprise géographique de la ressource.
    </sch:diagnostic>
    <sch:diagnostic id="rule.dcatap.geospatial-extent.recommended-success-en" xml:lang="en">
      Geospatial extent found.
    </sch:diagnostic>
    <sch:diagnostic id="rule.dcatap.geospatial-extent.recommended-success-fr" xml:lang="fr">
      Emprise géospatiale trouvée.
    </sch:diagnostic>

    <sch:pattern id="geospatial-extent">
      <sch:title xml:lang="en">It is recommended to provide the geographic extent</sch:title>
      <sch:title xml:lang="fr">Il est recommandé de renseigner l'emprise géographique</sch:title>
      <sch:rule context="//*:MD_Metadata[(*:metadataScope/*/*:resourceScope|*:hierarchyLevel)/*/@codeListValue != 'service']">

        <sch:let name="geospatialExtent"
                 value="//*:extent/*/*:geographicElement/*"/>
        <sch:let name="hasGeospatialExtent"
                 value="boolean(
                          $geospatialExtent[
                            gex:westBoundLongitude/gco:Decimal[text() != ''] and
                            gex:eastBoundLongitude/gco:Decimal[text() != ''] and
                            gex:southBoundLatitude/gco:Decimal[text() != ''] and
                            gex:northBoundLatitude/gco:Decimal[text() != '']
                          ])"/>

        <sch:assert test="$hasGeospatialExtent"
                    diagnostics="rule.dcatap.geospatial-extent.recommended-failure-en rule.dcatap.geospatial-extent.recommended-failure-fr"/>
        <sch:report test="$hasGeospatialExtent"
                    diagnostics="rule.dcatap.geospatial-extent.recommended-success-en rule.dcatap.geospatial-extent.recommended-success-fr"/>
      </sch:rule>
      </sch:pattern>

      <!-- Temporal Extent -->
      <sch:diagnostic id="rule.dcatap.temporal-extent.recommended-failure-en" xml:lang="en">
       Add the temporal extent of the resource.
      </sch:diagnostic>
      <sch:diagnostic id="rule.dcatap.temporal-extent.recommended-failure-fr" xml:lang="fr">
       Ajoutez l'étendue temporelle de la ressource.
      </sch:diagnostic>
      <sch:diagnostic id="rule.dcatap.temporal-extent.recommended-success-en" xml:lang="en">
      Temporal extent found, from:
      <sch:value-of select="concat(' ', $periodStart, ' à ',$periodEnd)"/>
      </sch:diagnostic>
      <sch:diagnostic id="rule.dcatap.temporal-extent.recommended-success-fr" xml:lang="fr">
      Période temporelle trouvée, de:
      <sch:value-of select="concat(' ', $periodStart, ' à ',$periodEnd)"/>
      </sch:diagnostic>
      <sch:pattern id="temporal-extent" >
         <sch:title xml:lang="en">It is recommended to provide the temporal extent</sch:title>
         <sch:title xml:lang="fr">Il est recommandé de renseigner l'étendue temporelle</sch:title>
         <sch:rule
           context="//*:MD_Metadata[not ((*:metadataScope/*/*:resourceScope|*:hierarchyLevel)/*/@codeListValue = ('series','service'))]">

           <sch:let name="temporalElement"
                    value="//*:extent/*/*:temporalElement/*/*:extent"/>
           <sch:let name="periodStart"
                    value="$temporalElement//gml:start/gml:timePosition[text() != '']|$temporalElement//gml:beginPosition[. != '']"/>
           <sch:let name="periodEnd" value="$temporalElement//gml:end/gml:timePosition[text() != '']|$temporalElement//gml:endPosition[. != '']"/>

           <sch:let name="hasTemporalExtent" value="count($periodStart) > 0 and count($periodEnd) > 0" />

           <sch:assert test="$hasTemporalExtent"
                       diagnostics="rule.dcatap.temporal-extent.recommended-failure-en rule.dcatap.temporal-extent.recommended-failure-fr"/>
           <sch:report test="$hasTemporalExtent"
                       diagnostics="rule.dcatap.temporal-extent.recommended-success-en rule.dcatap.temporal-extent.recommended-success-fr"/>
         </sch:rule>
      </sch:pattern>

   <!-- Theme -->
      <sch:diagnostic id="rule.dcatap.themes.mandatory-failure-en" xml:lang="en">
       Add a theme from the 'European Data Themes DCAT-AP' thesaurus.
      </sch:diagnostic>
      <sch:diagnostic id="rule.dcatap.themes.mandatory-failure-fr" xml:lang="fr">
       Ajoutez un thème provenant du thésaurus "Themes de données européens DCAT-AP".
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
      <sch:pattern id="resource-theme">
        <sch:title xml:lang="en">It is recommended to classify the resource under one of the European data themes of DCAT-AP</sch:title>
        <sch:title xml:lang="fr">Il est recommandé de classer la ressource dans un des thèmes de données européens DCAT-AP</sch:title>
        <sch:rule
          context="//*:MD_Metadata[(*:metadataScope/*/*:resourceScope|*:hierarchyLevel)/*/@codeListValue != 'series']">


        <sch:let name="dcatThemes"
                 value="*:identificationInfo/*/*:descriptiveKeywords/*/
                                *:keyword[starts-with(*:Anchor/@xlink:href, 'http://publications.europa.eu/resource/authority/data-theme')]"/>
        <sch:let name="hasDcatThemes"
                 value="count($dcatThemes) > 0"/>

        <sch:assert test="$hasDcatThemes"
                    diagnostics="rule.dcatap.themes.mandatory-failure-en rule.dcatap.themes.mandatory-failure-fr"/>
        <sch:report test="$hasDcatThemes"
                    diagnostics="rule.dcatap.themes.mandatory-success-en rule.dcatap.themes.mandatory-success-fr"/>
        </sch:rule>
      </sch:pattern>

    <!-- Keywords -->
    <sch:diagnostic id="rule.dcatap.keywords.mandatory-failure-en" xml:lang="en">
      Add keywords that describe your resource.
    </sch:diagnostic>
    <sch:diagnostic id="rule.dcatap.keywords.mandatory-failure-fr" xml:lang="fr">
     Ajoutez des mots-clés qui décrivent votre ressource.
    </sch:diagnostic>
    <sch:diagnostic id="rule.dcatap.keywords.mandatory-success-en"
                    xml:lang="en">
      <sch:value-of
        select="count($keywords)"/>
      keyword(s) found.
    </sch:diagnostic>
    <sch:diagnostic id="rule.dcatap.keywords.mandatory-success-fr"
                    xml:lang="fr">
      <sch:value-of
        select="count($keywords)"/>
      mot(s) clé(s) encodé(s).
    </sch:diagnostic>
    <sch:pattern id="resource-keywords">
      <sch:title xml:lang="en">It is recommended to describe the resource using keywords</sch:title>
      <sch:title xml:lang="fr">Il est recommandé de décrire la ressource avec des mots-clés</sch:title>
      <sch:rule
        context="//*:MD_Metadata[(*:metadataScope/*/*:resourceScope|*:hierarchyLevel)/*/@codeListValue != 'series']">
      <!--
      Keywords can be mapped to DCAT themes, legislation, or excluded eg. internal themes.
      See dcat-core-keywords.xsl.
      Only consider others.
      -->
      <sch:let name="thesaurusToIgnore"
               value="('http://publications.europa.eu/resource/authority/data-theme',
                        'http://data.europa.eu/bna/asd487ae75',
                            'http://data.europa.eu/r5r/applicableLegislation',
                            'https://metawal.wallonie.be/thesaurus/theme-geoportail-wallon',
                            'https://metawal.wallonie.be/thesaurus/infrasig')"/>

      <sch:let name="keywords"
               value="*:identificationInfo/*/*:descriptiveKeywords/*[
               not(mri:thesaurusName/*/cit:title/*/@xlink:href = $thesaurusToIgnore)
               ]/*:keyword[*/text() != '']"/>
      <sch:let name="hasKeywords"
               value="count($keywords) > 0"/>

      <sch:assert test="$hasKeywords"
                  diagnostics="rule.dcatap.keywords.mandatory-failure-en rule.dcatap.keywords.mandatory-failure-fr"/>
      <sch:report test="$hasKeywords"
                  diagnostics="rule.dcatap.keywords.mandatory-success-en rule.dcatap.keywords.mandatory-success-fr"/>
    </sch:rule>
  </sch:pattern>

  <!-- Access constraints -->
  <sch:diagnostic id="rule.dcatap.dataset.access.constraints.mandatory-failure-en" xml:lang="en">
   Define the applicable access conditions by selecting a value from the 'Access Constraints' list and specifying any 'Other Constraints'. The access conditions must be grouped within a 'Resource Constraints' block and kept separate from the usage conditions.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.dataset.access.constraints.mandatory-failure-fr" xml:lang="fr">
    Définissez les conditions d'accès applicables en choisissant une valeur de la liste "Contraintes d'accès" et en mentionnant des "Autres contraintes". Les conditions d'accès doivent être regroupées dans un bloc de "Contraintes sur la ressource" et séparées des conditions d'utilisation.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.dataset.access.constraints.mandatory-success-en"
                  xml:lang="en">
    Access constraints found.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.dataset.access.constraints.mandatory-success-fr"
                  xml:lang="fr">
    Contraintes d'accès encodées.
  </sch:diagnostic>
  <sch:pattern id="dataset-accessconstraints">
   <sch:title xml:lang="en">It is recommended to define the access level of the resource</sch:title>
   <sch:title xml:lang="fr">Il est recommandé de définir le niveau d'accès à la ressource</sch:title>
   <sch:rule
      context="//*:MD_Metadata[(*:metadataScope/*/*:resourceScope|*:hierarchyLevel)/*/@codeListValue = 'dataset']">

      <sch:let name="accessConstraints"
               value="*:identificationInfo/*/*:resourceConstraints/*[not(*:useConstraints) and *:otherConstraints/*/text() != '' and *:accessConstraints/*/@codeListValue != '']/*:otherConstraints/*/text()"/>

      <sch:let name="hasAccessConstraints"
               value="count($accessConstraints) > 0"/>

      <sch:assert test="$hasAccessConstraints"
                  diagnostics="rule.dcatap.dataset.access.constraints.mandatory-failure-en rule.dcatap.dataset.access.constraints.mandatory-failure-fr"/>
      <sch:report test="$hasAccessConstraints"
                  diagnostics="rule.dcatap.dataset.access.constraints.mandatory-success-en rule.dcatap.dataset.access.constraints.mandatory-success-fr"/>
   </sch:rule>
  </sch:pattern>

  <!-- Use constraints-->
  <sch:diagnostic id="rule.dcatap.dataset.use.constraints.mandatory-failure-en" xml:lang="en">
    Define the applicable terms of use by selecting a value from the 'Access Constraints' list and specifying any 'Other Constraints'. The terms of use must be grouped within a 'Resource Constraints' block and kept separate from the access conditions.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.dataset.use.constraints.mandatory-failure-fr" xml:lang="fr">
    Définissez les conditions d'utilisation applicables en choisissant une valeur de la liste "Contraintes d'accès" et en mentionnant des "Autres contraintes". Les conditions d'utilisation doivent être regroupées dans un bloc de "Contraintes sur la ressource" et séparées des conditions d'accès.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.dataset.use.constraints.mandatory-success-en"
                  xml:lang="en">
    Use constraints found.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.dataset.use.constraints.mandatory-success-fr"
                  xml:lang="fr">
    Contraintes d'utilisation encodées.
  </sch:diagnostic>
  <sch:pattern id="dataset-useconstraints">
     <sch:title xml:lang="en">It is recommended to define a license or terms of use</sch:title>
     <sch:title xml:lang="fr">Il est recommandé de définir une licence ou des conditions d'utilisation</sch:title>
      <sch:rule
        context="//*:MD_Metadata[(*:metadataScope/*/*:resourceScope|*:hierarchyLevel)/*/@codeListValue = ('dataset', 'service')]">

        <sch:let name="useConstraints"
                 value="*:identificationInfo/*/*:resourceConstraints/*[not(*:accessConstraints) and *:otherConstraints/*/text() != '' and *:useConstraints/*/@codeListValue != '']/*:otherConstraints/*/text()"/>
        <sch:let name="hasUseConstraints"
                 value="count($useConstraints) > 0"/>

        <sch:assert test="$hasUseConstraints"
                    diagnostics="rule.dcatap.dataset.use.constraints.mandatory-failure-en rule.dcatap.dataset.use.constraints.mandatory-failure-fr"/>
        <sch:report test="$hasUseConstraints"
                    diagnostics="rule.dcatap.dataset.use.constraints.mandatory-success-en rule.dcatap.dataset.use.constraints.mandatory-success-fr"/>
      </sch:rule>
    </sch:pattern>

  <!-- Dataset Distribution-->
  <sch:diagnostic id="rule.dcatap.dataset.distribution.mandatory-failure-en" xml:lang="en">
      Add a download page (online resource with protocol 'WWW:LINK' and function 'download') OR a direct download link (online resource with protocol 'WWW:DOWNLOAD' and function 'download') OR a relation to the record of a visualization or download service.
    </sch:diagnostic>
    <sch:diagnostic id="rule.dcatap.dataset.distribution.mandatory-failure-fr" xml:lang="fr">
      Ajoutez une page de téléchargement (ressource en ligne avec protocole "WWW:LINK" et fonction "download") OU un lien de téléchargement direct (ressource en ligne avec protocole "WWW:DOWNLOAD" et fonction "download") OU une relation vers la fiche d'un service de visualisation ou de téléchargement.
    </sch:diagnostic>
    <sch:diagnostic id="rule.dcatap.dataset.distribution.mandatory-success-en"
                    xml:lang="en">
       <sch:value-of select="$numberOfDistributions"/>
       Distribution URLs found:<sch:value-of select="concat(' ', string-join($distributions, ', '))"/>.
    </sch:diagnostic>
    <sch:diagnostic id="rule.dcatap.dataset.distribution.mandatory-success-fr"
                    xml:lang="fr">
      <sch:value-of select="$numberOfDistributions"/>
      URL(s) de distribution encodées :<sch:value-of select="concat(' ', string-join($distributions, ', '))"/>.
    </sch:diagnostic>

    <sch:pattern id="dataset-distribution">
      <sch:title xml:lang="en">It is recommended to specify at least one distribution</sch:title>
      <sch:title xml:lang="fr">Il est recommandé de spécifier au moins un canal de distribution</sch:title>

      <sch:rule context="//*:MD_Metadata[(*:metadataScope/*/*:resourceScope|*:hierarchyLevel)/*/@codeListValue = 'dataset']" >

        <sch:let name="distributions"
                 value="*:distributionInfo//*:onLine/*[*:linkage/(*:CharacterString|*:URL)/text() != ''][not(
                                          cit:function/*/@codeListValue = ('information', 'search', 'completeMetadata', 'browseGraphic', 'upload', 'emailService')
                                          or (not(cit:function/*/@codeListValue) and matches(*:protocol/*/text(), 'WWW:LINK.*')))]/*:linkage/(*:CharacterString|*:URL)"/>

         <sch:let name="numberOfDistributions"
                         value="count($distributions)"/>
        <sch:let name="hasOneOrMoreDistributions"
                 value="$numberOfDistributions > 0"/>

        <sch:assert test="$hasOneOrMoreDistributions"
                    diagnostics="rule.dcatap.dataset.distribution.mandatory-failure-en rule.dcatap.dataset.distribution.mandatory-failure-fr"/>
        <sch:report test="$hasOneOrMoreDistributions"
                    diagnostics="rule.dcatap.dataset.distribution.mandatory-success-en rule.dcatap.dataset.distribution.mandatory-success-fr"/>
      </sch:rule>
  </sch:pattern>

  <sch:diagnostic id="rule.dcatap.distribution-has-size.failure-en" xml:lang="en">
    It is recommended to specify the size of the download file -
    Add the size of the download file in MB <sch:value-of select="$linkage"/>
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.distribution-has-size.failure-fr" xml:lang="fr">
    Il est recommandé d'indiquer la taille du fichier de téléchargement -
    Ajoutez la taille du fichier de téléchargement en Mo <sch:value-of select="$linkage"/>.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.distribution-has-size.success-en"
                  xml:lang="en">
    It is recommended to specify the size of the download file -
    Distribution <sch:value-of select="$linkage"/>
    size is <sch:value-of select="$size"/> Mo.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.distribution-has-size.success-fr"
                  xml:lang="fr">
    Il est recommandé d'indiquer la taille du fichier de téléchargement -
    Taille du téléchargement pour <sch:value-of select="$linkage"/> est : <sch:value-of select="$size"/> Mo.
  </sch:diagnostic>

  <sch:diagnostic id="rule.dcatap.distribution-has-atomservice.failure-en" xml:lang="en">
    It is recommended to provide the Atom service of the data -
    Add a link between the dataset record and the record of the Atom service that allows it to be downloaded.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.distribution-has-atomservice.failure-fr" xml:lang="fr">
    Il est recommandé de renseigner le service atom de la donnée -
    Ajoutez un lien entre la fiche de la donnée et la fiche du service atom qui permet de la télécharger.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.distribution-has-atomservice.success-en"
                  xml:lang="en">
    It is recommended to provide the Atom service of the data -
    ATOM service found: <sch:value-of select="$atomService/root/nameObject/default"/>.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.distribution-has-atomservice.success-fr"
                  xml:lang="fr">
    Il est recommandé de renseigner le service atom de la donnée -
    Service ATOM encodé: <sch:value-of select="$atomService/root/resourceTitleObject/default"/>.
  </sch:diagnostic>

  <sch:diagnostic id="rule.dcatap.distribution-has-downloadprotocol.failure-en" xml:lang="en">
    It is recommended to specify the format of the download file -
    Verify that the protocol specifies the file format in the form 'WWW:DOWNLOAD:IANA_code_of_the_format' <sch:value-of select="$linkage"/>
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.distribution-has-downloadprotocol.failure-fr" xml:lang="fr">
    Il est recommandé de spécifier le format du fichier de téléchargement -
    Vérifiez que le protocole mentionne le format du fichier sous la forme "WWW:DOWNLOAD:code_IANA_du_format" <sch:value-of select="$linkage"/>
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.distribution-has-downloadprotocol.success-en"
                  xml:lang="en">
    It is recommended to specify the format of the download file -
    Download protocol is set to<sch:value-of select="$protocol"/>.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.distribution-has-downloadprotocol.success-fr"
                  xml:lang="fr">
    Il est recommandé de spécifier le format du fichier de téléchargement -
    Protocole encodé : <sch:value-of select="$protocol"/>.
  </sch:diagnostic>

  <sch:pattern id="distribution">
    <sch:title>&#10;</sch:title>
    <sch:rule context="//*:MD_Metadata[(*:metadataScope/*/*:resourceScope|*:hierarchyLevel)/*/@codeListValue = ('dataset', 'series')]/*:distributionInfo//*:onLine[
                                   not(*/*:protocol/*/text() = 'WWW:LINK' and */*:function/*/@codeListValue = 'download')
                                   and
                                   not(
                                    */*:function/*/@codeListValue = ('information', 'information.content', 'information.portrayal', 'information.lineage', 'information.qualitySpecification', 'information.qualityReport', 'search', 'completeMetadata', 'browseGraphic', 'upload', 'emailService')
                                    or (*/*:function/*/@codeListValue = 'browsing' and matches(*/*:protocol/*/text(), 'WWW:LINK.*'))
                                    or ((not(*/*:function/*) or */*:function/*/@codeListValue = '') and (matches(*/*:protocol/*/text(), 'WWW:LINK.*') or not(*/*:protocol/*) or */*:protocol/*/text() = ''))
                                   )
                                   and not(*/*:protocol/* = ('ESRI:REST', 'ESRI:REST-TILED', 'OGC:WMS', 'OGC:WMTS', 'OGC:WFS', 'OGC:WCS', 'atom:feed', 'INSPIRE atom', 'OGC API - Features'))
                                 ][*/*:linkage/*/text() != '']">

      <sch:let name="linkage"
               value="*/*:linkage/*[text() != '']"/>
      <sch:let name="size"
               value="ancestor::mrd:MD_DigitalTransferOptions/mrd:transferSize/*/text()[. castable as xs:double]"/>

      <sch:report test="exists($size)"
                  diagnostics="rule.dcatap.distribution-has-size.success-en rule.dcatap.distribution-has-size.success-fr"/>
      <sch:assert test="exists($size)"
                  diagnostics="rule.dcatap.distribution-has-size.failure-en rule.dcatap.distribution-has-size.failure-fr"/>

      <sch:let name="associations"
                    value="mdUtil:getAssociatedAsXml(ancestor::*:MD_Metadata/mdb:metadataIdentifier/*/mcc:code/*/text())"/>

      <sch:let name="atomService"
               value="$associations/relations/services[root/resourceType = 'service' and root/link/protocol = 'atom:feed']"/>
      <sch:report test="exists($atomService)"
                  diagnostics="rule.dcatap.distribution-has-atomservice.success-en rule.dcatap.distribution-has-atomservice.success-fr"/>
      <sch:assert test="exists($atomService)"
                  diagnostics="rule.dcatap.distribution-has-atomservice.failure-en rule.dcatap.distribution-has-atomservice.failure-fr"/>

      <sch:let name="protocol"
               value="*/*:protocol/*[text() != '']"/>
      <sch:assert test="matches($protocol, 'WWW:DOWNLOAD:.*')"
                  diagnostics="rule.dcatap.distribution-has-downloadprotocol.failure-en rule.dcatap.distribution-has-downloadprotocol.failure-fr"/>
      <sch:report test="matches($protocol, 'WWW:DOWNLOAD:.*')"
                  diagnostics="rule.dcatap.distribution-has-downloadprotocol.success-en rule.dcatap.distribution-has-downloadprotocol.success-fr"/>
    </sch:rule>
  </sch:pattern>


  <!-- -->
  <!-- SERVICE RULES -->
  <!-- -->


  <sch:diagnostic id="rule.hvd.operateson.mandatory-failure-en" xml:lang="en">
    An API in the context of HVD is not a standalone resource. It is used to open up HVD datasets. Therefore each Data
    Service is at least tightly connected with a Dataset.
    Add at least one operatesOn element with a xlink:href or uuidref.
  </sch:diagnostic>
  <sch:diagnostic id="rule.hvd.operateson.mandatory-failure-fr" xml:lang="fr">
    Une API dans le contexte de HVD n'est pas une ressource autonome. Elle est utilisée pour ouvrir des ensembles de
    données HVD. Par conséquent, chaque service de données est au moins étroitement lié à un ensemble de données.
    Ajoutez au moins un élément operateOn avec un xlink:href ou un uuidref.
  </sch:diagnostic>
  <sch:diagnostic id="rule.hvd.operateson.mandatory-success-en"
                  xml:lang="en">
    Operates on dataset found:<sch:value-of select="concat(' ', string-join($operatesOnDatasets, ', '))"/>.
  </sch:diagnostic>
  <sch:diagnostic id="rule.hvd.operateson.mandatory-success-fr"
                  xml:lang="fr">
    Données associées encodées :<sch:value-of select="concat(' ', string-join($operatesOnDatasets, ', '))"/>.
  </sch:diagnostic>


  <sch:diagnostic id="rule.hvd.servicedocumentation.mandatory-failure-en" xml:lang="en">
    A page that provides additional information about the Data Service is missing.
    Add at least one online resource with a function documentation, an additional documentation or a URL pointing to https://directory.spatineo.com.
  </sch:diagnostic>
  <sch:diagnostic id="rule.hvd.servicedocumentation.mandatory-failure-fr" xml:lang="fr">
    Il manque une page qui fournit des informations supplémentaires sur le service de données.
    Ajoutez au moins une ressource en ligne avec une function documentation, une documentation supplémentaire ou une URL pointant vers https://directory.spatineo.com.
  </sch:diagnostic>
  <sch:diagnostic id="rule.hvd.servicedocumentation.mandatory-success-en"
                  xml:lang="en">
    Documentation pages found:<sch:value-of select="concat(' ', string-join($documentationUrls, ', '))"/>.
  </sch:diagnostic>
  <sch:diagnostic id="rule.hvd.servicedocumentation.mandatory-success-fr"
                  xml:lang="fr">
    Documentations encodées :<sch:value-of select="concat(' ', string-join($documentationUrls, ', '))"/>.
  </sch:diagnostic>

  <sch:pattern id="Service">
    <sch:rule
      context="//*:MD_Metadata[(*:metadataScope/*/*:resourceScope|*:hierarchyLevel)/*/@codeListValue = 'service']">

      <!--
      documentation (service)
      Document
      1..*
      A page that provides additional information about the Data Service.	Quality of service covers a broad spectrum of aspects.
      The HVD regulation does not list any mandatory topic. Therefore quality of service information is considered
      part of the generic documentation of a Data Service.
      P
      -->
      <sch:let name="onlineResource"
               value=".//(*:distributionInfo//mrd:onLine
                            |*:portrayalCatalogueCitation/*/*:onlineResource
                            |*:additionalDocumentation/*/*:onlineResource
                            |*:reportReference/*/*:onlineResource
                            |*:reportReference/*/cit:title[*:Anchor/@xlink:href]
                            |*:specification/*/*:onlineResource
                            |*:specification/*/cit:title[*:Anchor/@xlink:href]
                            |*:featureCatalogueCitation/*/*:onlineResource)"/>
      <sch:let name="documentationUrls"
               value="$onlineResource[*/*:function/*/@codeListValue = ('information')
                                  or count(ancestor::*:additionalDocumentation) = 1
                                  or count(ancestor::*:DQ_ConformanceResult) = 1
                                  or starts-with(*/*:linkage/(*:CharacterString|*:URL), 'https://directory.spatineo.com')]/(*/*:linkage/(*:CharacterString|*:URL)|*:Anchor/@xlink:href)"/>

      <sch:let name="hasOneOrMoreDocumentation"
               value="count($documentationUrls) > 0"/>

      <sch:assert test="$hasOneOrMoreDocumentation"
                  diagnostics="rule.hvd.servicedocumentation.mandatory-failure-en rule.hvd.servicedocumentation.mandatory-failure-fr"/>
      <sch:report test="$hasOneOrMoreDocumentation"
                  diagnostics="rule.hvd.servicedocumentation.mandatory-success-en rule.hvd.servicedocumentation.mandatory-success-fr"/>

      <!--
      serves dataset
      Dataset
      1..*
      This property refers to a collection of data that this data service can distribute.
      An API in the context of HVD is not a standalone resource. It is used to open up HVD datasets.
      Therefore each Data Service is at least tightly connected with a Dataset.
      -->
      <sch:let name="operatesOnDatasets"
               value=".//*:operatesOn/(@xlink:href[. != ''], @uuidref[. != ''])[1]"/>

      <sch:let name="hasOneOrMoreOperatesOn"
               value="count($operatesOnDatasets) > 0"/>

      <sch:assert test="$hasOneOrMoreOperatesOn"
                  diagnostics="rule.hvd.operateson.mandatory-failure-en rule.hvd.operateson.mandatory-failure-fr"/>
      <sch:report test="$hasOneOrMoreOperatesOn"
                  diagnostics="rule.hvd.operateson.mandatory-success-en rule.hvd.operateson.mandatory-success-fr"/>


    </sch:rule>
  </sch:pattern>

    <sch:diagnostic id="rule.dcatap.resourceabstract.mandatory-failure-en" xml:lang="en">
      Add an abstract.
    </sch:diagnostic>
    <sch:diagnostic id="rule.dcatap.resourceabstract.mandatory-failure-fr" xml:lang="fr">
      Ajoutez un résumé la ressource.
    </sch:diagnostic>
    <sch:diagnostic id="rule.dcatap.resourceabstract.mandatory-success-en"
                    xml:lang="en">Resource abstract found.
    </sch:diagnostic>
    <sch:diagnostic id="rule.dcatap.resourceabstract.mandatory-success-fr"
                    xml:lang="fr">La resource a un descriptif.
    </sch:diagnostic>
    <sch:pattern id="resource-abstract">
      <sch:title xml:lang="en">"It is recommended to complete the description of the resource</sch:title>
      <sch:title xml:lang="fr">Il est recommandé de compléter le descriptif de la ressource</sch:title>
      <sch:rule context="//*:MD_Metadata[(*:metadataScope/*/*:resourceScope|*:hierarchyLevel)/*/@codeListValue = 'service']">
        <sch:let name="resourceAbstract"
                 value="*:identificationInfo/*/*:abstract/*[text() != '']"/>
        <sch:let name="hasResourceAbstract"
                 value="count($resourceAbstract) > 0"/>

        <sch:assert test="$hasResourceAbstract"
                    diagnostics="rule.dcatap.resourceabstract.mandatory-failure-en rule.dcatap.resourceabstract.mandatory-failure-fr"/>
        <sch:report test="$hasResourceAbstract"
                    diagnostics="rule.dcatap.resourceabstract.mandatory-success-en rule.dcatap.resourceabstract.mandatory-success-fr"/>
      </sch:rule>
    </sch:pattern>

</sch:schema>
