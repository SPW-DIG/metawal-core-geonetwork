<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/2.0"
                xmlns:mdb="http://standards.iso.org/iso/19115/-3/mdb/2.0"
                xmlns:mri="http://standards.iso.org/iso/19115/-3/mri/1.0"
                xmlns:mco="http://standards.iso.org/iso/19115/-3/mco/1.0"
                xmlns:mdq="http://standards.iso.org/iso/19157/-2/mdq/1.0"
                xmlns:mrl="http://standards.iso.org/iso/19115/-3/mrl/2.0"
                xmlns:mrs="http://standards.iso.org/iso/19115/-3/mrs/1.0"
                xmlns:mcc="http://standards.iso.org/iso/19115/-3/mcc/1.0"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:mdUtil="java:org.fao.geonet.api.records.MetadataUtils"
                xmlns:util="java:org.fao.geonet.util.XslUtil"
                xmlns:dcat="http://www.w3.org/ns/dcat#"
                xmlns:dct="http://purl.org/dc/terms/"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:foaf="http://xmlns.com/foaf/0.1/"
                exclude-result-prefixes="#all">

  <xsl:variable name="nodeUrl"
                select="util:getSettingValue('nodeUrl')"/>

  <!-- Resource
   Unsupported:
   * dcat:first|previous(sameAs replaces, previousVersion?)|next|last|hasVersion (using the Associated API, navigate to series and sort by date?)
   * dct:isReferencedBy (using the Associated API)
   * dcat:hasCurrentVersion  (using the Associated API)
   * dct:rights
   * odrl:hasPolicy
   -->
  <xsl:template mode="iso19115-3-to-dcat-resource"
                name="iso19115-3-to-dcat-resource"
                match="mdb:MD_Metadata">
    <xsl:apply-templates mode="iso19115-3-to-dcat"
                         select="mdb:identificationInfo/*/mri:citation/*/cit:title
                                  |mdb:identificationInfo/*/mri:abstract
                                  |mdb:identificationInfo/*/mri:citation/*/cit:identifier
                                  |mdb:identificationInfo/*/mri:citation/*/cit:date/*[cit:dateType/*/@codeListValue = $isoDateTypeToDcatCommonNames/text()]/cit:date
                                  |mdb:identificationInfo/*/mri:citation/*/cit:edition
                                  |mdb:identificationInfo/*/mri:defaultLocale
                                  |mdb:identificationInfo/*/mri:otherLocale
                                  |mdb:identificationInfo/*/mri:resourceConstraints/*[mco:useConstraints]
                                  |mdb:identificationInfo/*/mri:resourceConstraints/*[mco:accessConstraints]
                                  |mdb:identificationInfo/*/mri:status
                                  |mdb:identificationInfo/*/mri:descriptiveKeywords
                                  |mdb:identificationInfo/*/mri:pointOfContact
                                  |mdb:identificationInfo/*/mri:associatedResource
                                  |mdb:dataQualityInfo/*/mdq:report/*/mdq:result[mdq:DQ_ConformanceResult and mdq:DQ_ConformanceResult/mdq:pass/*/text() = 'true']
                                  |mdb:resourceLineage/*/mrl:statement
                                  |mdb:metadataLinkage
                          "/>

    <xsl:call-template name="related-record"/>

  </xsl:template>



<!--  <xsl:template mode="iso19115-3-to-eu-dcat-ap"
                match="mrl:source">
    <dct:source>
    Need to point to the Dataset and not the CatalogRecord
    See below
      <xsl:call-template name="rdf-object-ref-attribute">
        <xsl:with-param name="isAbout" select="false()"/>
      </xsl:call-template>
    </dct:source>
  </xsl:template>-->


  <xsl:template name="related-record">
    <xsl:variable name="associations"
                        select="mdUtil:getAssociatedAsXml(mdb:metadataIdentifier/*/mcc:code/*/text())"
                        as="node()?"/>

    <xsl:variable name="legislations"
                        select="mdb:identificationInfo/*/mri:descriptiveKeywords/*/mri:keyword[starts-with(*/@xlink:href, 'http://data.europa.eu/eli')]"/>

    <xsl:for-each select="$associations/relations/*">
      <xsl:variable name="recordUri"
                    select="if (root/resourceIdentifier) then concat(root/resourceIdentifier[1]/codeSpace, root/resourceIdentifier[1]/code) else @url" />

      <xsl:choose>
        <xsl:when test="local-name() = 'parent'">
          <dcat:inSeries rdf:resource="{$recordUri}"/>
        </xsl:when>
        <xsl:when test="local-name() = 'brothersAndSisters'">
          <dct:relation rdf:resource="{$recordUri}"/>
        </xsl:when>
        <xsl:when test="local-name() = 'sources'">
          <dct:source rdf:resource="{$recordUri}"/>
        </xsl:when>
        <xsl:when test="local-name() = 'services'">
          <xsl:variable name="mainLink"
                        select="root/link[1]"/>

          <xsl:variable name="serviceUri"
                        select="if (root/resourceIdentifier) then concat(root/resourceIdentifier[1]/codeSpace, root/resourceIdentifier[1]/code) else ." />

          <dcat:distribution>
            <dcat:Distribution>
              <xsl:for-each select="$mainLink/urlObject/default">
                <dcat:accessURL rdf:resource="{.}"/>
                <dcat:accessService rdf:resource="{$serviceUri}"/>
              </xsl:for-each>
              <dct:title><xsl:value-of select="root/resourceTitleObject/default"/></dct:title>
              <dct:description xml:lang="fre"><xsl:value-of select="root/resourceAbstractObject/default"/></dct:description>

              <xsl:apply-templates mode="iso19115-3-to-dcat"
                                   select="$legislations"/>

              <xsl:call-template name="rdf-format-as-mediatype">
                <xsl:with-param name="format" select="$mainLink/protocol"/>
              </xsl:call-template>
            </dcat:Distribution>
          </dcat:distribution>
        </xsl:when>
        <xsl:otherwise>
          <!-- TODO: other type of relations -->
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
