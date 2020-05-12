<?xml version="1.0" encoding="UTF-8"?>
<!--
  ~ Copyright (C) 2001-2016 Food and Agriculture Organization of the
  ~ United Nations (FAO-UN), United Nations World Food Programme (WFP)
  ~ and United Nations Environment Programme (UNEP)
  ~
  ~ This program is free software; you can redistribute it and/or modify
  ~ it under the terms of the GNU General Public License as published by
  ~ the Free Software Foundation; either version 2 of the License, or (at
  ~ your option) any later version.
  ~
  ~ This program is distributed in the hope that it will be useful, but
  ~ WITHOUT ANY WARRANTY; without even the implied warranty of
  ~ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
  ~ General Public License for more details.
  ~
  ~ You should have received a copy of the GNU General Public License
  ~ along with this program; if not, write to the Free Software
  ~ Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA
  ~
  ~ Contact: Jeroen Ticheler - FAO - Viale delle Terme di Caracalla 2,
  ~ Rome - Italy. email: geonetwork@osgeo.org
  -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:gmx="http://www.isotc211.org/2005/gmx"
                xmlns:gmi="http://www.isotc211.org/2005/gmi"
                xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:srv="http://www.isotc211.org/2005/srv"
                xmlns:gml="http://www.opengis.net/gml/3.2"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:gn-fn-index="http://geonetwork-opensource.org/xsl/functions/index"
                xmlns:index="java:org.fao.geonet.kernel.search.EsSearchManager"
                xmlns:util="java:org.fao.geonet.util.XslUtil"
                xmlns:daobs="http://daobs.org"
                xmlns:saxon="http://saxon.sf.net/"
                extension-element-prefixes="saxon"
                exclude-result-prefixes="#all"
                version="2.0">

  <xsl:import href="fn.xsl"/>
  <xsl:import href="common/inspire-constant.xsl"/>
  <xsl:import href="common/index-utils.xsl"/>

  <xsl:output method="xml" indent="yes"/>

  <xsl:output name="default-serialize-mode"
              indent="no"
              omit-xml-declaration="yes"
              encoding="utf-8"
              escape-uri-attributes="yes"/>



  <!-- If identification creation, publication and revision date
    should be indexed as a temporal extent information (eg. in INSPIRE
    metadata implementing rules, those elements are defined as part
    of the description of the temporal extent). -->
  <xsl:variable name="useDateAsTemporalExtent" select="true()"/>

  <!-- Define if operatesOn type should be defined
  by analysis of protocol in all transfers options.
  -->
  <xsl:variable name="operatesOnSetByProtocol" select="false()"/>

  <!-- List of keywords to search for to flag a record as opendata.
   Do not put accents or upper case letters here as comparison will not
   take them in account. -->
  <xsl:variable name="openDataKeywords"
                select="'opendata|open data|donnees ouvertes'"/>

  <xsl:template match="/">
    <xsl:apply-templates mode="index"/>
  </xsl:template>

  <xsl:template match="gmi:MI_Metadata|gmd:MD_Metadata"
                mode="extract-uuid">
    <xsl:value-of select="gmd:fileIdentifier/gco:CharacterString"/>
  </xsl:template>


  <xsl:template mode="index-extra-fields" match="*"/>

  <xsl:template mode="index-extra-documents" match="*"/>

  <xsl:template match="gmi:MI_Metadata|gmd:MD_Metadata"
                mode="index">
    <!-- Main variables for the document

    TODO: GN does not assign UUIDs to template. Maybe it should ?
      XTTE0570: An empty sequence is not allowed as the value of variable $identifier
    -->
    <xsl:variable name="identifier" as="xs:string?"
                  select="gmd:fileIdentifier/gco:CharacterString[. != '']"/>


    <!-- In ISO19139 consider datestamp element the last update date
    even if the standard says creation date. Most of the catalog implementations
    update the datestamp on change. -->
    <xsl:variable name="lastRevisionDate" as="xs:string?"
                  select="gmd:dateStamp[1]/gco:DateTime[gn-fn-index:is-isoDate(.)]"/>

    <xsl:variable name="mainLanguageCode" as="xs:string?"
                  select="gmd:language[1]/gmd:LanguageCode/
                        @codeListValue[normalize-space(.) != '']"/>

    <xsl:variable name="mainLanguage" as="xs:string?"
                  select="if ($mainLanguageCode) then $mainLanguageCode else
                    gmd:language[1]/gco:CharacterString[normalize-space(.) != '']"/>

    <xsl:variable name="otherLanguages" as="attribute()*"
                  select="gmd:locale/gmd:PT_Locale/
                        gmd:languageCode/gmd:LanguageCode/
                          @codeListValue[normalize-space(.) != '']"/>
    <xsl:variable name="allLanguages">
      <lang id="default" value="{$mainLanguage}"/>
      <xsl:for-each select="$otherLanguages">
        <lang id="{../../../@id}" value="{.}"/>
      </xsl:for-each>
    </xsl:variable>

    <!-- Record is dataset if no hierarchyLevel -->
    <xsl:variable name="isDataset" as="xs:boolean"
                  select="
                      count(gmd:hierarchyLevel[gmd:MD_ScopeCode/@codeListValue='dataset']) > 0 or
                      count(gmd:hierarchyLevel) = 0"/>

    <xsl:variable name="isService" as="xs:boolean"
                  select="
                      count(gmd:hierarchyLevel[gmd:MD_ScopeCode/@codeListValue='service']) > 0"/>

    <!-- Create a first document representing the main record. -->
    <doc>

      <xsl:copy-of select="gn-fn-index:add-field('docType', 'metadata')"/>
      <xsl:copy-of select="gn-fn-index:add-field('documentStandard', 'iso19139')"/>

      <!-- Index the metadata document as XML -->
      <document>
        <!--<xsl:value-of select="saxon:serialize(., 'default-serialize-mode')"/>-->
      </document>

      <xsl:copy-of select="gn-fn-index:add-field('metadataIdentifier', $identifier)"/>

      <xsl:for-each select="gmd:metadataStandardName/gco:CharacterString">
        <xsl:copy-of select="gn-fn-index:add-field('standardName', normalize-space(.))"/>
      </xsl:for-each>


      <indexingDate>
        <xsl:value-of select="format-dateTime(current-dateTime(), $dateFormat)"/>
      </indexingDate>

      <!-- Indexing record information -->
      <!-- # Date -->
      <!-- TODO improve date formatting maybe using Joda parser
      Select first one because some records have 2 dates !
      eg. fr-784237539-bdref20100101-0105

      Remove millisec and timezone until not supported
      eg. 2017-02-08T13:18:03.138+00:02
      -->
      <xsl:for-each select="(gmd:dateStamp/*[gn-fn-index:is-isoDate(.)])[1]">
        <dateStamp><xsl:value-of select="."/></dateStamp>
      </xsl:for-each>


      <!-- # Languages -->
      <xsl:copy-of select="gn-fn-index:add-field('mainLanguage', $mainLanguage)"/>

      <xsl:for-each select="$otherLanguages">
        <xsl:copy-of select="gn-fn-index:add-field('otherLanguage', .)"/>
      </xsl:for-each>


      <!-- # Resource type -->
      <xsl:choose>
        <xsl:when test="$isDataset">
          <resourceType>dataset</resourceType>
        </xsl:when>
        <xsl:otherwise>
          <xsl:for-each select="gmd:hierarchyLevel/gmd:MD_ScopeCode/
                              @codeListValue[normalize-space(.) != '']">
            <resourceType>
              <xsl:value-of select="."/>
            </resourceType>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:variable name="isMapDigital"
                    select="count(gmd:identificationInfo/*/gmd:citation/*/gmd:presentationForm[*/@codeListValue = 'mapDigital']) > 0"/>
      <xsl:variable name="isStatic"
                    select="count(gmd:distributionInfo/*/gmd:distributionFormat/*/gmd:name/*[contains(., 'PDF') or contains(., 'PNG') or contains(., 'JPEG')]) > 0"/>
      <xsl:variable name="isInteractive"
                    select="count(gmd:distributionInfo/*/gmd:distributionFormat/*/gmd:name/*[contains(., 'OGC:WMC') or contains(., 'OGC:OWS-C')]) > 0"/>
      <xsl:variable name="isPublishedWithWMCProtocol"
                    select="count(gmd:distributionInfo/*/gmd:transferOptions/*/gmd:onLine/*/gmd:protocol[starts-with(gco:CharacterString, 'OGC:WMC')]) > 0"/>

      <xsl:choose>
        <xsl:when test="$isDataset and $isMapDigital and
                            ($isStatic or $isInteractive or $isPublishedWithWMCProtocol)">
          <resourceType>map</resourceType>
          <xsl:choose>
            <xsl:when test="$isStatic">
              <resourceType>map/static</resourceType>
            </xsl:when>
            <xsl:when test="$isInteractive or $isPublishedWithWMCProtocol">
              <resourceType>map/interactive</resourceType>
            </xsl:when>
          </xsl:choose>
        </xsl:when>
      </xsl:choose>



      <!-- Indexing metadata contact -->
      <xsl:apply-templates mode="index-contact" select="gmd:contact">
        <xsl:with-param name="fieldSuffix" select="''"/>
      </xsl:apply-templates>

      <!-- Indexing all codelist

      Indexing method is:
      <gmd:accessConstraints>
        <gmd:MD_RestrictionCode codeListValue="otherRestrictions"
        is indexed as
        codelist_accessConstraints:otherRestrictions

        Exclude some useless codelist like
        Contact role, Date type.
      -->
      <xsl:for-each select=".//*[@codeListValue != '' and
                            name() != 'gmd:CI_RoleCode' and
                            name() != 'gmd:CI_DateTypeCode' and
                            name() != 'gmd:LanguageCode'
                            ]">
        <xsl:variable name="parentName"
                      select="local-name(..)"/>
        <xsl:variable name="name"
                      select="name()"/>
        <xsl:variable name="value"
                      select="@codeListValue"/>
        <xsl:element name="codelist_{$parentName}">
          <xsl:value-of select="$value"/>
        </xsl:element>

        <xsl:for-each select="$allLanguages/lang">
          <xsl:variable name="translation"
                        select="util:getCodelistTranslation(string($name), string($value), string(@value))"/>
          <xsl:if test="@id = 'default'">
            <xsl:element name="codelist_{$parentName}_text">
              <xsl:value-of select="$translation"/>
            </xsl:element>
          </xsl:if>
          <xsl:element name="codelist_{$parentName}_text_lang{@value}">
            <xsl:value-of select="$translation"/>
          </xsl:element>
        </xsl:for-each>
      </xsl:for-each>


      <!-- Indexing resource information
      TODO: Should we support multiple identification in the same record
      eg. nl db60a314-5583-437d-a2ff-1e59cc57704e
      Also avoid error when records contains multiple MD_IdentificationInfo
      or SRV_ServiceIdentification or a mix
      eg. de 8bb5334f-558b-982b-7b12-86ea486540d7
      -->
      <xsl:for-each select="gmd:identificationInfo[1]/*[1]">
        <xsl:for-each select="gmd:citation/gmd:CI_Citation">

          <xsl:copy-of select="gn-fn-index:add-multilingual-field('resourceTitle', gmd:title, $allLanguages)"/>
          <xsl:copy-of select="gn-fn-index:add-multilingual-field('resourceAltTitle', gmd:resourceAltTitle, $allLanguages)"/>

          <xsl:for-each select="gmd:date/gmd:CI_Date[gn-fn-index:is-isoDate(gmd:date/*/text())]">
            <xsl:variable name="dateType"
                          select="gmd:dateType[1]/gmd:CI_DateTypeCode/@codeListValue"
                          as="xs:string?"/>
            <xsl:variable name="date"
                          select="string(gmd:date[1]/gco:Date|gmd:date[1]/gco:DateTime)"/>

            <xsl:choose>
              <xsl:when test="gn-fn-index:is-isoDate(.)">
                <xsl:element name="{$dateType}DateForResource">
                  <xsl:value-of select="$date"/>
                </xsl:element>
              </xsl:when>
              <xsl:otherwise>
                <indexingErrorMsg>Warning / Date <xsl:value-of select="$dateType"/> with value '<xsl:value-of select="$date"/>' was not a valid date format.</indexingErrorMsg>
              </xsl:otherwise>
            </xsl:choose>

            <xsl:element name="{$dateType}YearForResource">
              <xsl:value-of select="substring($date, 0, 5)"/>
            </xsl:element>
            <xsl:element name="{$dateType}MonthForResource">
              <xsl:value-of select="substring($date, 0, 8)"/>
            </xsl:element>


          </xsl:for-each>

          <xsl:if test="$useDateAsTemporalExtent">
            <xsl:for-each-group select="gmd:date/gmd:CI_Date[gn-fn-index:is-isoDate(gmd:date/*/text())]/gmd:date/*/text()"
                                group-by=".">

                <resourceTemporalDateRange type="object">{
                  "gte": "<xsl:value-of select="."/>",
                  "lte": "<xsl:value-of select="."/>"
                  }</resourceTemporalDateRange>
            </xsl:for-each-group>
          </xsl:if>

          <!-- TODO: Add support for Anchor, can be a DOI -->
          <xsl:for-each select="gmd:identifier/*/gmd:code/(gco:CharacterString|gmx:Anchor)">
            <resourceIdentifier>
              <xsl:value-of select="."/>
            </resourceIdentifier>
          </xsl:for-each>
        </xsl:for-each>

        <xsl:copy-of select="gn-fn-index:add-multilingual-field('resourceAbstract', gmd:abstract, $allLanguages)"/>


        <!-- Indexing resource contact -->
        <xsl:apply-templates mode="index-contact"
                             select="gmd:pointOfContact">
          <xsl:with-param name="fieldSuffix" select="'ForResource'"/>
        </xsl:apply-templates>

        <xsl:copy-of select="gn-fn-index:add-multilingual-field('resourceCredit', gmd:credit, $allLanguages)"/>


        <xsl:variable name="overviews"
                      select="gmd:graphicOverview/gmd:MD_BrowseGraphic/
                              gmd:fileName/gco:CharacterString[. != '']"/>
        <xsl:copy-of select="gn-fn-index:add-field('hasOverview', if (count($overviews) > 0) then 'true' else 'false')"/>


        <xsl:for-each select="$overviews">
          <!-- TODO can be multilingual desc and name -->
          <overview type="object">{
            "url": "<xsl:value-of select="."/>"
            <xsl:if test="normalize-space(../../gmd:fileDescription) != ''">,
              "text": <xsl:value-of select="gn-fn-index:add-multilingual-field('name', ../../gmd:fileDescription, $allLanguages, true())"/>
            </xsl:if>
          }</overview>
        </xsl:for-each>

        <xsl:for-each
          select="gmd:language/(gco:CharacterString|gmd:LanguageCode/@codeListValue)">
          <resourceLanguage>
            <xsl:value-of select="."/>
          </resourceLanguage>
        </xsl:for-each>

        <xsl:variable name="inspireEnable" select="util:getSettingValue('system/inspire/enable')" />

        <xsl:if test="$inspireEnable = 'true'">
          <!-- TODO: create specific INSPIRE template or mode -->
          <!-- INSPIRE themes

          Select the first thesaurus title because some records
          may contains many even if invalid.

          Also get the first title at it may happen that a record
          have more than one.

          Select any thesaurus having the title containing "INSPIRE themes".
          Some records have "GEMET-INSPIRE themes" eg. sk:ee041534-b8f3-4683-b9dd-9544111a0712
          Some other "GEMET - INSPIRE themes"

          Take in account gmd:descriptiveKeywords or srv:keywords
          -->
          <!-- TODO: Some MS may be using a translated version of the thesaurus title -->
          <xsl:variable name="inspireKeywords"
                        select="*/gmd:MD_Keywords[
                      contains(lower-case(
                       gmd:thesaurusName[1]/*/gmd:title[1]/*[1]/text()
                       ), 'gemet') and
                       contains(lower-case(
                       gmd:thesaurusName[1]/*/gmd:title[1]/*[1]/text()
                       ), 'inspire')]
                  /gmd:keyword"/>
          <xsl:for-each
            select="$inspireKeywords">
            <xsl:variable name="position" select="position()"/>
            <xsl:for-each select="gco:CharacterString[. != '']|
                                gmx:Anchor[. != '']">
              <xsl:variable name="inspireTheme" as="xs:string"
                            select="index:analyzeField('synInspireThemes', text())"/>

              <inspireTheme_syn>
                <xsl:value-of select="text()"/>
              </inspireTheme_syn>
              <inspireTheme>
                <xsl:value-of select="$inspireTheme"/>
              </inspireTheme>
              <!-- TODOES: Add Acronym -->
              <!--
              WARNING: Here we only index the first keyword in order
              to properly compute one INSPIRE annex.
              -->
              <xsl:if test="$position = 1">
                <inspireThemeFirst_syn>
                  <xsl:value-of select="text()"/>
                </inspireThemeFirst_syn>
                <inspireThemeFirst>
                  <xsl:value-of select="$inspireTheme"/>
                </inspireThemeFirst>

                <xsl:if test="$inspireTheme != ''">
                  <inspireAnnexForFirstTheme>
                    <xsl:value-of
                      select="index:analyzeField('synInspireAnnexes', $inspireTheme)"/>
                  </inspireAnnexForFirstTheme>
                </xsl:if>
              </xsl:if>
              <xsl:if test="$inspireTheme != ''">
                <inspireAnnex>
                  <xsl:value-of
                    select="index:analyzeField('synInspireAnnexes', $inspireTheme)"/>
                </inspireAnnex>
                <xsl:variable name="inspireThemeUri" as="xs:string"
                              select="index:analyzeField('synInspireThemeUris', $inspireTheme)"/>
                <inspireThemeUri>
                  <xsl:value-of select="$inspireThemeUri"/>
                </inspireThemeUri>
              </xsl:if>
            </xsl:for-each>
          </xsl:for-each>

          <!-- For services, the count does not take into account
          dataset's INSPIRE themes which are transfered to the service
          by service-dataset-task. -->
          <inspireThemeNumber>
            <xsl:value-of
              select="count($inspireKeywords)"/>
          </inspireThemeNumber>

          <hasInspireTheme>
            <xsl:value-of
              select="if (count($inspireKeywords) > 0) then 'true' else 'false'"/>
          </hasInspireTheme>
        </xsl:if>


        <!-- Index all keywords -->
        <xsl:variable name="keywords"
                      select="*/gmd:MD_Keywords/
                                gmd:keyword/gco:CharacterString|
                              */gmd:MD_Keywords/
                                gmd:keyword/gmd:PT_FreeText/gmd:textGroup/
                                  gmd:LocalisedCharacterString"/>

        <tagNumber>
          <xsl:value-of select="count($keywords)"/>
        </tagNumber>

        <xsl:for-each select="$keywords">
          <tag>
            <xsl:value-of select="text()"/>
          </tag>
        </xsl:for-each>

        <xsl:variable name="isOpenData">
          <xsl:for-each select="$keywords">
            <xsl:if test="matches(
                            normalize-unicode(replace(normalize-unicode(
                              lower-case(normalize-space(text())), 'NFKD'), '\p{Mn}', ''), 'NFKC'),
                            $openDataKeywords)">
              <xsl:value-of select="'true'"/>
            </xsl:if>
          </xsl:for-each>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="normalize-space($isOpenData) != ''">
            <isOpenData>true</isOpenData>
          </xsl:when>
          <xsl:otherwise>
            <isOpenData>false</isOpenData>
          </xsl:otherwise>
        </xsl:choose>

        <!-- Index keywords which are of type place -->
        <xsl:for-each
          select="*/gmd:MD_Keywords/
                          gmd:keyword[gmd:type/gmd:MD_KeywordTypeCode/@codeListValue = 'place']/
                            gco:CharacterString|
                        */gmd:MD_Keywords/
                          gmd:keyword[gmd:type/gmd:MD_KeywordTypeCode/@codeListValue = 'place']/
                            gmd:PT_FreeText/gmd:textGroup/gmd:LocalisedCharacterString">
          <geotag>
            <xsl:value-of select="text()"/>
          </geotag>
        </xsl:for-each>


        <!-- Index all keywords having a specific thesaurus -->
        <xsl:for-each
          select="*/gmd:MD_Keywords[gmd:thesaurusName]">

          <xsl:variable name="thesaurusName"
                        select="gmd:thesaurusName[1]/gmd:CI_Citation/
                                  gmd:title[1]/gco:CharacterString"/>

          <xsl:variable name="thesaurusId"
                        select="normalize-space(gmd:thesaurusName/gmd:CI_Citation/
                                  gmd:identifier[position() = 1]/gmd:MD_Identifier/
                                    gmd:code/(gco:CharacterString|gmx:Anchor)/text())"/>

          <xsl:variable name="key">
            <xsl:choose>
              <xsl:when test="$thesaurusId != ''">
                <xsl:value-of select="$thesaurusId"/>
              </xsl:when>
              <!-- Try to build a thesaurus key based on the name
              by removing space - to be improved. -->
              <xsl:when test="normalize-space($thesaurusName) != ''">
                <xsl:value-of select="replace($thesaurusName, ' ', '-')"/>
              </xsl:when>
            </xsl:choose>
          </xsl:variable>

          <xsl:if test="normalize-space($key) != ''">
            <!-- Index keyword characterString including multilingual ones
             and element like gmx:Anchor including the href attribute
             which may contains keyword identifier. -->
            <xsl:variable name="thesaurusField"
                          select="concat('thesaurus_', replace($key, '[^a-zA-Z0-9]', ''))"/>

            <xsl:element name="{$thesaurusField}Number">
              <xsl:value-of select="count(gmd:keyword/(*[normalize-space() != '']))"/>
            </xsl:element>

            <xsl:for-each select="gmd:keyword/(*[normalize-space() != '']|
                                  */@xlink:href[normalize-space() != '']|
                                  gmd:PT_FreeText/gmd:textGroup/gmd:LocalisedCharacterString[normalize-space() != ''])">
              <xsl:element name="{$thesaurusField}">
                <xsl:value-of select="normalize-space(.)"/>
              </xsl:element>
            </xsl:for-each>


            <xsl:call-template name="build-tree-values">
              <xsl:with-param name="values"
                              select="gmd:keyword/(*[normalize-space() != '']|
                                */@xlink:href[normalize-space() != '']|
                                gmd:PT_FreeText/gmd:textGroup/gmd:LocalisedCharacterString[normalize-space() != ''])"/>
              <xsl:with-param name="thesaurus"
                              select="$thesaurusId"/>
              <xsl:with-param name="language"
                              select="$mainLanguageCode"/>
              <xsl:with-param name="fieldName"
                              select="concat($thesaurusField, '_tree')"/>
              <xsl:with-param name="allTreeField"
                              select="true()"/>
            </xsl:call-template>

          </xsl:if>
        </xsl:for-each>


        <allKeywords type="object">{
          <xsl:for-each-group select="*/gmd:MD_Keywords"
                              group-by="gmd:thesaurusName/*/gmd:title/*/text()">
            <xsl:sort select="current-grouping-key()"/>
            <xsl:variable name="thesaurusName"
                          select="current-grouping-key()"/>

            <xsl:variable name="thesaurusId"
                          select="normalize-space(gmd:thesaurusName/gmd:CI_Citation/
                                    gmd:identifier[position() = 1]/gmd:MD_Identifier/
                                      gmd:code/(gco:CharacterString|gmx:Anchor)/text())"/>

            <xsl:variable name="key">
              <xsl:choose>
                <xsl:when test="$thesaurusId != ''">
                  <xsl:value-of select="$thesaurusId"/>
                </xsl:when>
                <!-- Try to build a thesaurus key based on the name
                by removing space - to be improved. -->
                <xsl:when test="normalize-space($thesaurusName) != ''">
                  <xsl:value-of select="replace($thesaurusName, ' ', '-')"/>
                </xsl:when>
              </xsl:choose>
            </xsl:variable>

            <xsl:if test="normalize-space($key) != ''">
              <xsl:variable name="thesaurusField"
                            select="replace($key, '[^a-zA-Z0-9]', '')"/>

              "<xsl:value-of select="$thesaurusField"/>": {
                "id": "<xsl:value-of select="gn-fn-index:json-escape($thesaurusId)"/>",
                "title": "<xsl:value-of select="gn-fn-index:json-escape($thesaurusName)"/>",
                "theme": "<xsl:value-of select="gn-fn-index:json-escape(gmd:type/*/@codeListValue)"/>",
                "link": "<xsl:value-of select="gn-fn-index:json-escape(@xlink:href)"/>",
                "keywords": [
              <xsl:for-each select="gmd:keyword/(*[normalize-space() != '']|
                                    */@xlink:href[normalize-space() != '']|
                                    gmd:PT_FreeText/gmd:textGroup/gmd:LocalisedCharacterString[normalize-space() != ''])">
                <!-- TODOES: Index translations -->
                {"value": "<xsl:value-of select="gn-fn-index:json-escape(.)"/>",
                "link": "<xsl:value-of select="gn-fn-index:json-escape(@xlink:href)"/>"}
                <xsl:if test="position() != last()">,</xsl:if>
              </xsl:for-each>
              ]}
              <xsl:if test="position() != last()">,</xsl:if>
            </xsl:if>
          </xsl:for-each-group>
        }</allKeywords>


        <xsl:for-each select="gmd:topicCategory/gmd:MD_TopicCategoryCode">
          <xsl:variable name="value"
                        select="."/>
          <topic>
            <xsl:value-of select="."/>
          </topic>
          <xsl:for-each select="$allLanguages/lang">
            <xsl:variable name="translation"
                          select="util:getCodelistTranslation('gmd:MD_TopicCategoryCode', string($value), string(@value))"/>
            <xsl:if test="@id = 'default'">
              <xsl:element name="topic_text">
                <xsl:value-of select="$translation"/>
              </xsl:element>
            </xsl:if>
            <xsl:element name="topic_text_lang{@value}">
              <xsl:value-of select="$translation"/>
            </xsl:element>
          </xsl:for-each>
        </xsl:for-each>


        <xsl:for-each select="gmd:spatialResolution/gmd:MD_Resolution">
          <xsl:for-each
            select="gmd:equivalentScale/gmd:MD_RepresentativeFraction/gmd:denominator/gco:Integer[. castable as xs:decimal]">
            <resolutionScaleDenominator>
              <xsl:value-of select="."/>
            </resolutionScaleDenominator>
          </xsl:for-each>

          <xsl:for-each select="gmd:distance/gco:Distance[. != '']">
            <resolutionDistance>
              <xsl:value-of select="concat(., ' ', @uom)"/>
            </resolutionDistance>
          </xsl:for-each>
        </xsl:for-each>

        <xsl:for-each
          select="gmd:spatialRepresentationType/gmd:MD_SpatialRepresentationTypeCode/@codeListValue[. != '']">
          <spatialRepresentationType>
            <xsl:value-of select="."/>
          </spatialRepresentationType>
        </xsl:for-each>


        <xsl:for-each select="gmd:resourceConstraints/*">
          <xsl:variable name="fieldPrefix" select="local-name()"/>
          <xsl:for-each select="gmd:otherConstraints">
            <xsl:copy-of select="gn-fn-index:add-multilingual-field(concat($fieldPrefix, 'OtherConstraints'), ., $allLanguages)"/>
          </xsl:for-each>
          <xsl:for-each select="gmd:useLimitation">
            <xsl:copy-of select="gn-fn-index:add-multilingual-field(concat($fieldPrefix, 'UseLimitation'), ., $allLanguages)"/>
          </xsl:for-each>
        </xsl:for-each>


        <xsl:if test="*/gmd:EX_Extent/*/gmd:EX_BoundingPolygon">
          <hasBoundingPolygon>true</hasBoundingPolygon>
        </xsl:if>

        <xsl:for-each select="*/gmd:EX_Extent">

          <xsl:for-each select="gmd:geographicElement/gmd:EX_GeographicDescription/
            gmd:geographicIdentifier/gmd:MD_Identifier/
            gmd:code/gco:CharacterString[normalize-space(.) != '']">
            <geoTag>
              <xsl:value-of select="gn-fn-index:json-escape(.)"/>
            </geoTag>
          </xsl:for-each>


          <xsl:copy-of select="gn-fn-index:add-multilingual-field('extentDescription', gmd:description, $allLanguages)"/>

          <!-- TODO: index bounding polygon -->
          <xsl:variable name="bboxes"
                        select=".//gmd:EX_GeographicBoundingBox[
                                ./gmd:westBoundLongitude/gco:Decimal castable as xs:decimal and
                                ./gmd:eastBoundLongitude/gco:Decimal castable as xs:decimal and
                                ./gmd:northBoundLatitude/gco:Decimal castable as xs:decimal and
                                ./gmd:southBoundLatitude/gco:Decimal castable as xs:decimal
                                ]"/>
          <xsl:for-each select="$bboxes">
            <xsl:variable name="format" select="'#0.000000'"></xsl:variable>

            <xsl:variable name="w"
                          select="format-number(./gmd:westBoundLongitude/gco:Decimal/text(), $format)"/>
            <xsl:variable name="e"
                          select="format-number(./gmd:eastBoundLongitude/gco:Decimal/text(), $format)"/>
            <xsl:variable name="n"
                          select="format-number(./gmd:northBoundLatitude/gco:Decimal/text(), $format)"/>
            <xsl:variable name="s"
                          select="format-number(./gmd:southBoundLatitude/gco:Decimal/text(), $format)"/>

            <!-- Example: ENVELOPE(-10, 20, 15, 10) which is minX, maxX, maxY, minY order
            http://wiki.apache.org/solr/SolrAdaptersForLuceneSpatial4
            https://cwiki.apache.org/confluence/display/solr/Spatial+Search

            bbox field type limited to one. TODO
            <xsl:if test="position() = 1">
              <bbox>
                <xsl:text>ENVELOPE(</xsl:text>
                <xsl:value-of select="$w"/>
                <xsl:text>,</xsl:text>
                <xsl:value-of select="$e"/>
                <xsl:text>,</xsl:text>
                <xsl:value-of select="$n"/>
                <xsl:text>,</xsl:text>
                <xsl:value-of select="$s"/>
                <xsl:text>)</xsl:text>
              </field>
            </xsl:if>
            -->
            <xsl:choose>
              <xsl:when test="-180 &lt;= number($e) and number($e) &lt;= 180 and
                              -180 &lt;= number($w) and number($w) &lt;= 180 and
                              -90 &lt;= number($s) and number($s) &lt;= 90 and
                              -90 &lt;= number($n) and number($n) &lt;= 90">
                <xsl:choose>
                  <xsl:when test="$e = $w and $s = $n">
                    <location><xsl:value-of select="concat($s, ',', $w)"/></location>
                  </xsl:when>
                  <xsl:when
                    test="($e = $w and $s != $n) or ($e != $w and $s = $n)">
                    <!-- Probably an invalid bbox indexing a point only -->
                    <location><xsl:value-of select="concat($s, ',', $w)"/></location>
                  </xsl:when>
                  <xsl:otherwise>
                    <geom type="object">
                      <xsl:text>{"type": "Polygon",</xsl:text>
                      <xsl:text>"coordinates": [[</xsl:text>
                      <xsl:value-of select="concat('[', $w, ',', $s, ']')"/>
                      <xsl:text>,</xsl:text>
                      <xsl:value-of select="concat('[', $e, ',', $s, ']')"/>
                      <xsl:text>,</xsl:text>
                      <xsl:value-of select="concat('[', $e, ',', $n, ']')"/>
                      <xsl:text>,</xsl:text>
                      <xsl:value-of select="concat('[', $w, ',', $n, ']')"/>
                      <xsl:text>,</xsl:text>
                      <xsl:value-of select="concat('[', $w, ',', $s, ']')"/>
                      <xsl:text>]]}</xsl:text>
                    </geom>

                    <location><xsl:value-of select="concat(
                                              (number($s) + number($n)) div 2,
                                              ',',
                                              (number($w) + number($e)) div 2)"/></location>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:otherwise></xsl:otherwise>
            </xsl:choose>
            <!--<xsl:value-of select="($e + $w) div 2"/>,<xsl:value-of select="($n + $s) div 2"/></field>-->
          </xsl:for-each>

          <xsl:for-each select=".//gmd:temporalElement/*/gmd:extent/gml:TimePeriod">
            <xsl:variable name="start"
                          select="gml:beginPosition|gml:begin/gml:TimeInstant/gml:timePosition"/>
            <xsl:variable name="end"
                          select="gml:endPosition|gml:end/gml:TimeInstant/gml:timePosition"/>
            <xsl:if test="gn-fn-index:is-isoDate($start)">
              <resourceTemporalDateRange type="object">{
                "gte": "<xsl:value-of select="normalize-space($start)"/>"
                <xsl:if test="gn-fn-index:is-isoDate($end) and not($end/@indeterminatePosition = 'now')">
                  ,"lte": "<xsl:value-of select="normalize-space($end)"/>"
                </xsl:if>
                }</resourceTemporalDateRange>
            </xsl:if>
          </xsl:for-each>
        </xsl:for-each>



        <!-- Service information -->
        <xsl:for-each select="srv:serviceType/gco:LocalName">
          <serviceType>
            <xsl:value-of select="text()"/>
          </serviceType>
          <xsl:if test="$inspireEnable = 'true'">
            <xsl:variable name="inspireServiceType" as="xs:string"
                          select="index:analyzeField(
                                  'keepInspireServiceTypes', text())"/>

            <xsl:if test="$inspireServiceType != ''">
              <inspireServiceType>
                <xsl:value-of select="lower-case($inspireServiceType)"/>
              </inspireServiceType>
            </xsl:if>
          </xsl:if>
          <xsl:if test="following-sibling::srv:serviceTypeVersion">
            <serviceTypeAndVersion>
              <xsl:value-of select="concat(
                        text(),
                        $separator,
                        following-sibling::srv:serviceTypeVersion/gco:CharacterString/text())"/>
            </serviceTypeAndVersion>
          </xsl:if>
        </xsl:for-each>
      </xsl:for-each>


      <xsl:for-each select="gmd:referenceSystemInfo/gmd:MD_ReferenceSystem">
        <xsl:for-each select="gmd:referenceSystemIdentifier/gmd:RS_Identifier">
          <xsl:variable name="crs" select="gmd:code/*"/>

          <xsl:if test="$crs != ''">
            <coordinateSystem>
              <xsl:value-of select="$crs"/>
            </coordinateSystem>
          </xsl:if>

          <crsDetails type="object">{
            "code": "<xsl:value-of select="gn-fn-index:json-escape((gmd:code/*/text())[1])"/>",
            "codeSpace": "<xsl:value-of select="gn-fn-index:json-escape(gmd:codeSpace/*/text())"/>",
            "name": "<xsl:value-of select="gn-fn-index:json-escape(gmd:code/*/@xlink:title)"/>",
            "url": "<xsl:value-of select="gn-fn-index:json-escape(gmd:code/*/@xlink:href)"/>"
            }</crsDetails>
        </xsl:for-each>
      </xsl:for-each>


      <!-- INSPIRE Conformity -->

      <!-- Conformity for services -->
      <xsl:choose>
        <xsl:when test="$isService">
          <xsl:for-each-group select="gmd:dataQualityInfo/*/gmd:report"
                              group-by="*/gmd:result/*/gmd:specification/gmd:CI_Citation/
        gmd:title/gco:CharacterString">
            <xsl:variable name="title" select="current-grouping-key()"/>
            <xsl:variable name="matchingEUText"
                          select="if ($inspireRegulationLaxCheck)
                                  then daobs:search-in-contains($eu9762009/*, $title)
                                  else daobs:search-in($eu9762009/*, $title)"/>
            <xsl:if test="count($matchingEUText) = 1">
              <xsl:variable name="pass"
                            select="*/gmd:result/*/gmd:pass/gco:Boolean"/>
              <inspireConformResource>
                <xsl:value-of select="$pass"/>
              </inspireConformResource>
            </xsl:if>
          </xsl:for-each-group>
        </xsl:when>
        <xsl:otherwise>
          <!-- Conformity for dataset -->
          <xsl:for-each-group select="gmd:dataQualityInfo/*/gmd:report"
                              group-by="*/gmd:result/*/gmd:specification/gmd:CI_Citation/
        gmd:title/gco:CharacterString">

            <xsl:variable name="title" select="current-grouping-key()"/>
            <xsl:variable name="matchingEUText"
                          select="if ($inspireRegulationLaxCheck)
                                  then daobs:search-in-contains($eu10892010/*, $title)
                                  else daobs:search-in($eu10892010/*, $title)"/>

            <xsl:if test="count($matchingEUText) = 1">
              <xsl:variable name="pass"
                            select="*/gmd:result/*/gmd:pass/gco:Boolean"/>
              <inspireConformResource>
                <xsl:value-of select="$pass"/>
              </inspireConformResource>
            </xsl:if>
          </xsl:for-each-group>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:for-each-group select="gmd:dataQualityInfo/*/gmd:report"
                          group-by="*/gmd:result/*/gmd:specification/
                                      */gmd:title/gco:CharacterString">
        <xsl:variable name="title" select="current-grouping-key()"/>
        <xsl:variable name="pass" select="*/gmd:result/*/gmd:pass/gco:Boolean"/>
        <xsl:if test="$pass">
          <xsl:element name="conformTo_{replace(normalize-space($title), '[^a-zA-Z0-9]', '')}">
            <xsl:value-of select="$pass"/>
          </xsl:element>
        </xsl:if>
      </xsl:for-each-group>


      <xsl:for-each select="gmd:dataQualityInfo/*">

        <xsl:for-each select="gmd:lineage/gmd:LI_Lineage/
                                gmd:statement/gco:CharacterString[. != '']">
          <lineage>
            <xsl:value-of select="."/>
          </lineage>
        </xsl:for-each>


        <!-- Indexing measure value -->
        <xsl:for-each select="gmd:report/*[
                normalize-space(gmd:nameOfMeasure[0]/gco:CharacterString) != '']">
          <xsl:variable name="measureName"
                        select="replace(
                                normalize-space(
                                  gmd:nameOfMeasure[0]/gco:CharacterString), ' ', '-')"/>
          <xsl:for-each select="gmd:result/gmd:DQ_QuantitativeResult/gmd:value">
            <xsl:if test=". != ''">
              <xsl:element name="measure_{replace($measureName, '[^a-zA-Z0-9]', '')}">
                <xsl:value-of select="."/>
              </xsl:element>
            </xsl:if>
          </xsl:for-each>
        </xsl:for-each>
      </xsl:for-each>


      <xsl:for-each select="gmd:distributionInfo/*">
        <xsl:for-each
          select="gmd:distributionFormat/*/gmd:name/gco:CharacterString">
          <format>
            <xsl:value-of select="."/>
          </format>
        </xsl:for-each>

        <xsl:for-each select="gmd:transferOptions/*/
                                gmd:onLine/*[gmd:linkage/gmd:URL != '']">

          <xsl:variable name="protocol"
                        select="gmd:protocol/gco:CharacterString/text()"/>
          <xsl:variable name="linkName"
                        select="gn-fn-index:json-escape(gmd:name/gco:CharacterString/text())"/>

          <linkUrl>
            <xsl:value-of select="gmd:linkage/gmd:URL"/>
          </linkUrl>
          <linkProtocol>
            <xsl:value-of select="$protocol"/>
          </linkProtocol>
          <xsl:element name="linkUrlProtocol{replace($protocol, '[^a-zA-Z0-9]', '')}">
            <xsl:value-of select="gmd:linkage/gmd:URL"/>
          </xsl:element>
          <link type="object">{
            "protocol":"<xsl:value-of select="gn-fn-index:json-escape(gmd:protocol/*/text())"/>",
            "url":"<xsl:value-of select="gn-fn-index:json-escape(gmd:linkage/gmd:URL)"/>",
            "name":"<xsl:value-of select="$linkName"/>",
            "description":"<xsl:value-of select="gn-fn-index:json-escape(gmd:description/gco:CharacterString/text())"/>"
            }
            <!--Link object in Angular used to be
            //     name: linkInfos[0],
            //     title: linkInfos[0],
            //     url: linkInfos[2],
            //     desc: linkInfos[1],
            //     protocol: linkInfos[3],
            //     contentType: linkInfos[4],
            //     group: linkInfos[5] ? parseInt(linkInfos[5]) : undefined,
            //     applicationProfile: linkInfos[6]-->
          </link>

          <xsl:if test="$operatesOnSetByProtocol and normalize-space($protocol) != ''">
            <xsl:if test="daobs:contains($protocol, 'wms')">
              <recordOperatedByType>view</recordOperatedByType>
            </xsl:if>
            <xsl:if test="daobs:contains($protocol, 'wfs') or
                          daobs:contains($protocol, 'wcs') or
                          daobs:contains($protocol, 'download')">
              <recordOperatedByType>download</recordOperatedByType>
            </xsl:if>
          </xsl:if>
        </xsl:for-each>
      </xsl:for-each>

      <!-- Service/dataset relation. Create document for the association.
      Note: not used for indicators anymore
       This could be used to retrieve :
      {!child of=documentType:metadata}+documentType:metadata +id:9940c446-6fd4-4ab3-a4de-7d0ee028a8d1
      {!child of=documentType:metadata}+documentType:metadata +resourceType:service +serviceType:view
      {!child of=documentType:metadata}+documentType:metadata +resourceType:service +serviceType:download
       -->
      <xsl:for-each
        select="gmd:identificationInfo/srv:SV_ServiceIdentification/srv:operatesOn">
        <xsl:variable name="associationType" select="'operatesOn'"/>
        <xsl:variable name="serviceType"
                      select="../srv:serviceType/gco:LocalName"/>
        <!--<xsl:variable name="relatedTo" select="@uuidref"/>-->
        <xsl:variable name="getRecordByIdId">
          <xsl:if test="@xlink:href != ''">
            <xsl:analyze-string select="@xlink:href"
                                regex=".*[i|I][d|D]=([\w\-\.\{{\}}]*).*">
              <xsl:matching-substring>
                <xsl:value-of select="regex-group(1)"/>
              </xsl:matching-substring>
            </xsl:analyze-string>
          </xsl:if>
        </xsl:variable>

        <xsl:variable name="datasetId">
          <xsl:choose>
            <xsl:when test="$getRecordByIdId != ''">
              <xsl:value-of select="$getRecordByIdId"/>
            </xsl:when>
            <xsl:when test="@uuidref != ''">
              <xsl:value-of select="@uuidref"/>
            </xsl:when>
          </xsl:choose>
        </xsl:variable>

        <xsl:if test="$datasetId != ''">
          <recordOperateOn><xsl:value-of select="$datasetId"/></recordOperateOn>
          <!--
            TODOES - Need more work with routing -->
