<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:srv="http://standards.iso.org/iso/19115/-3/srv/2.1"
                xmlns:mds="http://standards.iso.org/iso/19115/-3/mds/2.0"
                xmlns:mcc="http://standards.iso.org/iso/19115/-3/mcc/1.0"
                xmlns:mri="http://standards.iso.org/iso/19115/-3/mri/1.0"
                xmlns:mrs="http://standards.iso.org/iso/19115/-3/mrs/1.0"
                xmlns:mrd="http://standards.iso.org/iso/19115/-3/mrd/1.0"
                xmlns:mdb="http://standards.iso.org/iso/19115/-3/mdb/2.0"
                xmlns:mrl="http://standards.iso.org/iso/19115/-3/mrl/2.0"
                xmlns:mrc="http://standards.iso.org/iso/19115/-3/mrc/2.0"
                xmlns:mmi="http://standards.iso.org/iso/19115/-3/mmi/1.0"
                xmlns:mco="http://standards.iso.org/iso/19115/-3/mco/1.0"
                xmlns:mdq="http://standards.iso.org/iso/19157/-2/mdq/1.0"
                xmlns:msr="http://standards.iso.org/iso/19115/-3/msr/2.0"
                xmlns:lan="http://standards.iso.org/iso/19115/-3/lan/1.0"
                xmlns:gcx="http://standards.iso.org/iso/19115/-3/gcx/1.0"
                xmlns:gex="http://standards.iso.org/iso/19115/-3/gex/1.0"
                xmlns:dqm="http://standards.iso.org/iso/19157/-2/dqm/1.0"
                xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/2.0"
                xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
                xmlns:mac="http://standards.iso.org/iso/19115/-3/mac/2.0"
                xmlns:gfc="http://standards.iso.org/iso/19110/gfc/1.1"
                xmlns:gts="http://www.isotc211.org/2005/gts"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:gml="http://www.opengis.net/gml/3.2"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:skos="http://www.w3.org/2004/02/skos/core#"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:gn="http://www.fao.org/geonetwork"
                xmlns:saxon="http://saxon.sf.net/"
                extension-element-prefixes="saxon"
                exclude-result-prefixes="#all">
  <xsl:output indent="yes" method="xml"/>

  <xsl:param name="thesauriDir"
             select="'/data/dev/gn/mw/web/src/main/webapp/WEB-INF/data/config/codelist'"/>

  <xsl:param name="thesaurusFileName"
             select="'httpinspireeceuropaeutheme-theme'"/>

  <xsl:variable name="thesaurus"
                select="document(concat('file:///', replace($thesauriDir, '\\', '/'), '/external/thesauri/theme/', $thesaurusFileName, '.rdf'))"/>

  <xsl:variable name="thesaurusTitle"
                select="$thesaurus//(skos:ConceptScheme|rdf:Description)/dc:title/text()"/>

  <xsl:variable name="isFormat"
                select="$thesaurusFileName = 'httpregistrymetawalcodelistmediatypes-media-types'"/>

  <xsl:variable name="formats">
    <entry old="GeoTIFF (.tif)" new="TIFF (.tif, .tiff)"/>
    <entry old="TIFF (.tif ou .tiff)" new="TIFF (.tif, .tiff)"/>
    <entry old="png" new="PNG (.png)"/>
    <entry old="ECW" new="ECW (.ecw)"/>
    <entry old="GML INSPIRE (.gml)" new="GML (.gml)"/>
    <entry old="KML (.kml ou .kmz)" new="KML (.kml)"/>
    <entry old="OGC:GeoPackage (.gpkg)" new="OGC GeoPackage (.gpkg)"/>
    <entry old="ESRI Personal Geodatabase (.mdb ou .accdb)" new="ESRI File Geodatabase (.fgdb)"/>
    <entry old="FGDBR (ESRI File Geodatabase Raster Dataset)" new="ESRI File Geodatabase (.fgdb)"/>
    <entry old="Ascii Grid" new="Ascii Grid (.asc ou .grd)"/>
    <entry old="DIMAP - JPEG2000 avec compression (.jp2)" new="JPEG2000 (.jp2, .jpg2, .j2k)"/>
    <entry old="Microsoft Excel (.xls ou .xlsx)" new="Microsoft Excel (.xlsx)"/>
    <entry old="ESRI Grid" new="Ascii Grid (.asc ou .grd)"/>
    <entry old="TXT (.txt)" new="Comma Separated Value (.csv)"/>
    <entry old="CSV (.csv)" new="Comma Separated Value (.csv)"/>
    <entry old="JPEG (.jpg ou .jpeg)" new=""/>
    <entry old="Application requérant une identification" new=""/>
    <entry old="S-57 (ENC) Hydrographic Data format" new=""/>
    <entry old="GPX (.gpx)" new=""/>
    <entry old="VHF" new=""/>
    <entry old="BSQ (band sequential image file)" new=""/>
    <entry old="-" new=""/>
    <entry old="Distribution en ligne uniquement" new=""/>
    <entry old="shp (ESRI shapefile)" new="ESRI Shapefile (.shp)"/>
    <entry old="RIS (Extensible Markup Language XML-RIS selon Directive 2005/44/CE)" new=""/>
    <entry old="*Autre format de distribution, cfr wiki*" new=""/>
    <entry old="JSON" new="JSON (.json)"/>
  </xsl:variable>

  <xsl:template match="mri:keyword[gco:CharacterString and ../mri:thesaurusName/*/cit:title/* = $thesaurusTitle]">
    <xsl:variable name="keywordValue"
                  select="gco:CharacterString"/>
    <xsl:variable name="keywordInThesaurus"
                  select="$thesaurus//*[skos:prefLabel = $keywordValue]"/>
    <xsl:choose>
      <xsl:when test="$keywordValue != '' and
                      $keywordInThesaurus">
        <xsl:copy>
          <gcx:Anchor xlink:href="{$keywordInThesaurus/@rdf:about}"><xsl:value-of select="$keywordValue"/> </gcx:Anchor>
          <xsl:copy-of select="lan:PT_FreeText"/>
        </xsl:copy>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message><xsl:value-of select="$keywordValue"/> not found in thesaurus <xsl:value-of select="$thesaurusTitle"/>. Skipping</xsl:message>
        <xsl:copy-of select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="mdb:distributionInfo/*/mrd:distributionFormat/*/mrd:formatSpecificationCitation/*/cit:title[gco:CharacterString and $isFormat]">
    <xsl:variable name="keywordValue"
                  select="gco:CharacterString"/>
    <xsl:variable name="keywordInMap"
                  select="$formats//*[@old = $keywordValue]/@new"/>
    <xsl:variable name="keywordInThesaurus"
                  select="if ($keywordInMap != '') then $thesaurus//*[skos:prefLabel = $keywordInMap] else $thesaurus//*[skos:prefLabel = $keywordValue]"/>
    <xsl:choose>
      <xsl:when test="$keywordValue != '' and
                      $keywordInThesaurus != ''">
        <xsl:copy>
          <gcx:Anchor xlink:href="{$keywordInThesaurus/@rdf:about}"><xsl:value-of select="if ($keywordInMap != '') then $keywordInMap else $keywordValue"/> </gcx:Anchor>
          <xsl:copy-of select="lan:PT_FreeText"/>
        </xsl:copy>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message><xsl:value-of select="$keywordValue"/> not found in thesaurus <xsl:value-of select="$thesaurusTitle"/>. Skipping</xsl:message>
        <xsl:copy-of select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="gn:*" priority="2"/>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
