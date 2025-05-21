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

  <!-- Geospatial extent -->
  <sch:diagnostic id="rule.dcatap.geospatial-extent.recommended-failure-en" xml:lang="en">
   Geospatial extent is recommended. Add a geospatial extent.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.geospatial-extent.recommended-failure-fr" xml:lang="fr">
    L'emprise geospatiale est recommendée. Ajoutez une emprise géospatiale.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.geospatial-extent.recommended-success-en" xml:lang="en">
                  Geospatial extent found.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.geospatial-extent.recommended-success-fr" xml:lang="fr">
  Emprise géospatiale trouvée.
  </sch:diagnostic>

  <!-- Temporal Extent -->
  <sch:diagnostic id="rule.dcatap.temporal-extent.recommended-failure-en" xml:lang="en">
   Temporal extent is recommended. Add a temporal extent.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.temporal-extent.recommended-failure-fr" xml:lang="fr">
    La période temporelle est recommendée. Ajoutez une période temporelle.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.temporal-extent.recommended-success-en" xml:lang="en">
                  Temporal extent found.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.temporal-extent.recommended-success-fr" xml:lang="fr">
  Période temporelle trouvée.
  </sch:diagnostic>

  <!-- Update Frequency -->
  <sch:diagnostic id="rule.dcatap.update-frequency.recommended-failure-en" xml:lang="en">
     Update Frequency is recommended. Add an update frequency.
    </sch:diagnostic>
    <sch:diagnostic id="rule.dcatap.update-frequency.recommended-failure-fr" xml:lang="fr">
      La fréquence de mise à jour est recommendée. Ajoutez une fréquence de mise à jour.
    </sch:diagnostic>
    <sch:diagnostic id="rule.dcatap.update-frequency.recommended-success-en" xml:lang="en">
                    Update Frequency found.
    </sch:diagnostic>
    <sch:diagnostic id="rule.dcatap.update-frequency.recommended-success-fr" xml:lang="fr">
    Fréquence de mise à jour trouvée.
    </sch:diagnostic>

    <!-- EU legislation keyword-->
    <sch:diagnostic id="rule.dcatap.eu-legislation-keyword.recommended-failure-en" xml:lang="en">
         EU legislation keyword is recommended. Add a keyword related to an European legislation.
    </sch:diagnostic>
    <sch:diagnostic id="rule.dcatap.eu-legislation-keyword.recommended-failure-fr" xml:lang="fr">
          Présence de mot-clé en lien avec une législation européenne recommendé. Ajoutez un mot-clé en lien avec une législation européenne.
    </sch:diagnostic>
    <sch:diagnostic id="rule.dcatap.eu-legislation-keyword.recommended-success-en" xml:lang="en">
                        EU legislation keyword found
    </sch:diagnostic>
    <sch:diagnostic id="rule.dcatap.eu-legislation-keyword.recommended-success-fr" xml:lang="fr">
        Mot-clé relatif à une législation européene trouvé.
    </sch:diagnostic>

  <sch:pattern>
    <sch:title>DCAT-AP - Recommended</sch:title>
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

      <!-- Temporal extent -->
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


      <!-- Update frequency -->
       <sch:let name="updateFrequency"
                value="//*:resourceMaintenance/*/*:maintenanceAndUpdateFrequency[*/@codeListValue != '']"/>

       <sch:let name="hasUpdateFrequency" value="count($updateFrequency) > 0" />

       <sch:assert test="$hasUpdateFrequency"
                   diagnostics="rule.dcatap.update-frequency.recommended-failure-en rule.dcatap.update-frequency.recommended-failure-fr"/>
       <sch:report test="$hasUpdateFrequency"
                   diagnostics="rule.dcatap.update-frequency.recommended-success-en rule.dcatap.update-frequency.recommended-success-fr"/>

      <!-- Update frequency -->
       <sch:let name="euLegislationKeyword"
                value="*:identificationInfo/*/*:descriptiveKeywords/*/*:keyword/*:Anchor[starts-with(@xlink:href, 'http://data.europa.eu/eli')]"/>
       <sch:let name="hasEuLegislationKeyword" value="count($euLegislationKeyword) > 0" />

       <sch:assert test="$hasEuLegislationKeyword"
                   diagnostics="rule.dcatap.eu-legislation-keyword.recommended-failure-en rule.dcatap.eu-legislation-keyword.recommended-failure-fr"/>
       <sch:report test="$hasEuLegislationKeyword"
                   diagnostics="rule.dcatap.eu-legislation-keyword.recommended-success-en rule.dcatap.eu-legislation-keyword.recommended-success-fr"/>

    </sch:rule>
    </sch:pattern>

    <!-- RULE Specific to Dataset-->

      <!-- Default Lang -->
      <sch:diagnostic id="rule.dcatap.dataset.lang.recommended-failure-en" xml:lang="en">
      Default language is recommended. Add a default language.
      </sch:diagnostic>
      <sch:diagnostic id="rule.dcatap.dataset.lang.recommended-failure-fr" xml:lang="fr">
       La présence d'une langue par défaut est recommandée. Ajoutez une langue par défaut.
      </sch:diagnostic>
      <sch:diagnostic id="rule.dcatap.dataset.lang.recommended-success-en" xml:lang="en">
      Default language found.
      </sch:diagnostic>
      <sch:diagnostic id="rule.dcatap.dataset.lang.recommended-success-fr" xml:lang="fr">
      Langue par défaut trouvée.
      </sch:diagnostic>

       <sch:diagnostic id="rule.dcatap.dataset.distribution.mandatory-failure-en" xml:lang="en">
          A Distribution is expected to be present. Add an online resource with a download protocol or
          function.
        </sch:diagnostic>
        <sch:diagnostic id="rule.dcatap.dataset.distribution.mandatory-failure-fr" xml:lang="fr">
          Une distribution est attendue. Ajoutez une ressource en ligne avec un protocole ou une fonction de téléchargement.
        </sch:diagnostic>
        <sch:diagnostic id="rule.dcatap.dataset.distribution.mandatory-success-en"
                        xml:lang="en">
          Distribution URLs found:<sch:value-of select="concat(' ', string-join($distributions, ', '))"/>.
        </sch:diagnostic>
        <sch:diagnostic id="rule.dcatap.dataset.distribution.mandatory-success-fr"
                        xml:lang="fr">
          URL(s) de distribution encodées :<sch:value-of select="concat(' ', string-join($distributions, ', '))"/>.
        </sch:diagnostic>


    <sch:pattern id="dataset">

    <sch:title>DCAT-AP - Recommended (Dataset)</sch:title>


     <sch:rule context="//*:MD_Metadata[(*:metadataScope/*/*:resourceScope|*:hierarchyLevel)/*/@codeListValue = 'dataset']" >

        <sch:let name="hasDefaultLang"
            value="boolean(*:defaultLocale/*/lan:language/*/@codeListValue != '')" />

        <sch:assert test="$hasDefaultLang"
                    diagnostics="rule.dcatap.dataset.lang.recommended-failure-en rule.dcatap.dataset.lang.recommended-failure-fr"/>
        <sch:report test="$hasDefaultLang"
                    diagnostics="rule.dcatap.dataset.lang.recommended-success-en rule.dcatap.dataset.lang.recommended-success-fr"/>

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
</sch:schema>
