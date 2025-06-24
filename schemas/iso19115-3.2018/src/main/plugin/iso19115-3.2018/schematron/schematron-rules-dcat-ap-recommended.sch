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
