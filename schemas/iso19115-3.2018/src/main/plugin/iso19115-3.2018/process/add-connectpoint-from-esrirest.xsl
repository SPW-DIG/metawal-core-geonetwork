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

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:geonet="http://www.fao.org/geonetwork"
                xmlns:mda="http://standards.iso.org/iso/19115/-3/mda/1.0"
                xmlns:srv="http://standards.iso.org/iso/19115/-3/srv/2.1"
                xmlns:gcx="http://standards.iso.org/iso/19115/-3/gcx/1.0"
                xmlns:mds="http://standards.iso.org/iso/19115/-3/mds/2.0"
                xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
                xmlns:gex="http://standards.iso.org/iso/19115/-3/gex/1.0"
                xmlns:cat="http://standards.iso.org/iso/19115/-3/cat/1.0"
                xmlns:mex="http://standards.iso.org/iso/19115/-3/mex/1.0"
                xmlns:mdt="http://standards.iso.org/iso/19115/-3/mdt/2.0"
                xmlns:mdb="http://standards.iso.org/iso/19115/-3/mdb/2.0"
                xmlns:mmi="http://standards.iso.org/iso/19115/-3/mmi/1.0"
                xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/2.0"
                xmlns:mpc="http://standards.iso.org/iso/19115/-3/mpc/1.0"
                xmlns:mcc="http://standards.iso.org/iso/19115/-3/mcc/1.0"
                xmlns:mdq="http://standards.iso.org/iso/19157/-2/mdq/1.0"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:mac="http://standards.iso.org/iso/19115/-3/mac/2.0"
                xmlns:mri="http://standards.iso.org/iso/19115/-3/mri/1.0"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:mrc="http://standards.iso.org/iso/19115/-3/mrc/2.0"
                xmlns:mrl="http://standards.iso.org/iso/19115/-3/mrl/2.0"
                xmlns:gfc="http://standards.iso.org/iso/19110/gfc/1.1"
                xmlns:mrs="http://standards.iso.org/iso/19115/-3/mrs/1.0"
                xmlns:mrd="http://standards.iso.org/iso/19115/-3/mrd/1.0"
                xmlns:gml="http://www.opengis.net/gml/3.2"
                xmlns:mco="http://standards.iso.org/iso/19115/-3/mco/1.0"
                xmlns:msr="http://standards.iso.org/iso/19115/-3/msr/2.0"
                xmlns:mas="http://standards.iso.org/iso/19115/-3/mas/1.0"
                xmlns:lan="http://standards.iso.org/iso/19115/-3/lan/1.0"
                xmlns:math="http://exslt.org/math"
                version="2.0"
                exclude-result-prefixes="#all">

  <xsl:import href="process-utility.xsl"/>

  <!-- i18n information -->
  <xsl:variable name="connectpoint-from-esrirest-loc">
    <msg id="a" xml:lang="eng">ESRI REST service </msg>
    <msg id="b" xml:lang="eng"> is described in online resource section. Run to add connect point.
    </msg>
    <msg id="a" xml:lang="fre">Le service ESRI REST </msg>
    <msg id="b" xml:lang="fre"> est décrit dans la section resource en ligne. Exécuter cette ajouter l'adresse de connexion.
    </msg>
    <msg id="connectPoint" xml:lang="eng">ESRI-REST View service</msg>
    <msg id="connectPoint" xml:lang="fre">Service de visualisation ESRI-REST</msg>
    <msg id="connectPointDesc" xml:lang="eng">Service connect point URL</msg>
    <msg id="connectPointDesc" xml:lang="fre">Adresse de connexion au service de visualisation ESRI-REST.</msg>
  </xsl:variable>

  <!-- Process parameters and variables-->
  <xsl:param name="esriRestServiceUrlForConnectPoint"/>

  <xsl:template name="list-add-connectpoint-from-esrirest">
    <suggestion process="add-connectpoint-from-esrirest"/>
  </xsl:template>


  <!-- Analyze the metadata record and return available suggestion
    for that process -->
  <xsl:template name="analyze-add-connectpoint-from-esrirest">
    <xsl:param name="root"/>
    <xsl:variable name="onlineResources"
                  select="$root//mrd:onLine/*[
                                  contains(cit:protocol/gco:CharacterString, 'ESRI:REST')
                                  and normalize-space(cit:linkage/gco:CharacterString) != '']"/>
    <xsl:variable name="srv"
                  select="count($root//*[local-name(.) = 'SV_ServiceIdentification'
                          or contains(@gco:isoType, 'SV_ServiceIdentification')]) > 0"/>

    <xsl:if test="$srv">
      <xsl:for-each select="$onlineResources">
        <xsl:variable name="url"
                      select="normalize-space(cit:linkage/gco:CharacterString)"/>
        <xsl:variable name="dontHaveOperation"
                      select="count($root//srv:containsOperations[
                        */srv:connectPoint/*/cit:linkage/*/text() = $url]) = 0"/>

        <xsl:if test="$dontHaveOperation">
          <suggestion process="add-connectpoint-from-esrirest" id="{generate-id()}" category="onlineSrc"
                      target="gex:extent">
            <name>
              <xsl:value-of select="geonet:i18n($connectpoint-from-esrirest-loc, 'a', $guiLang)"/><xsl:value-of
              select="./cit:linkage/gco:CharacterString"
            /><xsl:value-of select="geonet:i18n($connectpoint-from-esrirest-loc, 'b', $guiLang)"/>
            </name>
            <operational>true</operational>
            <params>{
              "esriRestServiceUrlForConnectPoint":{"type":"string", "defaultValue":"<xsl:value-of
                select="$url"/>"}
              }
            </params>
          </suggestion>
        </xsl:if>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>


  <!-- Processing templates -->
  <!-- Do a copy of every nodes and attributes -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- Remove geonet:* elements. -->
  <xsl:template match="geonet:*" priority="2"/>


  <xsl:template
    match="mdb:identificationInfo/*"
    priority="2">

    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates select="mri:citation"/>
      <xsl:apply-templates select="mri:abstract"/>
      <xsl:apply-templates select="mri:purpose"/>
      <xsl:apply-templates select="mri:credit"/>
      <xsl:apply-templates select="mri:status"/>
      <xsl:apply-templates select="mri:pointOfContact"/>
      <xsl:apply-templates select="mri:spatialRepresentationType"/>
      <xsl:apply-templates select="mri:spatialResolution"/>
      <xsl:apply-templates select="mri:temporalResolution"/>
      <xsl:apply-templates select="mri:topicCategory"/>
      <xsl:apply-templates select="mri:extent"/>
      <xsl:apply-templates select="mri:additionalDocumentation"/>
      <xsl:apply-templates select="mri:processingLevel"/>
      <xsl:apply-templates select="mri:resourceMaintenance"/>
      <xsl:apply-templates select="mri:graphicOverview"/>
      <xsl:apply-templates select="mri:resourceFormat"/>
      <xsl:apply-templates select="mri:descriptiveKeywords"/>
      <xsl:apply-templates select="mri:resourceSpecificUsage"/>
      <xsl:apply-templates select="mri:resourceConstraints"/>
      <xsl:apply-templates select="mri:associatedResource"/>
      <xsl:apply-templates select="mri:defaultLocale"/>
      <xsl:apply-templates select="mri:otherLocale"/>
      <xsl:apply-templates select="mri:environmentDescription"/>
      <xsl:apply-templates select="mri:supplementalInformation"/>

      <xsl:apply-templates select="srv:serviceType
                                  |srv:serviceTypeVersion
                                  |srv:accessProperties
                                  |srv:couplingType
                                  |srv:coupledResource
                                  |srv:operatedDataset
                                  |srv:profile
                                  |srv:serviceStandard
                                  |srv:containsOperations
      "/>

      <xsl:if test="count(srv:containsOperations[
                      */srv:connectPoint/*/cit:linkage/*/text() = $esriRestServiceUrlForConnectPoint]) = 0">
        <srv:containsOperations>
          <srv:SV_OperationMetadata>
            <srv:operationName>
              <gco:CharacterString>GetCapabilities</gco:CharacterString>
            </srv:operationName>
            <srv:distributedComputingPlatform>
              <srv:DCPList codeList="http://standards.iso.org/iso/19115/resources/Codelists/cat/codelists.xml#DCPList" codeListValue="WebServices"/>
            </srv:distributedComputingPlatform>
            <srv:connectPoint>
              <cit:CI_OnlineResource>
                <cit:linkage>
                  <gco:CharacterString><xsl:value-of select="$esriRestServiceUrlForConnectPoint"/></gco:CharacterString>
                </cit:linkage>
                <cit:protocol>
                  <gco:CharacterString>ESRI:REST</gco:CharacterString>
                </cit:protocol>
                <cit:name>
                  <gco:CharacterString><xsl:value-of select="geonet:i18n($connectpoint-from-esrirest-loc, 'connectPoint', $guiLang)"/></gco:CharacterString>
                </cit:name>
                <cit:description>
                  <gco:CharacterString><xsl:value-of select="geonet:i18n($connectpoint-from-esrirest-loc, 'connectPointDesc', $guiLang)"/></gco:CharacterString>
                </cit:description>
                <cit:function>
                  <cit:CI_OnLineFunctionCode codeList="http://standards.iso.org/iso/19115/resources/Codelists/cat/codelists.xml#CI_OnLineFunctionCode" codeListValue=""/>
                </cit:function>
              </cit:CI_OnlineResource>
            </srv:connectPoint>
          </srv:SV_OperationMetadata>
        </srv:containsOperations>
      </xsl:if>

      <xsl:apply-templates select="srv:operatesOn
                                  |srv:containsChain
      "/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