<!--          <recordLink type="object">{"name": "dataset", "parent": "<xsl:value-of select="gn-fn-index:json-escape(.)"/>"}</recordLink>-->
        </xsl:if>
      </xsl:for-each>

      <xsl:variable name="recordLinks"
                    select="gmd:parentIdentifier/gco:CharacterString[. != '']"/>
      <xsl:choose>
        <xsl:when test="count($recordLinks) > 0">
          <xsl:for-each select="$recordLinks">
            <parentUuid><xsl:value-of select="."/></parentUuid>
            <recordGroup><xsl:value-of select="."/></recordGroup>
            <!--
            TODOES - Need more work with routing -->
<!--            <recordLink type="object">{"name": "children", "parent": "<xsl:value-of select="gn-fn-index:json-escape(.)"/>"}</recordLink>-->
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <recordGroup><xsl:value-of select="$identifier"/></recordGroup>
        </xsl:otherwise>
      </xsl:choose>

      <!-- Index more fields in this element -->
      <xsl:apply-templates mode="index-extra-fields" select="."/>
    </doc>

    <!-- Index more documents for this element -->
    <xsl:apply-templates mode="index-extra-documents" select="."/>
  </xsl:template>


  <xsl:template mode="index-contact" match="*[gmd:CI_ResponsibleParty]">
    <xsl:param name="fieldSuffix" select="''" as="xs:string"/>

    <!-- Select the first child which should be a CI_ResponsibleParty.
    Some records contains more than one CI_ResponsibleParty which is
    not valid and they will be ignored.
     Same for organisationName eg. de:b86a8604-bf78-480f-a5a8-8edff5586679 -->
    <xsl:variable name="organisationName"
                  select="*[1]/gmd:organisationName[1]/(gco:CharacterString|gmx:Anchor)"
                  as="xs:string*"/>
    <xsl:variable name="uuid" select="@uuid"/>

    <xsl:variable name="role"
                  select="replace(*[1]/gmd:role/*/@codeListValue, ' ', '')"
                  as="xs:string?"/>
    <xsl:variable name="logo" select=".//gmx:FileName/@src"/>
    <xsl:variable name="website" select=".//gmd:onlineResource/*/gmd:linkage/gmd:URL"/>
    <xsl:variable name="email"
                  select="*[1]/gmd:contactInfo/*/gmd:address/*/gmd:electronicMailAddress/gco:CharacterString"/>
    <xsl:variable name="phone"
                  select="*[1]/gmd:contactInfo/*/gmd:phone/*/gmd:voice[normalize-space(.) != '']/*/text()"/>
    <xsl:variable name="individualName"
                  select="*[1]/gmd:individualName/gco:CharacterString/text()"/>
    <xsl:variable name="positionName"
                  select="*[1]/gmd:positionName/gco:CharacterString/text()"/>
    <xsl:variable name="address" select="string-join(*[1]/gmd:contactInfo/*/gmd:address/*/(
                                        gmd:deliveryPoint|gmd:postalCode|gmd:city|
                                        gmd:administrativeArea|gmd:country)/gco:CharacterString/text(), ', ')"/>
    <xsl:if test="normalize-space($organisationName) != ''">
      <xsl:element name="Org{$fieldSuffix}">
        <xsl:value-of select="$organisationName"/>
      </xsl:element>
      <xsl:element name="{$role}Org{$fieldSuffix}">
        <xsl:value-of select="$organisationName"/>
      </xsl:element>
    </xsl:if>
    <xsl:element name="contact{$fieldSuffix}">
      <!-- TODO: Can be multilingual -->
      <xsl:attribute name="type" select="'object'"/>{
      "organisation":"<xsl:value-of
        select="gn-fn-index:json-escape($organisationName)"/>",
      "role":"<xsl:value-of select="$role"/>",
      "email":"<xsl:value-of select="$email"/>",
      "website":"<xsl:value-of select="$website"/>",
      "logo":"<xsl:value-of select="$logo"/>",
      "individual":"<xsl:value-of select="gn-fn-index:json-escape($individualName)"/>",
      "position":"<xsl:value-of select="gn-fn-index:json-escape($positionName)"/>",
      "phone":"<xsl:value-of select="gn-fn-index:json-escape($phone)"/>",
      "address":"<xsl:value-of select="gn-fn-index:json-escape($address)"/>"
      }
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
