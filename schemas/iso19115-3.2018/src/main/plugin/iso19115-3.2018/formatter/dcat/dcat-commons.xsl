<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:locn="http://www.w3.org/ns/locn#"
                xmlns:dcat="http://www.w3.org/ns/dcat#"
                exclude-result-prefixes="#all">

  <xsl:output method="xml"
              indent="yes"
              encoding="utf-8"
              cdata-section-elements="locn:geometry dcat:bbox"/>

  <xsl:param name="validation" as="xs:string" select="'false'"/>
  <xsl:param name="isValidating" as="xs:boolean" select="xs:boolean($validation)"/>

  <xsl:template name="create-namespaces">
    <xsl:namespace name="rdf" select="'http://www.w3.org/1999/02/22-rdf-syntax-ns#'"/>
    <xsl:namespace name="rdfs" select="'http://www.w3.org/2000/01/rdf-schema#'"/>
    <xsl:namespace name="owl" select="'http://www.w3.org/2002/07/owl#'"/>
    <xsl:namespace name="dct" select="'http://purl.org/dc/terms/'"/>
    <xsl:namespace name="dcat" select="'http://www.w3.org/ns/dcat#'"/>
    <xsl:namespace name="foaf" select="'http://xmlns.com/foaf/0.1/'"/>
    <xsl:namespace name="vcard" select="'http://www.w3.org/2006/vcard/ns#'"/>
  </xsl:template>
</xsl:stylesheet>
