<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:exslt="http://exslt.org/common" xmlns:geonet="http://www.fao.org/geonetwork"
  xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:srv="http://www.isotc211.org/2005/srv"
  xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gmx="http://www.isotc211.org/2005/gmx" 
  version="2.0" exclude-result-prefixes="exslt">
  
  <xsl:import href="../../iso19139/process/process-utility.xsl"/>
  
  <!-- i18n information -->
  <xsl:variable name="metawal-check-resource-id-loc">
    <msg id="a" xml:lang="eng">Current record does not contain resource identifier. Compute resource identifier from metadata record identifier.</msg>
    <msg id="a" xml:lang="fre">Cette fiche ne contient pas d'identifiant pour la ressource. Calculer l'identifiant à partir de l'identifiant de la fiche.</msg>
  </xsl:variable>
  
  <!-- The UI language. Thesaurus search is made according to GUI language -->
  <xsl:param name="lang" select="'eng'"/>
  
  <xsl:variable name="codeSpace-url" select="'http://metawal.wallonie.be/resources/id/'"/>
  
  
  <xsl:template name="list-metawal-check-resource-id">
    <suggestion process="metawal-check-resource-id"/>
  </xsl:template>
  
  
  
  <!-- Analyze the metadata record and return available suggestion
      for that process -->
  <xsl:template name="analyze-metawal-check-resource-id">
    <xsl:param name="root"/>
    
    <xsl:variable name="hasResourceId"
      select="count($root//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/
        gmd:CI_Citation/gmd:identifier/*/gmd:code[gco:CharacterString != '']) > 0"/>
    
    <xsl:if test="not($hasResourceId)">
      <suggestion process="metawal-check-resource-id" id="{generate-id()}" category="identification" target="identification">
        <name><xsl:value-of select="geonet:i18n($metawal-check-resource-id-loc, 'a', $guiLang)"/></name>
        <operational>true</operational>
      </suggestion>
    </xsl:if>
    
  </xsl:template>
  
  
  
  
  <!-- Do a copy of every nodes and attributes -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <!-- Remove geonet:* elements. -->
  <xsl:template match="geonet:*" priority="2"/>
  
  <xsl:template
    match="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/
    gmd:CI_Citation"
    priority="2">
    
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:copy-of
        select="gmd:title|
        gmd:alternateTitle|
        gmd:date|
        gmd:edition|
        gmd:editionDate"/>
      
      <xsl:message>##<xsl:copy-of select="/"/></xsl:message>
      <!-- Create resource identifier based on metadata record identifier -->
      <gmd:identifier>
        <gmd:RS_Identifier>
          <gmd:code>
            <gco:CharacterString><xsl:value-of select="/*/gmd:fileIdentifier/gco:CharacterString"/></gco:CharacterString>
          </gmd:code>
          <gmd:codeSpace>
            <gco:CharacterString><xsl:value-of select="$codeSpace-url"/></gco:CharacterString>
          </gmd:codeSpace>
        </gmd:RS_Identifier>
      </gmd:identifier>
      
      <xsl:copy-of
        select="gmd:citedResponsibleParty|
        gmd:presentationForm|
        gmd:series|
        gmd:otherCitationDetails|
        gmd:collectiveTitle|
        gmd:ISBN|
        gmd:ISSN"/>
      
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>