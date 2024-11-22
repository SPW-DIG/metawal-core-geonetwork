<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/2.0"
                xmlns:gcx="http://standards.iso.org/iso/19115/-3/gcx/1.0"
                xmlns:lan="http://standards.iso.org/iso/19115/-3/lan/1.0"
                xmlns:mcc="http://standards.iso.org/iso/19115/-3/mcc/1.0"
                xmlns:mdb="http://standards.iso.org/iso/19115/-3/mdb/2.0"
                xmlns:mri="http://standards.iso.org/iso/19115/-3/mri/1.0"
                xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:gn="http://www.fao.org/geonetwork"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:util="java:org.fao.geonet.util.XslUtil"
                exclude-result-prefixes="#all">

  <!-- Refresh catalog thesaurus information (dates, title) for each keyword blocks.
  eg.
  http://localhost:8080/geonetwork/srv/api/registries/vocabularies/keyword?thesaurus=external.theme.infraSIG&transformation=to-iso19115-3.2018-keyword-with-anchor&id=

  -->
  <xsl:output indent="yes" method="xml"/>

  <xsl:variable name="mainLanguage" as="xs:string?"
                select="mdb:MD_Metadata/mdb:defaultLocale/lan:PT_Locale/
                            lan:language/lan:LanguageCode/
                              @codeListValue[normalize-space(.) != '']"/>

  <xsl:template match="mri:MD_Keywords[starts-with(mri:thesaurusName/*/cit:identifier/*/mcc:code/*/text(), 'geonetwork.thesaurus.')]">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="mri:keyword"/>
      <xsl:apply-templates select="mri:type"/>
      <xsl:call-template name="update-thesaurus-block"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template name="update-thesaurus-block">
    <xsl:variable name="thesaurusId"
                  select="substring-after(mri:thesaurusName/*/cit:identifier/*/mcc:code/*/text(), 'geonetwork.thesaurus.')"/>

    <xsl:variable name="thesaurus"
                  select="document(concat(util:getSiteUrl(), '/srv/api/registries/vocabularies/keyword?thesaurus=', $thesaurusId, '&amp;transformation=to-iso19115-3.2018-keyword-with-anchor&amp;id='))"/>

    <xsl:copy-of select="($thesaurus/mri:descriptiveKeywords/*/mri:thesaurusName, mri:thesaurusName)[1]"/>
  </xsl:template>

  <xsl:template match="gn:*" priority="2"/>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
