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

<!-- Resource ID -->
  <sch:diagnostic id="rule.dcatap.resourceid.mandatory-failure-en" xml:lang="en">
    Add a global identifier for the resource (code + codespace in the form of a URL)
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.resourceid.mandatory-failure-fr" xml:lang="fr">
    Ajoutez un identifiant global pour la ressource (code + codespace sous forme d'url)
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.resourceid.mandatory-success-en"
                  xml:lang="en">Resource identifier found:
    <sch:value-of select="string-join($resourceIdentifier, ', ')"/>
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.resourceid.mandatory-success-fr"
                  xml:lang="fr">Identifiant de la ressource encodé:
    <sch:value-of select="string-join($resourceIdentifier, ', ')"/>
  </sch:diagnostic>
  <sch:pattern id="resource-identifier">
    <sch:title xml:lang="en">Resource MUST have a global identifier</sch:title>
    <sch:title xml:lang="fr">La ressource DOIT avoir un identifiant global</sch:title>
    <sch:rule context="//*:MD_Metadata">

      <sch:let name="resourceIdentifier"
               value="*:identificationInfo/*/*:citation/*/*:identifier/*[*:codeSpace/*[starts-with(text(), 'http')]]/*:code/*[text() != '']"/>
      <sch:let name="hasResourceIdentifier"
               value="count($resourceIdentifier) > 0"/>

      <sch:assert test="$hasResourceIdentifier"
                  diagnostics="rule.dcatap.resourceid.mandatory-failure-en rule.dcatap.resourceid.mandatory-failure-fr"/>
      <sch:report test="$hasResourceIdentifier"
                  diagnostics="rule.dcatap.resourceid.mandatory-success-en rule.dcatap.resourceid.mandatory-success-fr"/>
    </sch:rule>
    </sch:pattern>

    <!-- Resource TITLE-->
    <sch:diagnostic id="rule.dcatap.resourcetitle.mandatory-failure-en" xml:lang="en">
      Add resource name.
    </sch:diagnostic>
    <sch:diagnostic id="rule.dcatap.resourcetitle.mandatory-failure-fr" xml:lang="fr">
      Ajoutez le nom de la ressource.
    </sch:diagnostic>
    <sch:diagnostic id="rule.dcatap.resourcetitle.mandatory-success-en"
                    xml:lang="en">Resource name found:
      <sch:value-of select="$resourceTitle"/>
    </sch:diagnostic>
    <sch:diagnostic id="rule.dcatap.resourcetitle.mandatory-success-fr"
                    xml:lang="fr">Nom de la resource encodé:
      <sch:value-of select="$resourceTitle"/>
    </sch:diagnostic>
  <sch:pattern id="resource-title">
    <sch:title xml:lang="en">Resource MUST have a name</sch:title>
    <sch:title xml:lang="fr">La ressource DOIT avoir un nom</sch:title>
    <sch:rule context="//*:MD_Metadata">

      <sch:let name="resourceTitle"
               value="*:identificationInfo/*/*:citation/*/*:title/*[text() != '']"/>
      <sch:let name="hasResourceTitle"
               value="count($resourceTitle) > 0"/>

      <sch:assert test="$hasResourceTitle"
                  diagnostics="rule.dcatap.resourcetitle.mandatory-failure-en rule.dcatap.resourcetitle.mandatory-failure-fr"/>
      <sch:report test="$hasResourceTitle"
                  diagnostics="rule.dcatap.resourcetitle.mandatory-success-en rule.dcatap.resourcetitle.mandatory-success-fr"/>
    </sch:rule>
  </sch:pattern>

  <!-- Resource Abstract-->
  <sch:diagnostic id="rule.dcatap.resourceabstract.mandatory-failure-en" xml:lang="en">
    Add an abstract to the resource.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.resourceabstract.mandatory-failure-fr" xml:lang="fr">
    Ajoutez un résumé à la ressource.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.resourceabstract.mandatory-success-en"
                  xml:lang="en">Resource abstract found.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.resourceabstract.mandatory-success-fr"
                  xml:lang="fr">La resource a un résumé.
  </sch:diagnostic>
  <sch:pattern id="resource-abstract">
    <sch:title xml:lang="en">Resource MUST have an abstract</sch:title>
    <sch:title xml:lang="fr">La ressource DOIT avoir un descriptif</sch:title>
    <sch:rule context="//*:MD_Metadata[(*:metadataScope/*/*:resourceScope|*:hierarchyLevel)/*/@codeListValue != 'service']">
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

  <!-- Series - has dataset -->
  <sch:diagnostic id="rule.dcatap.series.has-dataset.mandatory-failure-en" xml:lang="en">
    Add a link between the series and its constituent datasets by assigning the series as a parent of the datasets.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.series.has-dataset.mandatory-failure-fr" xml:lang="fr">
    Ajoutez un lien entre la série et ses données constitutives en ajoutant la série comme parent à partir des fiches de données.
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
  <sch:pattern id="series-hasdataset">
         <sch:title xml:lang="en">At least one dataset MUST be part of the series</sch:title>
         <sch:title xml:lang="fr">Au moins une donnée DOIT faire partie de la série</sch:title>
    <sch:rule
      context="//*:MD_Metadata[(*:metadataScope/*/*:resourceScope|*:hierarchyLevel)/*/@codeListValue = 'series']">

      <sch:let name="associations"
               value="mdUtil:getAssociatedAsXml(mdb:metadataIdentifier/*/mcc:code/*/text())/relations"/>
      <sch:let name="children"
               value="$associations/children"/>
      <sch:let name="hasRelatedDataset"
               value="count($children) > 0"/>


      <sch:assert test="$hasRelatedDataset"
                  diagnostics="rule.dcatap.series.has-dataset.mandatory-failure-en rule.dcatap.series.has-dataset.mandatory-failure-fr"/>
      <sch:report test="$hasRelatedDataset"
                  diagnostics="rule.dcatap.series.has-dataset.mandatory-success-en rule.dcatap.series.has-dataset.mandatory-success-fr"/>
    </sch:rule>
  </sch:pattern>

  <!-- Distribution -->
  <sch:diagnostic id="rule.dcatap.has-download-page.mandatory-success-en"
                  xml:lang="en">
    <sch:value-of select="count($onlineResourceDownloadPages)"/>  download page(s) found:
    <sch:value-of select="string-join($onlineResourceDownloadPages, ', ')"/>
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.has-download-page.mandatory-success-fr"
                  xml:lang="fr">
    <sch:value-of select="count($onlineResourceDownloadPages)"/> page(s) de téléchargement encodée(s) :
    <sch:value-of select="string-join($onlineResourceDownloadPages, ', ')"/>
  </sch:diagnostic>

  <sch:diagnostic id="rule.dcatap.has-distribution.mandatory-success-en"
                  xml:lang="en">
    <sch:value-of select="count($onlineResourceMappedAsDistribution)"/>  distribution(s) found:
    <sch:value-of select="string-join($onlineResourceMappedAsDistribution, ', ')"/>
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.has-distribution.mandatory-success-fr"
                  xml:lang="fr">
    <sch:value-of select="count($onlineResourceMappedAsDistribution)"/> distribution(s) encodée(s) :
    <sch:value-of select="string-join($onlineResourceMappedAsDistribution, ', ')"/>
  </sch:diagnostic>

  <sch:diagnostic id="rule.dcatap.has-distribution-or-download-page-or-service.mandatory-failure-en" xml:lang="en">
   Add a download page, or a download link, or a service (viewing or download).
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.has-distribution-or-download-page-or-service.mandatory-failure-fr" xml:lang="fr">
    Ajoutez une page de téléchargement, un lien de téléchargement direct ou un lien vers un service de visualisation ou de téléchargement
    "adresse internet", "titre" et "description" pour la page de téléchargement.
  </sch:diagnostic>


  <!-- Diagnostic for NAME, description and URL combined -->
    <sch:diagnostic id="rule.dcatap.distribution-has-name-description-url.mandatory-failure-en" xml:lang="en">
      Complete the 'Internet address', 'Name', and 'Description' fields for the download page.
      <sch:value-of select="$linkage"/>
    </sch:diagnostic>
    <sch:diagnostic id="rule.dcatap.distribution-has-name-description-url.mandatory-failure-fr" xml:lang="fr">
      Complétez les informations "Adresse internet", "Nom" et "Description" pour la page de téléchargement.
      <sch:value-of select="$linkage"/>
    </sch:diagnostic>
    <sch:diagnostic id="rule.dcatap.distribution-has-name-description-url.mandatory-success-en"
                    xml:lang="en">
      Distribution <sch:value-of select="$linkage"/>
    </sch:diagnostic>
    <sch:diagnostic id="rule.dcatap.distribution-has-name-description-url.mandatory-success-fr"
                    xml:lang="fr">
      Distribution <sch:value-of select="$linkage"/>.
    </sch:diagnostic>

      <!-- Diagnostic for PROTOCOL, NAME, DESCRIPTION and URL combined -->
    <sch:diagnostic id="rule.dcatap.distribution-has-protocol-name-description-url.mandatory-failure-en" xml:lang="en">
      Complete the 'Internet address', 'Name', and 'Description' fields for the direct download link.
      <sch:value-of select="$linkage"/>
    </sch:diagnostic>
    <sch:diagnostic id="rule.dcatap.distribution-has-protocol-name-description-url.mandatory-failure-fr" xml:lang="fr">
      Complétez les informations "Adresse internet", "Nom" et "Description" pour le lien de téléchargement direct.
      <sch:value-of select="$linkage"/>
    </sch:diagnostic>
    <sch:diagnostic id="rule.dcatap.distribution-has-protocol-name-description-url.mandatory-success-en"
                    xml:lang="en">
      Distribution <sch:value-of select="$linkage"/>
    </sch:diagnostic>
    <sch:diagnostic id="rule.dcatap.distribution-has-protocol-name-description-url.mandatory-success-fr"
                    xml:lang="fr">
      Distribution <sch:value-of select="$linkage"/>.
    </sch:diagnostic>

  <!--TODO : remove diangnostic for separated name, edcription, url ? -->
  <sch:diagnostic id="rule.dcatap.distribution-has-name.mandatory-failure-en" xml:lang="en">
    Distribution
    <sch:value-of select="$linkage"/>
    has no name.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.distribution-has-name.mandatory-failure-fr" xml:lang="fr">
    Nom du fichier manquant dans la distribution <sch:value-of select="$linkage"/>.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.distribution-has-name.mandatory-success-en"
                  xml:lang="en">
    Distribution <sch:value-of select="$linkage"/>
    name is set to <sch:value-of select="$name"/>.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.distribution-has-name.mandatory-success-fr"
                  xml:lang="fr">
    Distribution <sch:value-of select="$linkage"/>. Nom du fichier encodé : <sch:value-of select="$name"/>.
  </sch:diagnostic>

  <sch:diagnostic id="rule.dcatap.distribution-has-description.mandatory-failure-en" xml:lang="en">
    Distribution <sch:value-of select="$linkage"/>
    has no description.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.distribution-has-description.mandatory-failure-fr" xml:lang="fr">
    Description du fichier manquant dans la distribution <sch:value-of select="$linkage"/>.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.distribution-has-description.mandatory-success-en"
                  xml:lang="en">
    Distribution <sch:value-of select="$linkage"/>
    description is set to <sch:value-of select="$description"/>.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.distribution-has-description.mandatory-success-fr"
                  xml:lang="fr">
    Distribution <sch:value-of select="$linkage"/>. Description encodée : <sch:value-of select="$description"/>.
  </sch:diagnostic>

  <sch:pattern id="distribution">
   <!-- TODO: add support for service-->
    <sch:title>DCAT-AP (Distribution)</sch:title>
    <sch:rule
      context="//*:MD_Metadata[(*:metadataScope/*/*:resourceScope|*:hierarchyLevel)/*/@codeListValue = 'dataset']/*:distributionInfo">

      <sch:let name="onlineResourceDownloadPages"
               value=".//*:onLine[*/*:protocol/*/text() = 'WWW:LINK' and */*:function/*/@codeListValue = 'download']/*/*:linkage/*[text() != '']"/>

      <sch:report test="exists($onlineResourceDownloadPages)"
                  diagnostics="rule.dcatap.has-download-page.mandatory-success-en rule.dcatap.has-download-page.mandatory-success-fr"/>


      <!-- TODO vérifier que linkage/*[text() != '']-->
      <sch:let name="onlineResourceMappedAsDistribution"
               value=".//*:onLine[
                                   not(*/*:protocol/*/text() = 'WWW:LINK' and */*:function/*/@codeListValue = 'download')
                                   and
                                   not(
                                    */*:function/*/@codeListValue = ('information', 'information.content', 'information.portrayal', 'information.lineage', 'information.qualitySpecification', 'information.qualityReport', 'search', 'completeMetadata', 'browseGraphic', 'upload', 'emailService')
                                    or (*/*:function/*/@codeListValue = 'browsing' and matches(*/*:protocol/*/text(), 'WWW:LINK.*'))
                                    or ((not(*/*:function/*) or */*:function/*/@codeListValue = '') and (matches(*/*:protocol/*/text(), 'WWW:LINK.*') or not(*/*:protocol/*) or */*:protocol/*/text() = ''))
                                   )
                                   and not(*/*:protocol/* = ('ESRI:REST', 'ESRI:REST-TILED', 'OGC:WMS', 'OGC:WMTS', 'OGC:WFS', 'OGC:WCS', 'atom:feed', 'INSPIRE atom', 'OGC API - Features'))
                                 ]/*/*:linkage/*[text() != '']"/>

      <sch:let name="hasDistribution"
               value="count($onlineResourceMappedAsDistribution) > 0"/>

      <sch:let name="hasDistributionOrDownloadPageOrService"
               value="(count($onlineResourceDownloadPages) + count($onlineResourceMappedAsDistribution)) > 0"/>

      <sch:report test="$hasDistribution"
                  diagnostics="rule.dcatap.has-distribution.mandatory-success-en rule.dcatap.has-distribution.mandatory-success-fr"/>

      <sch:assert test="$hasDistributionOrDownloadPageOrService"
                  diagnostics="rule.dcatap.has-distribution-or-download-page-or-service.mandatory-failure-en rule.dcatap.has-distribution-or-download-page-or-service.mandatory-failure-fr"/>

    </sch:rule>
    </sch:pattern>

    <!-- Direct DOWNLOAD Link -->
    <sch:pattern>
      <sch:title xml:lang="en">The information describing the direct download link MUST be completed.</sch:title>
      <sch:title xml:lang="fr">Les informations décrivant le lien de téléchargement DOIVENT être complétées</sch:title>
      <sch:rule context="//*:MD_Metadata[(*:metadataScope/*/*:resourceScope|*:hierarchyLevel)/*/@codeListValue = 'dataset']/*:distributionInfo//*:onLine[
                                   not(*/*:protocol/*/text() = 'WWW:LINK' and */*:function/*/@codeListValue = 'download')
                                   and
                                   not(
                                    */*:function/*/@codeListValue = ('information', 'information.content', 'information.portrayal', 'information.lineage', 'information.qualitySpecification', 'information.qualityReport', 'search', 'completeMetadata', 'browseGraphic', 'upload', 'emailService')
                                    or (*/*:function/*/@codeListValue = 'browsing' and matches(*/*:protocol/*/text(), 'WWW:LINK.*'))
                                    or ((not(*/*:function/*) or */*:function/*/@codeListValue = '') and (matches(*/*:protocol/*/text(), 'WWW:LINK.*') or not(*/*:protocol/*) or */*:protocol/*/text() = ''))
                                   )
                                   and not(*/*:protocol/* = ('ESRI:REST', 'ESRI:REST-TILED', 'OGC:WMS', 'OGC:WMTS', 'OGC:WFS', 'OGC:WCS', 'atom:feed', 'INSPIRE atom', 'OGC API - Features'))
                                 ]">

        <sch:let name="linkage"
                 value="*/*:linkage/*[text() != '']"/>
        <sch:let name="name"
                 value="*/*:name/*[text() != '']"/>
        <sch:let name="description"
                 value="*/*:description/*[text() != '']"/>
        <sch:let name="protocol"
                 value="*/*:protocol/*[text() != '']"/>

        <sch:assert test="exists($name) and exists($description) and exists($linkage) and matches($protocol, 'WWW:DOWNLOAD.*')"
                    diagnostics="rule.dcatap.distribution-has-protocol-name-description-url.mandatory-failure-en rule.dcatap.distribution-has-protocol-name-description-url.mandatory-failure-fr"/>
        <sch:report test="exists($name) and exists($description) and exists($linkage) and matches($protocol, 'WWW:DOWNLOAD.*')"
                    diagnostics="rule.dcatap.distribution-has-protocol-name-description-url.mandatory-success-en rule.dcatap.distribution-has-protocol-name-description-url.mandatory-success-fr"/>
      </sch:rule>
    </sch:pattern>

    <!-- DOWNLOAD Page -->
    <sch:pattern id="distribution-download-page">
      <sch:title xml:lang="en">The information describing the download page MUST be completed.</sch:title>
      <sch:title xml:lang="fr">Les informations décrivant la page de téléchargement DOIVENT être complétées</sch:title>

      <sch:rule context="//*:MD_Metadata[(*:metadataScope/*/*:resourceScope|*:hierarchyLevel)/*/@codeListValue = 'dataset']/*:distributionInfo//
                                          *:onLine[*/*:protocol/*/text() = 'WWW:LINK' and */*:function/*/@codeListValue = 'download']">

        <sch:let name="linkage"
                 value="*/*:linkage/*[text() != '']"/>
        <sch:let name="name"
                 value="*/*:name/*[text() != '']"/>
        <sch:let name="description"
                 value="*/*:description/*[text() != '']"/>


      <sch:assert test="exists($name) and exists($description) and exists($linkage)"
                  diagnostics="rule.dcatap.distribution-has-name-description-url.mandatory-failure-en rule.dcatap.distribution-has-name-description-url.mandatory-failure-fr"/>
      <sch:report test="exists($name) and exists($description) and exists($linkage)"
                  diagnostics="rule.dcatap.distribution-has-name-description-url.mandatory-success-en rule.dcatap.distribution-has-name-description-url.mandatory-success-fr"/>

      <!--
        <sch:assert test="exists($name)"
                    diagnostics="rule.dcatap.distribution-has-name.mandatory-failure-en rule.dcatap.distribution-has-name.mandatory-failure-fr"/>
        <sch:report test="exists($name)"
                    diagnostics="rule.dcatap.distribution-has-name.mandatory-success-en rule.dcatap.distribution-has-name.mandatory-success-fr"/>
        <sch:assert test="exists($description)"
                    diagnostics="rule.dcatap.distribution-has-description.mandatory-failure-en rule.dcatap.distribution-has-description.mandatory-failure-fr"/>
        <sch:report test="exists($description)"
                    diagnostics="rule.dcatap.distribution-has-description.mandatory-success-en rule.dcatap.distribution-has-description.mandatory-success-fr"/>

        -->
      </sch:rule>
  </sch:pattern>



  <sch:diagnostic id="rule.hvd.endpointurl.mandatory-failure-en" xml:lang="en">
    The root location or primary endpoint of the service (an IRI) is missing. Add an operation with a protocol which is
    not considered as an endpoint description
    (ie.<sch:value-of select="concat(' ', $endpointDescriptionProtocolsExpression)"/>) or a URL containing <sch:value-of select="$endpointDescriptionUrllExpression"/>.
  </sch:diagnostic>
  <sch:diagnostic id="rule.hvd.endpointurl.mandatory-failure-fr" xml:lang="fr">
    L'URL principale du service (un IRI) est manquant. Ajoutez une opération avec un protocole qui n'est pas une
    description de service
    (ie.<sch:value-of select="concat(' ', $endpointDescriptionProtocolsExpression)"/>) ou une URL contenant <sch:value-of select="$endpointDescriptionUrllExpression"/>.
  </sch:diagnostic>
  <sch:diagnostic id="rule.hvd.endpointurl.mandatory-success-en"
                  xml:lang="en">
    End point URL found:<sch:value-of select="concat(' ', string-join($endpointUrls, ', '))"/>.
  </sch:diagnostic>
  <sch:diagnostic id="rule.hvd.endpointurl.mandatory-success-fr"
                  xml:lang="fr">
    URL(s) du service encodées :<sch:value-of select="concat(' ', string-join($endpointUrls, ', '))"/>.
  </sch:diagnostic>


  <sch:pattern id="L'opération access point du service est défine">
    <sch:title xml:lang="en">Online resource: the service address MUST be provided</sch:title>
    <sch:title xml:lang="fr">Ressource en ligne : l'adresse du service DOIT être renseignée</sch:title>
    <sch:rule
      context="//*:MD_Metadata[(*:metadataScope/*/*:resourceScope|*:hierarchyLevel)/*/@codeListValue = 'service']">

      <!--
      endpoint URL	Resource
      1..*
      The root location or primary endpoint of the service (an IRI).
      The endpoint URL SHOULD be persistent. This means that publishers should do everything in their power
      to maintain the value stable and existing.
      E
      -->

      <sch:let name="endpointDescriptionUrllExpression"
               value="'GetCapabilities|WSDL'"/>
      <sch:let name="endpointDescriptionProtocolsExpression"
               value="'OpenAPI|Swagger|GetCapabilities|WSDL|Description'"/>
      <sch:let name="endpointUrls"
               value=".//*:containsOperations/*/*:connectPoint/*[not(
                                matches(*:protocol/(*:CharacterString|*:Anchor)/text(), $endpointDescriptionProtocolsExpression, 'i')
                                or matches(*:linkage/(*:CharacterString|*:Anchor)/text(), $endpointDescriptionUrllExpression, 'i')
                                or cit:function/*/@codeListValue = 'information')]/(*:linkage|*:URL)/*/text()"/>

      <sch:let name="hasOneOrMoreEndPointUrls"
               value="count($endpointUrls) > 0"/>

      <sch:assert test="$hasOneOrMoreEndPointUrls"
                  diagnostics="rule.hvd.endpointurl.mandatory-failure-en rule.hvd.endpointurl.mandatory-failure-fr"/>
      <sch:report test="$hasOneOrMoreEndPointUrls"
                  diagnostics="rule.hvd.endpointurl.mandatory-success-en rule.hvd.endpointurl.mandatory-success-fr"/>

    </sch:rule>
  </sch:pattern>
</sch:schema>
