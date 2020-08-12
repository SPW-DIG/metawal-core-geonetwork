<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:srv="http://standards.iso.org/iso/19115/-3/srv/2.1"
                xmlns:mds="http://standards.iso.org/iso/19115/-3/mds/2.0"
                xmlns:mcc="http://standards.iso.org/iso/19115/-3/mcc/1.0"
                xmlns:mri="http://standards.iso.org/iso/19115/-3/mri/1.0"
                xmlns:mrs="http://standards.iso.org/iso/19115/-3/mrs/1.0"
                xmlns:mrd="http://standards.iso.org/iso/19115/-3/mrd/1.0"
                xmlns:mdb="http://standards.iso.org/iso/19115/-3/mdb/2.0"
                xmlns:mrl="http://standards.iso.org/iso/19115/-3/mrl/2.0"
                xmlns:mrc="http://standards.iso.org/iso/19115/-3/mrc/2.0"
                xmlns:mmi="http://standards.iso.org/iso/19115/-3/mmi/1.0"
                xmlns:mco="http://standards.iso.org/iso/19115/-3/mco/1.0"
                xmlns:mdq="http://standards.iso.org/iso/19157/-2/mdq/1.0"
                xmlns:msr="http://standards.iso.org/iso/19115/-3/msr/2.0"
                xmlns:lan="http://standards.iso.org/iso/19115/-3/lan/1.0"
                xmlns:gcx="http://standards.iso.org/iso/19115/-3/gcx/1.0"
                xmlns:gex="http://standards.iso.org/iso/19115/-3/gex/1.0"
                xmlns:dqm="http://standards.iso.org/iso/19157/-2/dqm/1.0"
                xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/2.0"
                xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
                xmlns:mac="http://standards.iso.org/iso/19115/-3/mac/2.0"
                xmlns:gfc="http://standards.iso.org/iso/19110/gfc/1.1"
                xmlns:gts="http://www.isotc211.org/2005/gts"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:gml="http://www.opengis.net/gml/3.2"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:skos="http://www.w3.org/2004/02/skos/core#"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:gn="http://www.fao.org/geonetwork"
                xmlns:saxon="http://saxon.sf.net/"
                extension-element-prefixes="saxon"
                exclude-result-prefixes="#all">
  <xsl:output indent="yes" method="xml"/>

  <xsl:variable name="crsMap">
    <crs code="http://www.opengis.net/def/crs/EPSG/0/31370" label="Belge 1972 / Belgian Lambert 72 (EPSG:31370)" referenceSystemTypeCode="projected">EPSG:31370</crs>
    <crs code="31370" label="Belge 1972 / Belgian Lambert 72 (EPSG:31370)" referenceSystemTypeCode="projected">EPSG:31370</crs>
    <crs code="http://www.opengis.net/def/crs/EPSG/0/3035" label="ETRS89 / LAEA Europe (EPSG:3035)" referenceSystemTypeCode="projected">EPSG:3035</crs>
    <crs code="http://www.opengis.net/def/crs/EPSG/0/3812" label="ETRS89 / Belgian Lambert 2008 (EPSG:3812)" referenceSystemTypeCode="projected">EPSG:3812</crs>
    <crs code="http://www.opengis.net/def/crs/EPSG/0/2154" label="RGF93 / Lambert-93 (EPSG:2154)" referenceSystemTypeCode="projected">EPSG:2154</crs>
    <crs code="http://www.opengis.net/def/crs/EPSG/0/4258" label="ETRS89 (EPSG:4258)" referenceSystemTypeCode="geodeticGeographic2D">EPSG:4258</crs>
    <crs code="http://www.opengis.net/def/crs/EPSG/0/4326" label="WGS 84 (EPSG:4326)" referenceSystemTypeCode="geodeticGeographic2D">EPSG:4326</crs>
    <crs code="WGS 1984" label="WGS 84 (EPSG:4326)" referenceSystemTypeCode="geodeticGeographic2D">EPSG:4326</crs>
    <crs code="http://www.opengis.net/def/crs/EPSG/0/3857" label="WGS 84 / Pseudo-Mercator (EPSG:3857)" referenceSystemTypeCode="projected">EPSG:3857</crs>
    <crs code="http://www.opengis.net/def/crs/EPSG/0/5710" label="Ostend height (EPSG:5710)" referenceSystemTypeCode="vertical">EPSG:5710</crs>
  </xsl:variable>

  <xsl:template match="mdb:referenceSystemInfo">
    <xsl:variable name="currentCode" select=".//mcc:code/*/text()"/>
    <xsl:variable name="newCrs" select="$crsMap/crs[@code = $currentCode or text() = $currentCode]"/>
    <xsl:choose>
      <xsl:when test="$newCrs[1]">
        <mdb:referenceSystemInfo>
          <mrs:MD_ReferenceSystem>
            <mrs:referenceSystemIdentifier>
              <mcc:MD_Identifier>
                <mcc:code>
                  <gcx:Anchor xlink:href="{$newCrs[1]/@code}"><xsl:value-of select="$newCrs[1]/text()"/> </gcx:Anchor>
                </mcc:code>
                <mcc:description>
                  <gco:CharacterString><xsl:value-of select="$newCrs[1]/@label"/></gco:CharacterString>
                </mcc:description>
              </mcc:MD_Identifier>
            </mrs:referenceSystemIdentifier>
            <mrs:referenceSystemType>
              <mrs:MD_ReferenceSystemTypeCode codeList="http://standards.iso.org/iso/19139/resources/gmxCodelists.xml#MD_ReferenceSystemTypeCode"
                                              codeListValue="{$newCrs[1]/@referenceSystemTypeCode}"/>
            </mrs:referenceSystemType>
          </mrs:MD_ReferenceSystem>
        </mdb:referenceSystemInfo>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message>CRS not handled <xsl:value-of select="$currentCode"/> and removed.</xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="gn:*" priority="2"/>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
