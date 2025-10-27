<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:geonet="http://www.fao.org/geonetwork"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:mdb="http://standards.iso.org/iso/19115/-3/mdb/2.0"
                xmlns:cat="http://standards.iso.org/iso/19115/-3/cat/1.0"
                xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/2.0"
                xmlns:gcx="http://standards.iso.org/iso/19115/-3/gcx/1.0"
                xmlns:gex="http://standards.iso.org/iso/19115/-3/gex/1.0"
                xmlns:lan="http://standards.iso.org/iso/19115/-3/lan/1.0"
                xmlns:srv="http://standards.iso.org/iso/19115/-3/srv/2.0"
                xmlns:mas="http://standards.iso.org/iso/19115/-3/mas/1.0"
                xmlns:mcc="http://standards.iso.org/iso/19115/-3/mcc/1.0"
                xmlns:mco="http://standards.iso.org/iso/19115/-3/mco/1.0"
                xmlns:mda="http://standards.iso.org/iso/19115/-3/mda/1.0"
                xmlns:mds="http://standards.iso.org/iso/19115/-3/mds/2.0"
                xmlns:mdt="http://standards.iso.org/iso/19115/-3/mdt/2.0"
                xmlns:mex="http://standards.iso.org/iso/19115/-3/mex/1.0"
                xmlns:mmi="http://standards.iso.org/iso/19115/-3/mmi/1.0"
                xmlns:mpc="http://standards.iso.org/iso/19115/-3/mpc/1.0"
                xmlns:mrc="http://standards.iso.org/iso/19115/-3/mrc/2.0"
                xmlns:mrd="http://standards.iso.org/iso/19115/-3/mrd/1.0"
                xmlns:mri="http://standards.iso.org/iso/19115/-3/mri/1.0"
                xmlns:mrl="http://standards.iso.org/iso/19115/-3/mrl/2.0"
                xmlns:mrs="http://standards.iso.org/iso/19115/-3/mrs/1.0"
                xmlns:msr="http://standards.iso.org/iso/19115/-3/msr/2.0"
                xmlns:mdq="http://standards.iso.org/iso/19157/-2/mdq/1.0"
                xmlns:mac="http://standards.iso.org/iso/19115/-3/mac/2.0"
                xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
                xmlns:gfc="http://standards.iso.org/iso/19110/gfc/1.1"
                xmlns:gml="http://www.opengis.net/gml/3.2"
                xmlns:util="java:org.fao.geonet.util.XslUtil"
                xmlns:saxon="http://saxon.sf.net/"
                version="2.0" exclude-result-prefixes="#all">

  <xsl:import href="process-utility.xsl"/>

  <xsl:param name="dataModelUrl" select="''" as="xs:string"/>
  <xsl:param name="replaceExistingContentInfo" select="true()" as="xs:boolean"/>

  <xsl:variable name="datamodel-registration-loc">
    <msg id="a" xml:lang="eng">Import data model from JSON specification.</msg>
    <msg id="a" xml:lang="fre">Importer le modèle de données à partir du format JSON.</msg>
  </xsl:variable>

  <xsl:template name="list-mw-import-datamodel">
    <suggestion process="mw-import-datamodel"/>
  </xsl:template>

  <xsl:template name="analyze-mw-import-datamodel">
    <xsl:param name="root"/>

    <xsl:variable name="id"
                  select="generate-id(.)"/>

    <suggestion process="mw-import-datamodel"
                id="{concat($id, '-', position())}"
                category="contentinfo"
                target="metadata">
      <name>
        <xsl:value-of select="geonet:i18n($datamodel-registration-loc, 'a', $guiLang)"/>
      </name>
      <operational>true</operational>
      <params>{"dataModelUrl":{
        "type":"string",
        "defaultValue":"https://metawal.wallonie.be/geonetwork/srv/api/records/1b7fec23-6908-4c8c-88ed-7046bdbe4ff6/attachments/AC_TS.json"}
        }</params>
    </suggestion>
  </xsl:template>


  <!-- Do a copy of every nodes and attributes -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- Remove geonet:* elements. -->
  <xsl:template match="geonet:*" priority="2"/>


  <!-- Insert contact for the metadata -->
  <xsl:template
    match="mdb:MD_Metadata"
    priority="2">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates
        select="mdb:metadataIdentifier|
                mdb:defaultLocale|
                mdb:parentMetadata|
                mdb:metadataScope|
                mdb:dateInfo|
                mdb:metadataStandard|
                mdb:metadataProfile|
                mdb:alternativeMetadataReference|
                mdb:otherLocale|
                mdb:metadataLinkage|
                mdb:spatialRepresentationInfo|
                mdb:referenceSystemInfo|
                mdb:metadataExtensionInfo|
                mdb:identificationInfo"/>

      <xsl:copy-of select="geonet:make-iso19115-3.2018-featurecatalogue-from-mwdatamodel($dataModelUrl)"/>

      <xsl:if test="not($replaceExistingContentInfo)">
        <xsl:apply-templates
          select="mdb:contentInfo"/>
      </xsl:if>

      <xsl:apply-templates
        select="
                mdb:distributionInfo|
                mdb:dataQualityInfo|
                mdb:resourceLineage|
                mdb:portrayalCatalogueInfo|
                mdb:metadataConstraints|
                mdb:applicationSchemaInfo|
                mdb:metadataMaintenance|
                mdb:acquisitionInformation"/>

    </xsl:copy>
  </xsl:template>



  <!-- eg.
  https://metawal.wallonie.be/geonetwork/srv/api/records/1b7fec23-6908-4c8c-88ed-7046bdbe4ff6/attachments/AC_TS.json
   -->
  <xsl:function name="geonet:make-iso19115-3.2018-featurecatalogue-from-mwdatamodel" as="node()?">
    <xsl:param name="dataModelUrl" as="xs:string"/>

    <!-- Get JSON spec as XM -->
    <xsl:variable name="dataModelSpec"
                  select="util:downloadJsonAsXML($dataModelUrl)"/>


    <xsl:choose>
      <xsl:when test="$dataModelSpec">
        <mdb:contentInfo>
          <mrc:MD_FeatureCatalogue>
            <mrc:featureCatalogue>
              <gfc:FC_FeatureCatalogue>
                <xsl:for-each select="distinct-values($dataModelSpec//encoding)">
                  <cat:characterSet>
                    <lan:MD_CharacterSetCode codeList="http://standards.iso.org/iso/19115/resources/Codelists/cat/codelists.xml#MD_CharacterSetCode"
                                             codeListValue="{if (current() = 'UTF-8') then 'utf8' else current()}"/>
                  </cat:characterSet>
                </xsl:for-each>
                <gfc:producer></gfc:producer>
                    <xsl:for-each select="$dataModelSpec//layers">
                      <gfc:featureType>
                        <gfc:FC_FeatureType>
                          <gfc:typeName><xsl:value-of select="name"/> </gfc:typeName>
                          <gfc:isAbstract>
                            <gco:Boolean>false</gco:Boolean>
                          </gfc:isAbstract>
                          <xsl:for-each select="attributes">
                            <gfc:carrierOfCharacteristics>
                              <gfc:FC_FeatureAttribute>
                                <xsl:for-each select="(mandatory|stable|unique|encoding)">
                                  <gfc:constrainedBy>
                                    <gfc:FC_Constraint>
                                      <gfc:description>
                                        <gco:CharacterString><xsl:value-of select="concat(name(), ' : ', .)"/></gco:CharacterString>
                                      </gfc:description>
                                    </gfc:FC_Constraint>
                                  </gfc:constrainedBy>
                                </xsl:for-each>

                                <gfc:memberName><xsl:value-of select="name"/></gfc:memberName>
                                <gfc:definition>
                                  <gco:CharacterString><xsl:value-of select="description"/></gco:CharacterString>
                                </gfc:definition>
                                <gfc:cardinality>
                                  <gco:CharacterString>
                                  </gco:CharacterString>
                                </gfc:cardinality>
                                <gfc:designation>
                                  <gco:CharacterString><xsl:value-of select="alias"/></gco:CharacterString>
                                </gfc:designation>
                                <gfc:code>
                                  <gco:CharacterString><xsl:value-of select="short_name"/></gco:CharacterString>
                                </gfc:code>
                                <gfc:valueType>
                                  <gco:TypeName>
                                    <gco:aName>
                                      <gco:CharacterString>
                                        <xsl:value-of select="concat(type, ' (', format, ')')"/>
                                      </gco:CharacterString>
                                    </gco:aName>
                                  </gco:TypeName>
                                </gfc:valueType>

                                <!--<value_domain>1:= Oui || 0:= Non</value_domain> -->
                                <xsl:if test="value_domain != ''">
                                  <xsl:for-each select="tokenize(normalize-space(value_domain), ' \|\| ')">
                                    <xsl:variable name="details"
                                                  select="tokenize(current(), ':= ')"/>
                                    <gfc:listedValue>
                                      <gfc:FC_ListedValue>
                                        <gfc:label>
                                          <gco:CharacterString>
                                            <xsl:value-of select="$details[2]"/>
                                          </gco:CharacterString>
                                        </gfc:label>
                                        <gfc:code>
                                          <gco:CharacterString>
                                            <xsl:value-of select="$details[1]"/>
                                          </gco:CharacterString>
                                        </gfc:code>
                                        <gfc:definition>
                                          <gco:CharacterString></gco:CharacterString>
                                        </gfc:definition>
                                      </gfc:FC_ListedValue>
                                    </gfc:listedValue>
                                  </xsl:for-each>
                                </xsl:if>

                              </gfc:FC_FeatureAttribute>
                            </gfc:carrierOfCharacteristics>
                          </xsl:for-each>
                          <gfc:featureCatalogue/>
                        </gfc:FC_FeatureType>
                      </gfc:featureType>
                    </xsl:for-each>
              </gfc:FC_FeatureCatalogue>
            </mrc:featureCatalogue>
          </mrc:MD_FeatureCatalogue>
        </mdb:contentInfo>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message>Failed to retrieve document from: <xsl:value-of select="$dataModelUrl"/></xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
</xsl:stylesheet>
