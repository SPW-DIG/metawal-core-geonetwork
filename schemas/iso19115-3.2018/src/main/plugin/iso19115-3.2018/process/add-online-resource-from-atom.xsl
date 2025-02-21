<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:atom="http://www.w3.org/2005/Atom"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:geonet="http://www.fao.org/geonetwork"
                xmlns:mdb="http://standards.iso.org/iso/19115/-3/mdb/2.0"
                xmlns:mrd="http://standards.iso.org/iso/19115/-3/mrd/1.0"
                xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/2.0"
                xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
                xmlns:mcc="http://standards.iso.org/iso/19115/-3/mcc/1.0"
                version="2.0">

  <xsl:import href="process-utility.xsl"/>


  <xsl:param name="atomfeedUrl" select="''"/>
  <xsl:variable name="uuid" select="/mdb:MD_Metadata/mdb:metadataIdentifier[position() = 1]/mcc:MD_Identifier/mcc:code/gco:CharacterString"/>
  <xsl:variable name="remoteAtomfeed" select="if ($atomfeedUrl != '' ) then document($atomfeedUrl) else ''"/>
  <xsl:variable name="atomLink"
                select="if ($atomfeedUrl != '' ) then $remoteAtomfeed/atom:feed/atom:entry/atom:link[@type='application/atom+xml' and contains(@href, $uuid)]/@href else ''"/>
  <xsl:variable name="remoteAtomDataset"
                select="if ($atomLink != '') then document($remoteAtomfeed/atom:feed/atom:entry/atom:link[@type='application/atom+xml' and contains(@href, $uuid)]/@href) else ''"/>


  <xsl:variable name="atomfeed-registration-loc">
    <msg id="a" xml:lang="eng">Add online resource from atom feed:</msg>
    <msg id="a" xml:lang="fre">Ajouter resource depuis atom feed:</msg>
  </xsl:variable>

  <xsl:template name="list-add-online-resource-from-atom">
    <suggestion process="add-online-resource-from-atom"/>
  </xsl:template>

  <xsl:template name="analyze-add-online-resource-from-atom">
    <xsl:param name="root"/>

    <xsl:variable name="services"
                  select="distinct-values($root//mdb:distributionInfo//mrd:onLine/*[
                            contains(cit:protocol/*, 'atom:feed')]
                              /cit:linkage/*/text())"/>

    <xsl:variable name="id"
                  select="generate-id(.)"/>

    <xsl:for-each select="$services">
      <xsl:variable name="url"
                    select="."/>
      <xsl:variable name="isRegistered" select="false()"/>
      <xsl:if test="not($isRegistered)">
        <suggestion process="add-online-resource-from-atom"
                    id="{concat($id, '-', position())}"
                    category="contentinfo"
                    target="metadata">
          <name>
            <xsl:value-of select="geonet:i18n($atomfeed-registration-loc, 'a', $guiLang)"/><xsl:value-of select="."/>
          </name>
          <operational>true</operational>
          <params>{"atomfeedUrl":{"type":"text", "defaultValue":"<xsl:value-of select="."/>"}}
          </params>
        </suggestion>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>


  <!-- Do a copy of every nodes and attributes -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- Remove geonet:* elements. -->
  <xsl:template match="geonet:*" priority="2"/>

  <!-- Remove all transfer options having a linkage pointing to the current atom feed to analyze -->
  <xsl:template
    match="mrd:MD_Distribution/mrd:transferOptions[*/mrd:onLine/*/cit:linkage/gco:CharacterString = $remoteAtomDataset/atom:feed/atom:entry/atom:link[@rel='enclosure']/@href]"
    priority="2"/>


  <!-- Insert into the first distribution section, the atom feed links -->
  <xsl:template match="mdb:MD_Metadata/mdb:distributionInfo[1]/mrd:MD_Distribution">
    <xsl:copy>
      <xsl:apply-templates select="*"/>
      <xsl:apply-templates select="$remoteAtomDataset/atom:feed/atom:entry/atom:link[@rel='enclosure']"/>
    </xsl:copy>
  </xsl:template>


  <xsl:template match="atom:link">
    <!-- Verify link is not already present in distribution-->
    <!--      <xsl:if test="count($distribution/mrd:transferOptions/mrd:MD_DigitalTransferOptions/mrd:onLine/cit:CI_OnlineResource/cit:linkage/gco:CharacterString[text() = $currentHref])>0">-->
    <!--        <xsl:apply-templates select="$distribution/mrd:transferOptions[mrd:MD_DigitalTransferOptions/mrd:onLine/cit:CI_OnlineResource/cit:linkage/gco:CharacterString/text() = $currentHref]"/>-->
    <!--        <xsl:message><xsl:text>erased content</xsl:text></xsl:message>-->
    <!--      </xsl:if>-->

    <!--        <xsl:message><xsl:text>Adding download link: </xsl:text><xsl:value-of select="$currentHref"/> </xsl:message>-->
    <mrd:transferOptions>
      <mrd:MD_DigitalTransferOptions>
        <xsl:if
          test="@length[. castable as xs:double]"> <!-- Only add 'transferSize' if 'length' attribute is present in the link.-->
          <mrd:transferSize>
            <gco:Real>
              <xsl:value-of select="@length div 1048576"/> <!-- size converted from Byte to MB-->
            </gco:Real>
          </mrd:transferSize>
        </xsl:if>
        <mrd:onLine>
          <cit:CI_OnlineResource>
            <cit:linkage>
              <gco:CharacterString>
                <xsl:value-of select="@href"/>
              </gco:CharacterString>
            </cit:linkage>
            <cit:protocol>
              <gco:CharacterString>WWW:DOWNLOAD:<xsl:value-of select="@type"/>
              </gco:CharacterString>
            </cit:protocol>
            <cit:name>
              <gco:CharacterString>
                <xsl:value-of select="@title"/>
              </gco:CharacterString>
            </cit:name>
            <cit:description>
              <gco:CharacterString>
                <xsl:value-of select="ancestor::atom:entry/atom:summary"/>
              </gco:CharacterString>
            </cit:description>
            <cit:function>
              <cit:CI_OnLineFunctionCode
                codeList="http://standards.iso.org/iso/19115/resources/Codelists/cat/codelists.xml#CI_OnLineFunctionCode"
                codeListValue="download"/>
            </cit:function>
          </cit:CI_OnlineResource>
        </mrd:onLine>
      </mrd:MD_DigitalTransferOptions>
    </mrd:transferOptions>
  </xsl:template>

</xsl:stylesheet>
