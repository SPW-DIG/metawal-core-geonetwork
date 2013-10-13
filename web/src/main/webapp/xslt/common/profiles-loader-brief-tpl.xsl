<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:gn="http://www.fao.org/geonetwork"
  xmlns:saxon="http://saxon.sf.net/"
  extension-element-prefixes="saxon">
  <!-- 
    Load the brief template loader if the metadata has to be 
    converted to its brief format. Use the mode="brief" on each
    records to be converted.
    
    
    The profile loader using the oasis-catalog to load
  <schema>/layout/brief-tpl.xsl in each activated schema plugins.
  -->
  <xsl:include href="base-variables.xsl"/>
  <xsl:include href="functions-core.xsl"/>
  
  <xsl:include href="blanks/metadata-schema01/layout/brief-tpl.xsl"/>
  <xsl:include href="blanks/metadata-schema02/layout/brief-tpl.xsl"/>
  <xsl:include href="blanks/metadata-schema03/layout/brief-tpl.xsl"/>
  <xsl:include href="blanks/metadata-schema04/layout/brief-tpl.xsl"/>
  <xsl:include href="blanks/metadata-schema05/layout/brief-tpl.xsl"/>
  <xsl:include href="blanks/metadata-schema06/layout/brief-tpl.xsl"/>
  <xsl:include href="blanks/metadata-schema07/layout/brief-tpl.xsl"/>
  <xsl:include href="blanks/metadata-schema08/layout/brief-tpl.xsl"/>
  <xsl:include href="blanks/metadata-schema09/layout/brief-tpl.xsl"/>
  <xsl:include href="blanks/metadata-schema10/layout/brief-tpl.xsl"/>
  <xsl:include href="blanks/metadata-schema11/layout/brief-tpl.xsl"/>
  <xsl:include href="blanks/metadata-schema12/layout/brief-tpl.xsl"/>
  <xsl:include href="blanks/metadata-schema13/layout/brief-tpl.xsl"/>
  <xsl:include href="blanks/metadata-schema14/layout/brief-tpl.xsl"/>
  <xsl:include href="blanks/metadata-schema15/layout/brief-tpl.xsl"/>
  <xsl:include href="blanks/metadata-schema16/layout/brief-tpl.xsl"/>
  <xsl:include href="blanks/metadata-schema17/layout/brief-tpl.xsl"/>
  <xsl:include href="blanks/metadata-schema18/layout/brief-tpl.xsl"/>
  <xsl:include href="blanks/metadata-schema19/layout/brief-tpl.xsl"/>
  <xsl:include href="blanks/metadata-schema20/layout/brief-tpl.xsl"/>
  
  
  <xsl:template match="*" mode="brief">
    <xsl:variable name="schema" select="gn:info/schema"/>
    <xsl:variable name="briefSchemaCallBack" select="concat($schema,'Brief')"/>
    <saxon:call-template name="{$briefSchemaCallBack}"/>
  </xsl:template>
  
</xsl:stylesheet>
