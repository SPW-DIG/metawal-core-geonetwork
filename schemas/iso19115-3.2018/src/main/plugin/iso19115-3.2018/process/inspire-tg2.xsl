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

  <xsl:variable name="inspire-themes"
                select="document(concat('file:///', $thesauriDir, '/external/thesauri/theme/httpinspireeceuropaeutheme-theme.rdf'))//skos:Concept"/>


  <xsl:variable name="inspire-pd"
                select="document(concat('file:///', $thesauriDir, '/external/thesauri/theme/httpinspireeceuropaeumetadatacodelistPriorityDataset-PriorityDataset.rdf'))//skos:Concept"/>


<!--
SQL query to get list value

<gmd:resourceConstraints>
		  <gmd:MD_LegalConstraints>
			  <gmd:accessConstraints>
				  <gmd:MD_RestrictionCode codeList="http://standards.iso.org/iso/19139/resources/gmxCodelists.xml#MD_RestrictionCode" codeListValue="otherRestrictions" />
			  </gmd:accessConstraints>
			  <gmd:useConstraints>
				  <gmd:MD_RestrictionCode codeList="http://standards.iso.org/iso/19139/resources/gmxCodelists.xml#MD_RestrictionCode" codeListValue="otherRestrictions" />
			  </gmd:useConstraints>
			  <gmd:otherConstraints>
				  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/LimitationsOnPublicAccess/noLimitations"> No limitations on public access </gmx:Anchor>
			  </gmd:otherConstraints>
			  <gmd:otherConstraints>
  <gco:CharacterString>ACCÈS :
    Les conditions générales d'accès s’appliquent (http://geoportail.wallonie.be/files/documents/ConditionsSPW/DataSPW-CGA.pdf)

    UTILISATION :
    Les conditions générales d'utilisation s'appliquent (http://geoportail.wallonie.be/files/documents/ConditionsSPW/DataSPW-CGU.pdf)
  </gco:CharacterString>
</gmd:otherConstraints>
  </gmd:MD_LegalConstraints>
  </gmd:resourceConstraints>

-->


  <!-- TODO: Migrate Thèmes INSPIRE, priority dataset, Spatial scope = Regional (only if Reporting INSPIRE) -->

  <xsl:variable name="isInspireRecord"
                select="count(//mri:keyword[gco:CharacterString = 'Reporting INSPIRE']) > 0"/>


  <!-- On last keyword blocl add a regional spatial scope. -->
  <xsl:template match="mri:descriptiveKeywords[
                            $isInspireRecord
                            and following-sibling::*[1]/name(.) != 'mri:descriptiveKeywords']">
    <xsl:copy>
      <xsl:apply-templates select="*"/>
    </xsl:copy>

    <mri:descriptiveKeywords>
      <mri:MD_Keywords>
        <mri:keyword>
          <gcx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialScope/regional">Régional</gcx:Anchor>
        </mri:keyword>
        <mri:type>
          <mri:MD_KeywordTypeCode codeList="http://standards.iso.org/iso/19139/resources/gmxCodelists.xml#MD_KeywordTypeCode"
                                  codeListValue="theme"/>
        </mri:type>
        <mri:thesaurusName>
          <cit:CI_Citation>
            <cit:title>
              <gcx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialScope#">Champ géographique</gcx:Anchor>
            </cit:title>
            <cit:date>
              <cit:CI_Date>
                <cit:date>
                  <gco:Date>2019-08-01</gco:Date>
                </cit:date>
                <cit:dateType>
                  <cit:CI_DateTypeCode codeList="http://standards.iso.org/iso/19139/resources/gmxCodelists.xml#CI_DateTypeCode"
                                       codeListValue="publication"/>
                </cit:dateType>
              </cit:CI_Date>
            </cit:date>
            <cit:identifier>
              <mcc:MD_Identifier>
                <mcc:code>
                  <gcx:Anchor xlink:href="http://localhost:8080/geonetwork/srv/eng/thesaurus.download?ref=external.theme.httpinspireeceuropaeumetadatacodelistSpatialScope-SpatialScope">geonetwork.thesaurus.external.theme.httpinspireeceuropaeumetadatacodelistSpatialScope-SpatialScope</gcx:Anchor>
                </mcc:code>
              </mcc:MD_Identifier>
            </cit:identifier>
          </cit:CI_Citation>
        </mri:thesaurusName>
      </mri:MD_Keywords>
    </mri:descriptiveKeywords>

  </xsl:template>


  <xsl:template match="mri:keyword[../mri:thesaurusName/*/cit:title/* = 'GEMET - INSPIRE themes, version 1.0']">
    <xsl:variable name="theme"
                  select="gco:CharacterString"/>
    <xsl:variable name="themeInThesaurus"
                  select="$inspire-themes[skos:prefLabel = $theme]"/>
    <xsl:choose>
      <xsl:when test="$theme != '' and
                      $themeInThesaurus">
        <xsl:copy>
          <gcx:Anchor xlink:href="{$themeInThesaurus/@rdf:about}"><xsl:value-of select="$theme"/> </gcx:Anchor>
        </xsl:copy>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>



  <xsl:template match="mri:keyword[../mri:thesaurusName/*/cit:title/* = 'INSPIRE priority data set']">
    <xsl:variable name="theme"
                  select="gco:CharacterString"/>
    <xsl:variable name="themeInThesaurus"
                  select="$inspire-pd[skos:prefLabel = $theme]"/>
    <xsl:choose>
      <xsl:when test="$theme != '' and
                      $themeInThesaurus">
        <xsl:copy>
          <gcx:Anchor xlink:href="{$themeInThesaurus/@rdf:about}"><xsl:value-of select="$theme"/> </gcx:Anchor>
        </xsl:copy>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>




  <xsl:template match="mri:thesaurusName/*/cit:date/*/cit:dateType/*/@codeListValue">
    <xsl:attribute name="codeListValue">publication</xsl:attribute>
  </xsl:template>



  <!-- Add the 2 inspire decimals ... -->
  <xsl:template match="gex:EX_GeographicBoundingBox/*/gco:Decimal[matches(., '^([0-9]+|[0-9]+.[0-9]{1})$')]">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:value-of select="format-number(., '#0.00')"/>
    </xsl:copy>
  </xsl:template>



  <!--
  List of current values:

  Aucune contrainte d'accès pour la consultation
  Aucune contrainte d'accès pour la consultation.
  Aucune restriction d'accès public au service de visualisation
  Aucune restriction d'accès public au service de visualisation.
  No limitations apply
  Pas de limitation d'utilisation au service
  -->
  <xsl:template match="mri:resourceConstraints/*/mco:*[
                        normalize-space(gco:CharacterString) = (
                          'no limitation',
                          'No limitations apply',
                          'Pas de limitation d''utilisation au service',
                          'Aucune restriction d''accès public au service de visualisation.',
                          'Aucune restriction d''accès public au service de visualisation',
                          'Aucune contrainte d''accès pour la consultation',
                          'Aucune contrainte d''accès pour la consultation.'
                          )]">
    <xsl:copy>
      <gcx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/LimitationsOnPublicAccess/noLimitations">No limitations to public access</gcx:Anchor>
    </xsl:copy>
  </xsl:template>


  <!--
  List of current values:
  No conditions apply
  no conditions apply to access and use
  No conditions apply to access and use
  No conditions apply to access and use.
  Aucune condition d'utilisation ne s'applique.
  Aucune condition ne s'applique
  Aucune condition ne s'applique.
  Aucune condition ne s’applique

  Question: FR or EN ?
  -->
  <xsl:template match="mri:resourceConstraints/*/mco:otherConstraints[
                        normalize-space(gco:CharacterString) = (
                            'Aucune condition d''utilisation ne s''applique.',
                            'Aucune condition ne s''applique',
                            'Aucune condition ne s''applique.',
                            'Aucune condition ne s’applique',
                            'no conditions apply',
                            'no conditions apply to access and use',
                            'No conditions apply to access and use',
                            'No conditions apply to access and use.')]">
    <mco:otherConstraints>
      <gcx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/ConditionsApplyingToAccessAndUse/noConditionsApply">Aucune condition d'utilisation ne s'applique.</gcx:Anchor>
    </mco:otherConstraints>
  </xsl:template>

  <xsl:template match="mri:resourceConstraints/*/mco:otherConstraints[
                        normalize-space(gco:CharacterString) = (
                            'Conditions unknown')]">
    <mco:otherConstraints>
      <gcx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/ConditionsApplyingToAccessAndUse/conditionsUnknown">Condition d'accès et d'utilisation inconnues.</gcx:Anchor>
    </mco:otherConstraints>
  </xsl:template>



  <!--
   Move all format to distributionInfo level (ie. none at distributor level).
   -->
  <xsl:template match="mrd:MD_Distribution">
    <xsl:copy>
      <xsl:apply-templates select="mrd:description"/>
      <xsl:for-each-group select="mrd:distributionFormat|.//mrd:distributorFormat"
                          group-by="*/mrd:formatSpecificationCitation/*/cit:title/*">
        <mrd:distributionFormat>
          <xsl:copy-of select="*"/>
        </mrd:distributionFormat>
      </xsl:for-each-group>
      <xsl:apply-templates select="mrd:distributor|mrd:transferOptions"/>
    </xsl:copy>
  </xsl:template>

  <!-- Drop all distributor format. -->
  <xsl:template match="mrd:distributor/*/mrd:distributorFormat"/>



  <!-- Add an anchor for  -->
  <xsl:template match="mdq:DQ_ConformanceResult/
                        mdq:specification/*/cit:title/gco:CharacterString[
                          contains(., '1089/2010')]">
    <gcx:Anchor xlink:href="http://data.europa.eu/eli/reg/2010/1089/2014-12-31">Commission RÈGLEMENT (UE) N o 1089/2010 DE LA COMMISSION du 23 novembre 2010 portant modalités d'application de la directive 2007/2/CE du Parlement européen et du Conseil en ce qui concerne l'interopérabilité des séries et des services de données géographiques</gcx:Anchor>
  </xsl:template>


  <!--
  Removal of
  <mdb:referenceSystemInfo xmlns:geonet="http://www.fao.org/geonetwork">
      <mrs:MD_ReferenceSystem>
         <mrs:referenceSystemIdentifier>
            <mcc:MD_Identifier>
               <mcc:code>
                  <gco:CharacterString>http://www.opengis.net/def/crs/EPSG/0/84</gco:CharacterString>
               </mcc:code>
            </mcc:MD_Identifier>
         </mrs:referenceSystemIdentifier>
      </mrs:MD_ReferenceSystem>
  </mdb:referenceSystemInfo>
  -->
  <xsl:template match="mdb:referenceSystemInfo[.//mcc:code/* = 'http://www.opengis.net/def/crs/EPSG/0/84']"/>


  <!-- Remove geonet:* elements. -->
  <xsl:template match="gn:*" priority="2"/>

  <!-- Copy everything. -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
