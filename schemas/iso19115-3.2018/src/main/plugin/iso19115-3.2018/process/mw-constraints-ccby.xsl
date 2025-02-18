<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/2.0"
                xmlns:mri="http://standards.iso.org/iso/19115/-3/mri/1.0"
                xmlns:mco="http://standards.iso.org/iso/19115/-3/mco/1.0"
                xmlns:gcx="http://standards.iso.org/iso/19115/-3/gcx/1.0"
                xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
                xmlns:mdb="http://standards.iso.org/iso/19115/-3/mdb/2.0"
                xmlns:mcc="http://standards.iso.org/iso/19115/-3/mcc/1.0"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:util="java:org.fao.geonet.util.XslUtil"
                xmlns:gn="http://www.fao.org/geonetwork"
                xmlns:saxon="http://saxon.sf.net/"
                extension-element-prefixes="saxon"
                exclude-result-prefixes="#all">
  <xsl:import href="process-utility.xsl"/>

  <xsl:include href="../formatter/citation/base.xsl"/>
  <xsl:include href="../formatter/citation/common.xsl"/>

  <xsl:output indent="yes" method="xml"/>

  <xsl:variable name="configuration"
                select="/empty"/>

  <xsl:variable name="mw-constraints-ccby-loc">
    <msg id="add" xml:lang="eng">Replace constraints by CC-BY.</msg>
    <msg id="update" xml:lang="eng">Update citation in CC-BY constraint.</msg>
    <msg id="add" xml:lang="fre">Remplacer les contraintes d'accès et d'utilisation par CC-BY.</msg>
    <msg id="update" xml:lang="fre">Mettre à jour la citation dans la contrainte CC-BY.</msg>
  </xsl:variable>

  <xsl:template name="list-mw-constraints-ccby">
    <suggestion process="mw-constraints-ccby"/>
  </xsl:template>

  <xsl:variable name="ccByConstraint"
                select="//mri:resourceConstraints/*/mco:otherConstraints[gcx:Anchor/@xlink:href = 'https://creativecommons.org/licenses/by/4.0/']"/>

  <xsl:variable name="hasCcbyConstraints"
                select="count($ccByConstraint) > 0"/>

  <xsl:variable name="lastRevisionDate">
    <xsl:for-each select="//mdb:identificationInfo/*/mri:citation/*/cit:date/*[cit:dateType/*/@codeListValue = 'revision']/cit:date/gco:Date">
      <xsl:sort select="." order="descending"/>
      <xsl:if test="position() = 1">
        <xsl:value-of select="."/>
      </xsl:if>
    </xsl:for-each>
  </xsl:variable>

  <xsl:variable name="citationContainsLastRevisionDate"
                select="count(//$ccByConstraint/following-sibling::mco:otherConstraints[1][contains(gco:CharacterString, $lastRevisionDate)]) > 0"/>

  <xsl:template name="analyze-mw-constraints-ccby">
    <xsl:variable name="id"
                  select="generate-id(.)"/>

    <xsl:if test="not($hasCcbyConstraints)">
      <suggestion process="mw-constraints-ccby"
                  id="{concat($id, '-', position())}"
                  category="contentinfo"
                  target="metadata">
        <name><xsl:value-of select="gn:i18n($mw-constraints-ccby-loc, 'add', $guiLang)"/></name>
        <operational>true</operational>
        <params>{}</params>
      </suggestion>
    </xsl:if>

    <xsl:if test="$hasCcbyConstraints and $lastRevisionDate != '' and not($citationContainsLastRevisionDate)">
      <suggestion process="mw-constraints-ccby"
                  id="{concat($id, '-', position())}"
                  category="contentinfo"
                  target="metadata">
        <name><xsl:value-of select="gn:i18n($mw-constraints-ccby-loc, 'update', $guiLang)"/></name>
        <operational>true</operational>
        <params>{}</params>
      </suggestion>
    </xsl:if>
  </xsl:template>



  <xsl:variable name="metadataIdentifier"
                select="//mdb:MD_Metadata/mdb:metadataIdentifier[1]/*/mcc:code/gco:CharacterString"/>


  <xsl:template match="mco:otherConstraints[$hasCcbyConstraints and not($citationContainsLastRevisionDate)
                                          and starts-with(gco:CharacterString, 'Source : ')]">
                priority="2">
    <xsl:copy>
      <xsl:call-template name="build-citation"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="mri:resourceConstraints[not($hasCcbyConstraints)]"
                priority="2">
    <xsl:if test="not(preceding-sibling::mri:resourceConstraints)">
      <mri:resourceConstraints>
        <mco:MD_LegalConstraints>
          <mco:accessConstraints>
            <mco:MD_RestrictionCode
              codeList="http://standards.iso.org/iso/19115/resources/Codelists/cat/codelists.xml#MD_RestrictionCode"
              codeListValue="unrestricted"/>
          </mco:accessConstraints>
          <mco:otherConstraints>
            <gcx:Anchor
              xlink:href="http://inspire.ec.europa.eu/metadata-codelist/LimitationsOnPublicAccess/noLimitations">
              Pas de limitation d'accès public à cette donnée.
            </gcx:Anchor>
          </mco:otherConstraints>
        </mco:MD_LegalConstraints>
      </mri:resourceConstraints>
      <mri:resourceConstraints>
        <mco:MD_LegalConstraints>
          <mco:useConstraints>
            <mco:MD_RestrictionCode
              codeList="http://standards.iso.org/iso/19115/resources/Codelists/cat/codelists.xml#MD_RestrictionCode"
              codeListValue="licenceUnrestricted"/>
          </mco:useConstraints>
          <mco:otherConstraints>
            <gcx:Anchor xlink:href="https://creativecommons.org/licenses/by/4.0/">
              Licence CC-BY 4.0 : L’utilisateur peut utiliser et modifier les données pour
              en dériver une œuvre. Il peut publier les données et l’œuvre dérivée à condition de citer les sources.
            </gcx:Anchor>
          </mco:otherConstraints>
          <mco:otherConstraints>
            <xsl:call-template name="build-citation"/>
          </mco:otherConstraints>
        </mco:MD_LegalConstraints>
      </mri:resourceConstraints>
    </xsl:if>
  </xsl:template>

  <xsl:template name="build-citation">
    <xsl:variable name="citationInfo">
      <xsl:call-template name="get-iso19115-3.2018-citation">
        <xsl:with-param name="metadata" select="ancestor::mdb:MD_Metadata"/>
        <xsl:with-param name="language" select="'fre'"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="citationAsHtml">
      <xsl:apply-templates mode="citation" select="$citationInfo"/>
    </xsl:variable>

    <gco:CharacterString>
      Source : <xsl:value-of select="normalize-space($citationAsHtml)"/>
    </gco:CharacterString>
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
