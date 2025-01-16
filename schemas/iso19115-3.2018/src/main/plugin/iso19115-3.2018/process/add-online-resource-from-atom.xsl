<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:atom="http://www.w3.org/2005/Atom"
                xmlns:cat="http://standards.iso.org/iso/19115/-3/cat/1.0"
                xmlns:geonet="http://www.fao.org/geonetwork"
                xmlns:mdb="http://standards.iso.org/iso/19115/-3/mdb/2.0"
                xmlns:mrd="http://standards.iso.org/iso/19115/-3/mrd/1.0"
                xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/2.0"
                xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
                xmlns:mcc="http://standards.iso.org/iso/19115/-3/mcc/1.0"
                version="2.0">

  <xsl:import href="process-utility.xsl"/>

  <xsl:param name="atomfeedUrl" select="''"/>

  <xsl:variable name="atomfeed-registration-loc">
    <msg id="a" xml:lang="eng">Add online resource from atom feed: </msg>
    <msg id="a" xml:lang="fre">Ajouter resource depuis atom feed: </msg>
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
      <xsl:variable name="isRegistered" select="false()" />
<!--                    select="count($root//mdb:dataQualityInfo/*/-->
<!--                              mdq:standaloneQualityReport[-->
<!--                                contains(*/mdq:abstract/*[1]/text(), $url)]) > 0"-->
<!--                    as="xs:boolean"/>-->
      <xsl:if test="not($isRegistered)">
        <suggestion process="add-online-resource-from-atom"
                    id="{concat($id, '-', position())}"
                    category="contentinfo"
                    target="metadata">
          <name><xsl:value-of select="geonet:i18n($atomfeed-registration-loc, 'a', $guiLang)"/><xsl:value-of select="."/></name>
          <operational>true</operational>
          <params>{"atomfeedUrl":{"type":"text", "defaultValue":"<xsl:value-of select="."/>"}}</params>
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

  <xsl:variable name="uuid" select="mdb:MD_Metadata/mdb:metadataIdentifier/mcc:MD_Identifier/mcc:code/gco:CharacterString"/>

  <xsl:template match="mdb:MD_Metadata/mdb:distributionInfo/mrd:MD_Distribution">
    <xsl:copy>
      <xsl:apply-templates select="*"/>
      <xsl:variable name="md_distribution" select="."/>

      <xsl:message><xsl:text>UUID: </xsl:text><xsl:value-of select="$uuid"/> </xsl:message>
      <xsl:variable name="remoteAtomfeed" select="document($atomfeedUrl)"/>
      <xsl:variable name="atomLink" as="node()*" select="$remoteAtomfeed/atom:feed/atom:entry/atom:link[@type='application/atom+xml' and contains(@href, $uuid)]/@href"/>
<!--      <xsl:message><xsl:text>ATOM Link: </xsl:text><xsl:value-of select="$atomLink"/></xsl:message>-->

      <xsl:variable name="remoteAtomDataset" select="document($atomLink)"/>
      <!-- Variable to store all dataset links -->
      <xsl:apply-templates select="$remoteAtomDataset/atom:feed/atom:entry">
        <xsl:with-param name="distribution" select="$md_distribution"/>
      </xsl:apply-templates>

    </xsl:copy>

  </xsl:template>

  <xsl:template match="atom:entry">
    <xsl:param name="distribution"></xsl:param>
    <xsl:variable name="datasetLinks" as="node()*" select="atom:link"/>
    <xsl:variable name="entry" as="node()" select="."/>
<!--    <xsl:message><xsl:text>Dataset links: </xsl:text><xsl:value-of select="$datasetLinks/@href"/></xsl:message>-->

    <xsl:for-each select="$datasetLinks">
      <xsl:apply-templates select="." >
        <xsl:with-param name="distribution" select="$distribution"/>
        <xsl:with-param name="entry" select="$entry"/>
      </xsl:apply-templates>
    </xsl:for-each>

  </xsl:template>

    <xsl:template match="atom:link">

      <xsl:param name="distribution"></xsl:param>
      <xsl:param name="entry"></xsl:param>
      <xsl:variable name="currentHref" select="@href"/>
      <!-- Verify link is not already present in distribution-->
      <xsl:choose>
      <xsl:when test="count($distribution/mrd:transferOptions/mrd:MD_DigitalTransferOptions/mrd:onLine/cit:CI_OnlineResource/cit:linkage/gco:CharacterString[text() = $currentHref])>0">
<!--        <xsl:message><xsl:text>link already present ignored: </xsl:text> <xsl:value-of select="$currentHref"/></xsl:message>-->
      </xsl:when>
      <xsl:otherwise>
<!--        <xsl:message><xsl:text>Adding download link: </xsl:text><xsl:value-of select="$currentHref"/> </xsl:message>-->
        <mrd:transferOptions>
          <mrd:MD_DigitalTransferOptions>
              <mrd:onLine>
                  <cit:CI_OnlineResource>
                      <cit:linkage>
                          <gco:CharacterString>
                              <xsl:value-of select="@href"/>
                          </gco:CharacterString>
                      </cit:linkage>
                      <cit:protocol>
                          <gco:CharacterString>WWW:DOWNLOAD:<xsl:value-of select="@type"/></gco:CharacterString>
                      </cit:protocol>
                      <cit:name>
                          <gco:CharacterString>
                              <xsl:value-of select="@title" />
                          </gco:CharacterString>
                      </cit:name>
                    <cit:description>
                      <gco:CharacterString>
                        <xsl:value-of select="$entry/atom:summary" />
                      </gco:CharacterString>
                    </cit:description>
                      <cit:function>
                          <cit:CI_OnLineFunctionCode codeList="http://standards.iso.org/iso/19115/resources/Codelists/cat/codelists.xml#CI_OnLineFunctionCode" codeListValue="download"/>
                      </cit:function>
                  </cit:CI_OnlineResource>
              </mrd:onLine>
              <mrd:transferSize>
                <gco:Real>
                  <xsl:value-of select="@length div 1024"/>
                </gco:Real>
              </mrd:transferSize>
          </mrd:MD_DigitalTransferOptions>
        </mrd:transferOptions>
      </xsl:otherwise>
      </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
