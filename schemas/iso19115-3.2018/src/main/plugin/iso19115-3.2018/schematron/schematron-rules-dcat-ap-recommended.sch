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
      Resource revision date is mandatory.
    </sch:diagnostic>
    <sch:diagnostic id="rule.dcatap.resourcerevisiondate.mandatory-failure-fr" xml:lang="fr">
      La date de modification de la ressource est obligatoire.
    </sch:diagnostic>
    <sch:diagnostic id="rule.dcatap.resourcerevisiondate.mandatory-success-en"
                    xml:lang="en">Resource revision date found:
      <sch:value-of select="string-join($resourceRevisionDate, ', ')"/>
    </sch:diagnostic>
    <sch:diagnostic id="rule.dcatap.resourcerevisiondate.mandatory-success-fr"
                    xml:lang="fr">Date de modification de la resource encodée :
      <sch:value-of select="string-join($resourceRevisionDate, ', ')"/>
    </sch:diagnostic>
    <sch:pattern id="resource-revision-date">
      <sch:title xml:lang="en">Resource revision date is defined</sch:title>
      <sch:title xml:lang="fr">La date de dernière modification de la ressource est renseignée</sch:title>
      <sch:rule
        context="//*:MD_Metadata[(*:metadataScope/*/*:resourceScope|*:hierarchyLevel)/*/@codeListValue != 'series']">

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
        Resource publication date is mandatory.
      </sch:diagnostic>
      <sch:diagnostic id="rule.dcatap.resourcepublicationdate.mandatory-failure-fr" xml:lang="fr">
        La date de publication de la ressource est obligatoire.
      </sch:diagnostic>
      <sch:diagnostic id="rule.dcatap.resourcepublicationdate.mandatory-success-en"
                      xml:lang="en">Resource publication date found:
        <sch:value-of select="string-join($resourcePublicationDate, ', ')"/>
      </sch:diagnostic>
      <sch:diagnostic id="rule.dcatap.resourcepublicationdate.mandatory-success-fr"
                      xml:lang="fr">Date de publication de la resource encodée :
        <sch:value-of select="string-join($resourcePublicationDate, ', ')"/>
      </sch:diagnostic>
      <sch:pattern id="resource-publication-date">
        <sch:title xml:lang="en">Resource publication date is defined</sch:title>
        <sch:title xml:lang="fr">La date de publication de la ressource est renseignée</sch:title>
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
      Add a contact with a role of pointOfContact.
    </sch:diagnostic>
    <sch:diagnostic id="rule.dcatap.contactPoint.mandatory-failure-fr" xml:lang="fr">
      Ajoutez un responsable avec le rôle "point de contact".
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
      <sch:title xml:lang="en">Resource's contact points defined</sch:title>
      <sch:title xml:lang="fr">Le point de contact est défini</sch:title>
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
      Add a contact with a role of custodian.
    </sch:diagnostic>
    <sch:diagnostic id="rule.dcatap.custodian.mandatory-failure-fr" xml:lang="fr">
       Ajoutez un responsable avec le rôle "gestionnaire".
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
      <sch:title xml:lang="en">Resource custodian is defined</sch:title>
      <sch:title xml:lang="fr">Le gestionnaire est défini</sch:title>
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

   <!-- Theme -->
      <sch:diagnostic id="rule.dcatap.themes.mandatory-failure-en" xml:lang="en">
        Add a theme from thesaurus "Data Theme DCAT-AP" of Publication Europa
      </sch:diagnostic>
      <sch:diagnostic id="rule.dcatap.themes.mandatory-failure-fr" xml:lang="fr">
        Ajoutez un thème provenant du thésaurus "Themes de données européens DCAT-AP"
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
        <sch:title xml:lang="en">The resource is classified under one of the European data themes of DCAT-AP</sch:title>
        <sch:title xml:lang="fr">La ressource est classée dans un des thèmes de données européens DCAT-AP</sch:title>
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
      Add keywords.
    </sch:diagnostic>
    <sch:diagnostic id="rule.dcatap.keywords.mandatory-failure-fr" xml:lang="fr">
      Décrivez votre ressource à l'aide de mots-clés
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
      <sch:title xml:lang="en">Keywords are defined</sch:title>
      <sch:title xml:lang="fr">Des mots-clés sont définis</sch:title>
      <sch:rule
        context="//*:MD_Metadata[(*:metadataScope/*/*:resourceScope|*:hierarchyLevel)/*/@codeListValue != 'series']">
      <!--
      Keywords can be mapped to DCAT themes, legislation, or excluded eg. internal themes.
      See dcat-core-keywords.xsl.
      Only consider others.
      -->
      <sch:let name="thesaurusToIgnore"
               value="('http://publications.europa.eu/resource/authority/data-theme',
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
    Define the applicable standard access constraints or, if not applicable, specify non-standard access constraints by selecting a value from the 'Access Constraints' list and indicating any 'Other Constraints'
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.dataset.access.constraints.mandatory-failure-fr" xml:lang="fr">
    Définissez les conditions d'accès standard applicables ou à défaut spécifiez des conditions d'accès non-standard en choisissant une valeur de la liste "Contraintes d'accès" et en mentionnant des "Autres contraintes"
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
   <sch:title xml:lang="en">Dataset - Access constraints are defined</sch:title>
   <sch:title xml:lang="fr">Dataset - Les contraintes d'accès sont définies</sch:title>
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

  <!-- Geospatial extent -->
  <sch:diagnostic id="rule.dcatap.geospatial-extent.recommended-failure-en" xml:lang="en">
   Define the resource's geospatial extent.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.geospatial-extent.recommended-failure-fr" xml:lang="fr">
    Définissez l'emprise géospatiale de la ressource.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.geospatial-extent.recommended-success-en" xml:lang="en">
    Geospatial extent found.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.geospatial-extent.recommended-success-fr" xml:lang="fr">
    Emprise géospatiale trouvée.
  </sch:diagnostic>

  <sch:pattern id="geospatial-extent">
    <sch:title xml:lang="en">Geospatial extent is defined</sch:title>
    <sch:title xml:lang="fr">L'emprise géographique est définie</sch:title>
    <sch:rule context="//*:MD_Metadata">

      <sch:let name="geospatialExtent"
               value="//*:extent/*/*:geographicElement/*"/>
      <sch:let name="hasGeospatialExtent"
               value="boolean(
                        $geospatialExtent[
                          gex:westBoundLongitude/gco:Decimal and
                          gex:eastBoundLongitude/gco:Decimal and
                          gex:southBoundLatitude/gco:Decimal and
                          gex:northBoundLatitude/gco:Decimal
                        ])"/>

      <sch:assert test="$hasGeospatialExtent"
                  diagnostics="rule.dcatap.geospatial-extent.recommended-failure-en rule.dcatap.geospatial-extent.recommended-failure-fr"/>
      <sch:report test="$hasGeospatialExtent"
                  diagnostics="rule.dcatap.geospatial-extent.recommended-success-en rule.dcatap.geospatial-extent.recommended-success-fr"/>
    </sch:rule>
    </sch:pattern>

      <!-- Temporal Extent -->
      <sch:diagnostic id="rule.dcatap.temporal-extent.recommended-failure-en" xml:lang="en">
       Define the resource's temporal extent.
      </sch:diagnostic>
      <sch:diagnostic id="rule.dcatap.temporal-extent.recommended-failure-fr" xml:lang="fr">
        Définissez l'étendue temporelle de la ressource.
      </sch:diagnostic>
      <sch:diagnostic id="rule.dcatap.temporal-extent.recommended-success-en" xml:lang="en">
                      Temporal extent found.
      </sch:diagnostic>
      <sch:diagnostic id="rule.dcatap.temporal-extent.recommended-success-fr" xml:lang="fr">
      Période temporelle trouvée.
      </sch:diagnostic>
     <sch:pattern id="temporal-extent" >
        <sch:title xml:lang="en">Temporal extent is defined</sch:title>
        <sch:title xml:lang="fr">L'étendue temporelle est définie</sch:title>
        <sch:rule
          context="//*:MD_Metadata[(*:metadataScope/*/*:resourceScope|*:hierarchyLevel)/*/@codeListValue != 'series']">

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

    <!-- Dataset Distribution-->
  <sch:diagnostic id="rule.dcatap.dataset.distribution.mandatory-failure-en" xml:lang="en">
      Add a download page, a direct download link, or a link to a visualization or download service
    </sch:diagnostic>
    <sch:diagnostic id="rule.dcatap.dataset.distribution.mandatory-failure-fr" xml:lang="fr">
      Ajoutez une page de téléchargement, un lien de téléchargement direct ou un lien vers un service de visualisation ou de téléchargement
    </sch:diagnostic>
    <sch:diagnostic id="rule.dcatap.dataset.distribution.mandatory-success-en"
                    xml:lang="en">
      Distribution URLs found:<sch:value-of select="concat(' ', string-join($distributions, ', '))"/>.
    </sch:diagnostic>
    <sch:diagnostic id="rule.dcatap.dataset.distribution.mandatory-success-fr"
                    xml:lang="fr">
      URL(s) de distribution encodées :<sch:value-of select="concat(' ', string-join($distributions, ', '))"/>.
    </sch:diagnostic>

    <sch:pattern id="dataset-distribution">
      <sch:title xml:lang="en">A distribution is defined</sch:title>
      <sch:title xml:lang="fr">Une distribution est définie</sch:title>

      <sch:rule context="//*:MD_Metadata[(*:metadataScope/*/*:resourceScope|*:hierarchyLevel)/*/@codeListValue = 'dataset']" >

        <sch:let name="distributions"
                 value="*:distributionInfo//*:onLine/*[*:linkage/(*:CharacterString|*:URL)/text() != ''][not(
                                          cit:function/*/@codeListValue = ('information', 'search', 'completeMetadata', 'browseGraphic', 'upload', 'emailService')
                                          or (not(cit:function/*/@codeListValue) and matches(*:protocol/*/text(), 'WWW:LINK.*')))]/*:linkage/(*:CharacterString|*:URL)"/>

        <sch:let name="hasOneOrMoreDistributions"
                 value="count($distributions) > 0"/>

        <sch:assert test="$hasOneOrMoreDistributions"
                    diagnostics="rule.dcatap.dataset.distribution.mandatory-failure-en rule.dcatap.dataset.distribution.mandatory-failure-fr"/>
        <sch:report test="$hasOneOrMoreDistributions"
                    diagnostics="rule.dcatap.dataset.distribution.mandatory-success-en rule.dcatap.dataset.distribution.mandatory-success-fr"/>
      </sch:rule>
  </sch:pattern>




  <sch:diagnostic id="rule.dcatap.distribution-has-size.failure-en" xml:lang="en">
    Distribution <sch:value-of select="$linkage"/>
    has no size and it is recommended to set it.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.distribution-has-size.failure-fr" xml:lang="fr">
    Taille du téléchargement manquante dans la distribution <sch:value-of select="$linkage"/>.
    Il est recommandé d'ajouter la taille du fichier de téléchargement en Mo.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.distribution-has-size.success-en"
                  xml:lang="en">
    Distribution <sch:value-of select="$linkage"/>
    size is <sch:value-of select="$size"/> Mo.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.distribution-has-size.success-fr"
                  xml:lang="fr">
    Taille du téléchargement pour <sch:value-of select="$linkage"/> est : <sch:value-of select="$size"/> Mo.
  </sch:diagnostic>


  <sch:diagnostic id="rule.dcatap.distribution-has-atomservice.failure-en" xml:lang="en">
    ATOM service not found, it is recommended to set it.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.distribution-has-atomservice.failure-fr" xml:lang="fr">
    Le service ATOM n'a pas été trouvé, il est recommandé de le définir.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.distribution-has-atomservice.success-en"
                  xml:lang="en">
    ATOM service found: <sch:value-of select="$atomService/root/nameObject/default"/>.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.distribution-has-atomservice.success-fr"
                  xml:lang="fr">
    Service ATOM encodé : <sch:value-of select="$atomService/root/resourceTitleObject/default"/>.
  </sch:diagnostic>

  <sch:pattern id="distribution">
    <sch:title>DCAT-AP (Distribution)</sch:title>

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

    </sch:rule>

  </sch:pattern>
</sch:schema>
