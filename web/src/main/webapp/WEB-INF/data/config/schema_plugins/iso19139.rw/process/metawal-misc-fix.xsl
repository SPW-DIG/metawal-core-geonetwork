<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:geonet="http://www.fao.org/geonetwork"
                xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                version="2.0"
                exclude-result-prefixes="#all">

  <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

  <xsl:param name="prefix" select="'http://metawal.wallonie.be/geonetwork/srv/fre/resources.get'"/>

  <!-- Do a copy of every nodes and attributes -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- Remove geonet:* elements. -->
  <xsl:template match="geonet:*" priority="2"/>

  <!-- Fix date stored in DateTime -->
  <xsl:template match="gco:DateTime[matches(text(), '^[0-9]{4}-[0-9]{2}-[0-9]{2}$')]"
                priority="2">
    <gco:Date>
      <xsl:value-of select="text()"/>
    </gco:Date>
  </xsl:template>

  <!-- Update INSPIRE theme thesaurus citation  -->
  <xsl:template match="gmd:thesaurusName[gmd:CI_Citation/gmd:title/gco:CharacterString = 'INSPIRE themes']"
                priority="2">
    <gmd:thesaurusName>
      <gmd:CI_Citation>
        <gmd:title>
          <gco:CharacterString>GEMET - INSPIRE themes, version 1.0</gco:CharacterString>
        </gmd:title>
        <gmd:date>
          <gmd:CI_Date>
            <gmd:date>
              <gco:Date>2008-06-01</gco:Date>
            </gmd:date>
            <gmd:dateType>
              <gmd:CI_DateTypeCode
                      codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_DateTypeCode"
                      codeListValue="publication"/>
            </gmd:dateType>
          </gmd:CI_Date>
        </gmd:date>
      </gmd:CI_Citation>
    </gmd:thesaurusName>
  </xsl:template>

  <!-- Update theme Wallon thesaurus citation  -->
  <xsl:template match="gmd:thesaurusName[gmd:CI_Citation/gmd:title/gco:CharacterString = 'Thèmes du géoportail wallon']"
                priority="2">
    <gmd:thesaurusName>
      <gmd:CI_Citation>
        <gmd:title>
          <gco:CharacterString>Thèmes du géoportail wallon, version 1.0</gco:CharacterString>
        </gmd:title>
        <gmd:date>
          <gmd:CI_Date>
            <gmd:date>
              <gco:Date>2012-02-19</gco:Date>
            </gmd:date>
            <gmd:dateType>
              <gmd:CI_DateTypeCode
                      codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_DateTypeCode"
                      codeListValue="publication"/>
            </gmd:dateType>
          </gmd:CI_Date>
        </gmd:date>
      </gmd:CI_Citation>
    </gmd:thesaurusName>
  </xsl:template>

  <!-- Remove small thumbnail -->
  <xsl:template match="gmd:graphicOverview[
                          contains(gmd:MD_BrowseGraphic/gmd:fileName/gco:CharacterString, '_s.')]"
                priority="3"/>

  <!-- Set complete URL for thumbnail -->
  <xsl:template match="gmd:graphicOverview"
                priority="2">
    <xsl:copy>
      <gmd:MD_BrowseGraphic>
        <xsl:variable name="fileNameInRecord" select="gmd:MD_BrowseGraphic/gmd:fileName/gco:CharacterString"/>
        <xsl:variable name="fileName">
          <xsl:choose>
            <xsl:when test="contains($fileNameInRecord, 'fname=')">
              <!-- We have an URL -->
              <xsl:value-of select="substring-after($fileNameInRecord, 'fname=')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$fileNameInRecord"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="fileType" select="gmd:MD_BrowseGraphic/gmd:fileType/gco:CharacterString"/>
        <xsl:variable name="identifier" select="/*/gmd:fileIdentifier/gco:CharacterString"/>

        <gmd:fileName>
          <gco:CharacterString>
            <xsl:value-of
                    select="concat($prefix, '?uuid=',
                          $identifier, '&amp;fname=', normalize-space($fileName))"/>
          </gco:CharacterString>
        </gmd:fileName>
        <xsl:copy-of select="gmd:MD_BrowseGraphic/gmd:fileDescription"/>
        <xsl:copy-of select="gmd:MD_BrowseGraphic/gmd:fileType"/>
      </gmd:MD_BrowseGraphic>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
