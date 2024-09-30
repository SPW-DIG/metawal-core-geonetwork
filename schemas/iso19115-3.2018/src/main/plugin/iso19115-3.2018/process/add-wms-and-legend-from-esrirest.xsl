<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xmlns:mdb="http://standards.iso.org/iso/19115/-3/mdb/2.0"
  xmlns:mrd="http://standards.iso.org/iso/19115/-3/mrd/1.0"
  xmlns:mrc="http://standards.iso.org/iso/19115/-3/mrc/2.0"
  xmlns:mcc="http://standards.iso.org/iso/19115/-3/mcc/1.0"
  xmlns:mri="http://standards.iso.org/iso/19115/-3/mri/1.0"
  xmlns:mpc="http://standards.iso.org/iso/19115/-3/mpc/1.0"
  xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/2.0"
  xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
  xmlns:lan="http://standards.iso.org/iso/19115/-3/lan/1.0"
  xmlns:util="java:org.fao.geonet.util.XslUtil"
  xmlns:geonet="http://www.fao.org/geonetwork"
  exclude-result-prefixes="#all">


  <xsl:import href="process-utility.xsl"/>

  <xsl:param name="esriRestServiceUrl" select="''"/>
  <xsl:param name="addGeoportal2024UrlStyle" select="'1'"/>

  <xsl:variable name="wmsUrl"
                select="concat(replace($esriRestServiceUrl, '/rest/', '/'), '/WMSServer?request=GetCapabilities&amp;service=WMS')"/>
  <xsl:variable name="isWmsDefined"
                select="count(//mrd:onLine/*
                                [cit:protocol/*/text() = 'OGC:WMS'
                                and cit:linkage/*/text() = $wmsUrl]) > 0"/>

  <xsl:variable name="aduUrl"
                select="concat('https://geoportail.wallonie.be/walonmap/#ADU=', $esriRestServiceUrl)"/>
  <xsl:variable name="isAduDefined"
                select="count(//mrd:onLine/*
                                [cit:protocol/*/text() = 'WWW:LINK'
                                and cit:linkage/*/text() = $aduUrl]) > 0"/>


  <xsl:variable name="geoportalWallon2024urlEndPoint"
                      select="'https://geoportail.wallonie.be/walonmap#'"/>
  <xsl:variable name="geoportalWallon2024urlTemplate">
    <xsl:text>PANIER=[{"serviceId":"1","visible":true,"url":"{url}","label":"{title}","type":"AGS_DYNAMIC","metadataUrl":"https://geodata.wallonie.be/id/{uuid}"}]</xsl:text>
  </xsl:variable>

  <xsl:variable name="geoportalLinkRecordtitle"
                select="//mdb:MD_Metadata/mdb:identificationInfo/*/mri:citation/*/cit:title/gco:CharacterString"/>

  <xsl:variable name="geoportalLinkRecordUuid"
                select="//mdb:MD_Metadata/mdb:metadataIdentifier/*/mcc:code/gco:CharacterString"/>

  <xsl:variable name="geoportalWallon2024"
                select="concat($geoportalWallon2024urlEndPoint, encode-for-uri(replace(replace(replace(
                          $geoportalWallon2024urlTemplate, '\{url\}', $esriRestServiceUrl),
                          '\{title\}', replace(util:escapeForJson($geoportalLinkRecordtitle), '\\', '\\\\')),
                          '\{uuid\}', $geoportalLinkRecordUuid)))"/>

  <xsl:variable name="isGeoportalWallon2024Defined"
                select="count(//mrd:onLine/*
                                [cit:protocol/*/text() = 'WWW:LINK'
                                and cit:linkage/*/text() = $geoportalWallon2024]) > 0"/>

  <xsl:variable name="legendUrl"
                select="concat($esriRestServiceUrl, '/legend')"/>
  <xsl:variable name="isLegendDefined"
                select="count(//mdb:portrayalCatalogueInfo/*/
                                mpc:portrayalCatalogueCitation/*/cit:onlineResource/*
                                  [cit:linkage/*/text() = $legendUrl]) > 0"/>



  <!-- i18n information -->
  <xsl:variable name="add-wms-and-legend-from-esrirest-loc">
    <msg id="a" xml:lang="eng">Add WMS and legend links for ESRI REST service:</msg>
    <msg id="a" xml:lang="fre">Ajouter les liens vers le WMS, la légende et l'ADU pour le service ESRI REST :</msg>
    <msg id="legendLabel" xml:lang="eng">Layer legend</msg>
    <msg id="legendLabel" xml:lang="fre">Légende des couches de données</msg>
  </xsl:variable>

  <xsl:template name="list-add-wms-and-legend-from-esrirest">
    <suggestion process="add-wms-and-legend-from-esrirest"/>
  </xsl:template>


  <xsl:template name="analyze-add-wms-and-legend-from-esrirest">
    <xsl:param name="root"/>

    <xsl:variable name="esriRestUrls"
                  select="$root//mrd:onLine/*[cit:protocol/*/text() = 'ESRI:REST']/cit:linkage/*"/>

    <xsl:for-each select="$esriRestUrls">

      <xsl:variable name="wmsUrl"
                    select="concat(replace(., '/rest/', '/'), '/WMSServer?request=GetCapabilities&amp;service=WMS')"/>
      <xsl:variable name="isWmsDefined"
                    select="count($root//mrd:onLine/*
                                [cit:protocol/*/text() = 'OGC:WMS'
                                and cit:linkage/*/text() = $wmsUrl]) > 0"/>

      <xsl:variable name="aduUrl"
                    select="concat('https://geoportail.wallonie.be/walonmap/#ADU=', .)"/>
      <xsl:variable name="isAduDefined"
                    select="count($root//mrd:onLine/*
                                [cit:protocol/*/text() = 'WWW:LINK'
                                and cit:linkage/*/text() = $aduUrl]) > 0"/>


      <xsl:variable name="geoportalWallon2024"
                    select="concat($geoportalWallon2024urlEndPoint, encode-for-uri(replace(replace(replace(
                          $geoportalWallon2024urlTemplate, '\{url\}', current()),
                          '\{title\}', replace(util:escapeForJson($geoportalLinkRecordtitle), '\\', '\\\\')),
                          '\{uuid\}', $geoportalLinkRecordUuid)))"/>

      <xsl:variable name="isGeoportalWallon2024Defined"
                    select="count(//mrd:onLine/*
                                [cit:protocol/*/text() = 'WWW:LINK'
                                and cit:linkage/*/text() = $geoportalWallon2024]) > 0"/>

      <xsl:variable name="legendUrl"
                    select="concat(., '/legend')"/>
      <xsl:variable name="isLegendDefined"
                    select="count($root//mdb:portrayalCatalogueInfo/*/
                                mpc:portrayalCatalogueCitation/*/cit:onlineResource/*
                                  [cit:linkage/*/text() = $legendUrl]) > 0"/>

      <xsl:if test="not($isWmsDefined) or not($isAduDefined) or not($isLegendDefined) or not($isGeoportalWallon2024Defined)">
        <suggestion process="add-wms-and-legend-from-esrirest"
                    id="{generate-id()}"
                    category="online" target="onLine">
          <name>
            <xsl:value-of select="geonet:i18n($add-wms-and-legend-from-esrirest-loc, 'a', $guiLang)"/><xsl:value-of
            select="."/>
          </name>
          <operational>true</operational>
          <params>{"esriRestServiceUrl":{"type":"string", "defaultValue":"<xsl:value-of select="."/>"},
                   "addGeoportal2024UrlStyle":{"type":"boolean", "defaultValue":"1"}}
          </params>
        </suggestion>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>


  <!-- Do a copy of every nodes and attributes -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- Remove geonet:* elements. -->
  <xsl:template match="geonet:*" priority="2">
  </xsl:template>

  <xsl:template match="mrd:onLine[(not($isWmsDefined) or not($isAduDefined) or not($isGeoportalWallon2024Defined))
                                  and */cit:linkage/*/text() = $esriRestServiceUrl]"
                priority="99">
    <xsl:copy-of select="."/>
    <xsl:if test="not($isWmsDefined)">
      <mrd:onLine>
        <cit:CI_OnlineResource>
          <cit:linkage>
            <gco:CharacterString><xsl:value-of select="$wmsUrl"/></gco:CharacterString>
          </cit:linkage>
          <cit:protocol>
            <gco:CharacterString>OGC:WMS</gco:CharacterString>
          </cit:protocol>
          <cit:name>
            <gco:CharacterString>
              <xsl:value-of select="replace(*/cit:name/gco:CharacterString, 'ESRI-REST', 'WMS')"/>
            </gco:CharacterString>
          </cit:name>
          <cit:description>
            <gco:CharacterString>
              <xsl:value-of select="replace(*/cit:description/gco:CharacterString, 'ESRI-REST', 'WMS')"/>
            </gco:CharacterString>
          </cit:description>
          <cit:function>
            <cit:CI_OnLineFunctionCode
              codeList="http://standards.iso.org/iso/19115/resources/Codelists/cat/codelists.xml#CI_OnLineFunctionCode"
              codeListValue="browsing"/>
          </cit:function>
        </cit:CI_OnlineResource>
      </mrd:onLine>
    </xsl:if>


    <xsl:if test="not($isAduDefined) or not($isGeoportalWallon2024Defined)">
      <mrd:onLine>
        <cit:CI_OnlineResource>
          <cit:linkage>
            <gco:CharacterString>
              <xsl:value-of select="if($addGeoportal2024UrlStyle = '1') then $geoportalWallon2024 else $aduUrl"/>
            </gco:CharacterString>
          </cit:linkage>
          <cit:protocol>
            <gco:CharacterString>WWW:LINK</gco:CharacterString>
          </cit:protocol>
          <cit:applicationProfile>
            <gco:CharacterString>WalOnMap</gco:CharacterString>
          </cit:applicationProfile>
          <cit:name>
            <gco:CharacterString>Application WalOnMap - Toute la Wallonie à la carte</gco:CharacterString>
          </cit:name>
          <cit:description>
            <gco:CharacterString>Application cartographique du Geoportail (WalOnMap) qui permet de découvrir les données géographiques de la Wallonie.</gco:CharacterString>
          </cit:description>
          <cit:function>
            <cit:CI_OnLineFunctionCode codeList="http://standards.iso.org/iso/19115/resources/Codelists/cat/codelists.xml#CI_OnLineFunctionCode" codeListValue="browsing"/>
          </cit:function>
        </cit:CI_OnlineResource>
      </mrd:onLine>
    </xsl:if>
  </xsl:template>


  <xsl:template
    match="mdb:MD_Metadata[not($isLegendDefined)]"
    priority="2">

    <xsl:variable name="metadataLanguage"
                  select="//mdb:MD_Metadata/mdb:defaultLocale/
                              lan:PT_Locale/lan:language/lan:LanguageCode/@codeListValue"/>
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates
        select="mdb:metadataIdentifier|
                mdb:defaultLocale|
                mdb:parentMetadata|
                mdb:metadataScope|
                mdb:contact|
                mdb:dateInfo|
                mdb:metadataStandard|
                mdb:metadataProfile|
                mdb:alternativeMetadataReference|
                mdb:otherLocale|
                mdb:metadataLinkage|
                mdb:spatialRepresentationInfo|
                mdb:referenceSystemInfo|
                mdb:metadataExtensionInfo|
                mdb:identificationInfo|
                mdb:contentInfo|
                mdb:distributionInfo|
                mdb:dataQualityInfo|
                mdb:resourceLineage|
                mdb:portrayalCatalogueInfo"/>

      <mdb:portrayalCatalogueInfo>
        <mpc:MD_PortrayalCatalogueReference>
          <mpc:portrayalCatalogueCitation>
            <cit:CI_Citation>
              <cit:title>
                <gco:CharacterString><xsl:value-of select="geonet:i18n($add-wms-and-legend-from-esrirest-loc, 'legendLabel', $metadataLanguage)"/></gco:CharacterString>
              </cit:title>
              <cit:onlineResource>
                <cit:CI_OnlineResource>
                  <cit:linkage>
                    <gco:CharacterString>
                      <xsl:value-of select="$legendUrl"/>
                    </gco:CharacterString>
                  </cit:linkage>
                </cit:CI_OnlineResource>
              </cit:onlineResource>
            </cit:CI_Citation>
          </mpc:portrayalCatalogueCitation>
        </mpc:MD_PortrayalCatalogueReference>
      </mdb:portrayalCatalogueInfo>

      <xsl:apply-templates
        select="
                mdb:metadataConstraints|
                mdb:applicationSchemaInfo|
                mdb:metadataMaintenance|
                mdb:acquisitionInformation"/>

    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
