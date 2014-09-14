<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gco="http://www.isotc211.org/2005/gco"
  xmlns:rw="http://metawal.wallonie.be/schemas/3.0" xmlns:geonet="http://www.fao.org/geonetwork"
  exclude-result-prefixes="gmd gco geonet">

  <!-- Compute title for all type of subtemplates. If none defined, 
  the title from the metadata title column is used. -->
  <xsl:template name="iso19139.rw-subtemplate">

    <xsl:variable name="subTemplateTitle">
      <xsl:apply-templates mode="iso19139.rw-subtemplate" select="."/>
    </xsl:variable>

    <title>
      <xsl:choose>
        <xsl:when test="normalize-space($subTemplateTitle)!=''">
          <xsl:value-of select="$subTemplateTitle"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="geonet:info/title"/>
        </xsl:otherwise>
      </xsl:choose>
    </title>
  </xsl:template>

  <!-- Subtemplate mode -->
  <xsl:template mode="iso19139.rw-subtemplate" match="rw:CI_ResponsibleParty">
    <xsl:message>##<xsl:copy-of select="."></xsl:copy-of></xsl:message>
    <xsl:variable name="langId">
      <xsl:call-template name="getLangId">
        <xsl:with-param name="langGui" select="/root/gui/language"/>
        <xsl:with-param name="md" select="."/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:apply-templates mode="localised" select="gmd:organisationName">
      <xsl:with-param name="langId" select="$langId"/>
    </xsl:apply-templates>

    <!-- Concatenate email or name or position -->
    <xsl:choose>
      <xsl:when
        test="count(gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress/gco:CharacterString[normalize-space(.)!='']) > 0">
        <xsl:text> > </xsl:text>
        <xsl:value-of
          select="string-join(gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress/gco:CharacterString, ',')"
        />
      </xsl:when>
      <xsl:when test="normalize-space(gmd:individualName/gco:CharacterString)!=''">
        <xsl:text> > </xsl:text>
        <xsl:apply-templates mode="localised" select="gmd:individualName">
          <xsl:with-param name="langId" select="$langId"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="normalize-space(gmd:positionName/gco:CharacterString)!=''">
        <xsl:text> > </xsl:text>
        <xsl:apply-templates mode="localised" select="gmd:positionName">
          <xsl:with-param name="langId" select="$langId"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise> </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template mode="iso19139.rw-subtemplate" match="*"/>

</xsl:stylesheet>
