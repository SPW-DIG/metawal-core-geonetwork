<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:gn="http://www.fao.org/geonetwork"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:srv="http://www.isotc211.org/2005/srv"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                exclude-result-prefixes="#all">

  <!-- Remove all contact not having an email -->
  <xsl:template match="*[gmd:CI_ResponsibleParty
                         and count(gmd:CI_ResponsibleParty/gmd:contactInfo/*/gmd:address/*/gmd:electronicMailAddress[*/text() != '']) = 0]"
                priority="2"/>

  <!-- Remove all online source not using HTTP to conform with
  https://github.com/inspire-eu-validation/community/issues/95
  -->
  <xsl:template match="*[gmd:CI_OnlineResource
                         and count(gmd:CI_OnlineResource/gmd:linkage/gmd:URL[not(starts-with(text(), 'http'))]) > 0]"
                priority="2"/>

  <xsl:template match="gmd:date[
      gmd:CI_Date/gmd:dateType/*/@codeListValue != 'creation'
      and */gmd:dateType/*/@codeListValue != 'publication'
      and */gmd:dateType/*/@codeListValue != 'revision']" priority="2"/>

  <xsl:template match="@xlink:href[contains(., 'srv/api/records/') and not(contains(., '/formatters/'))]">
    <xsl:attribute name="xlink:href"
                   select="concat(., '/formatters/iso19139?output=xml')"/>
  </xsl:template>

  <!-- Remove geonet:* elements. -->
  <xsl:template match="gn:*" priority="2"/>

  <!-- Copy everything. -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
