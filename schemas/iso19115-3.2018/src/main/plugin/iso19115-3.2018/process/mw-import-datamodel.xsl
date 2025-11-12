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
  <xsl:param name="replaceExistingContentInfo" select="false()" as="xs:boolean"/>

  <xsl:variable name="datamodel-registration-loc">
    <msg id="a" xml:lang="eng">Import data model from JSON specification: </msg>
    <msg id="a" xml:lang="fre">Importer le modèle de données à partir du format JSON : </msg>
  </xsl:variable>

  <xsl:template name="list-mw-import-datamodel">
    <suggestion process="mw-import-datamodel"/>
  </xsl:template>

  <xsl:variable name="jsonDataModelSpec"
                select="//mdb:contentInfo/*/mrc:featureCatalogueCitation/*/cit:onlineResource/*/cit:linkage/gco:CharacterString[ends-with(., '.json')]"/>

  <xsl:template name="analyze-mw-import-datamodel">
    <xsl:param name="root"/>

    <xsl:if test="normalize-space($jsonDataModelSpec)">
      <xsl:variable name="id"
                    select="generate-id(.)"/>

      <suggestion process="mw-import-datamodel"
                  id="{concat($id, '-', position())}"
                  category="contentinfo"
                  target="metadata">
        <name>
          <xsl:value-of select="geonet:i18n($datamodel-registration-loc, 'a', $guiLang)"/><xsl:value-of select="$jsonDataModelSpec"/>
        </name>
        <operational>true</operational>
        <params>{"dataModelUrl":{
          "type":"string",
          "defaultValue":"<xsl:value-of select="$jsonDataModelSpec"/>"}
          }</params>
      </suggestion>
    </xsl:if>
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

      <xsl:copy-of select="geonet:make-iso19115-3.2018-featurecatalogue-from-mwdatamodel($dataModelUrl, ., $replaceExistingContentInfo)"/>


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
  <xsl:function name="geonet:make-iso19115-3.2018-featurecatalogue-from-mwdatamodel" as="node()*">
    <xsl:param name="dataModelUrl" as="xs:string"/>
    <xsl:param name="metadata" as="node()"/>
    <xsl:param name="replaceExistingContentInfo" as="xs:boolean"/>

    <!-- Get JSON spec as XM -->
    <xsl:variable name="dataModelSpec"
                  select="util:downloadJsonAsXML($dataModelUrl)"/>

    <xsl:if test="not($replaceExistingContentInfo)">
      <xsl:for-each select="$metadata/mdb:contentInfo[
                                                    not(*/mrc:featureCatalogue/*/gfc:identifier/*/mcc:code/gco:CharacterString)
                                                    or */mrc:featureCatalogue/*/gfc:identifier/*/mcc:code/gco:CharacterString != $dataModelSpec/root/guid]">
        <xsl:apply-templates select="."/>
      </xsl:for-each>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="$dataModelSpec">
        <mdb:contentInfo>
          <mrc:MD_FeatureCatalogue>
            <mrc:featureCatalogue>
              <gfc:FC_FeatureCatalogue>
                <xsl:for-each select="$dataModelSpec/root/full_name">
                  <cat:name>
                    <gco:CharacterString><xsl:value-of select="current()"/></gco:CharacterString>
                  </cat:name>
                </xsl:for-each>
                <xsl:for-each select="$dataModelSpec/root/version">
                  <cat:versionNumber>
                    <gco:CharacterString><xsl:value-of select="current()"/></gco:CharacterString>
                  </cat:versionNumber>
                </xsl:for-each>

                <xsl:variable name="now" select="format-date(current-date(), '[Y0001]-[M01]-[D01]')"/>

                <xsl:for-each select="($dataModelSpec/root/version_date, $now)[1]">
                  <cat:versionDate>
                    <gco:Date><xsl:value-of select="current()"/></gco:Date>
                  </cat:versionDate>
                </xsl:for-each>
                <xsl:for-each select="distinct-values($dataModelSpec//root/encoding)">
                  <cat:characterSet>
                    <lan:MD_CharacterSetCode codeList="http://standards.iso.org/iso/19115/resources/Codelists/cat/codelists.xml#MD_CharacterSetCode"
                                             codeListValue="{if (current() = 'UTF-8') then 'utf8' else current()}"/>
                  </cat:characterSet>
                </xsl:for-each>
                <xsl:for-each select="$dataModelSpec/root/guid">
                  <gfc:identifier>
                    <mcc:MD_Identifier>
                      <mcc:code>
                        <gco:CharacterString><xsl:value-of select="current()"/></gco:CharacterString>
                      </mcc:code>
                    </mcc:MD_Identifier>
                  </gfc:identifier>
                </xsl:for-each>
                <gfc:producer>
                  <cit:CI_Responsibility>
                    <cit:role>
                      <cit:CI_RoleCode codeList="http://standards.iso.org/iso/19115/resources/Codelists/cat/codelists.xml#CI_RoleCode"
                                       codeListValue="author"/>
                    </cit:role>
                    <cit:party>
                      <cit:CI_Organisation>
                        <cit:name gco:nilReason="missing">
                          <gco:CharacterString/>
                        </cit:name>
                      </cit:CI_Organisation>
                    </cit:party>
                  </cit:CI_Responsibility>
                </gfc:producer>
                    <xsl:for-each select="$dataModelSpec//layers">
                      <gfc:featureType>
                        <gfc:FC_FeatureType>
                          <xsl:for-each select="(alias, name)[1]">
                            <gfc:typeName><xsl:value-of select="current()"/> </gfc:typeName>
                          </xsl:for-each>
                          <xsl:for-each select="semantic_description">
                            <gfc:definition>
                              <gco:CharacterString><xsl:value-of select="current()"/></gco:CharacterString>
                            </gfc:definition>
                          </xsl:for-each>
                          <xsl:for-each select="(name, alias)[1]">
                            <gfc:code>
                              <gco:CharacterString><xsl:value-of select="current()"/></gco:CharacterString>
                            </gfc:code>
                          </xsl:for-each>
                          <gfc:isAbstract>
                            <gco:Boolean>false</gco:Boolean>
                          </gfc:isAbstract>

                          <xsl:if test="spatial = 'true'">
                            <gfc:carrierOfCharacteristics>
                              <gfc:FC_FeatureAttribute>
                              <gfc:memberName><xsl:value-of select="'GEOMETRY'"/></gfc:memberName>
                              <gfc:definition>
                                <gco:CharacterString>
                                  <xsl:value-of select="geometry_description"/>
                                </gco:CharacterString>
                              </gfc:definition>
                              <gfc:cardinality>
                                <gco:CharacterString>
                                  <xsl:value-of select="if(mandatory) then '1..1' else '1..0'"/>
                                </gco:CharacterString>
                              </gfc:cardinality>
                              <gfc:designation>
                                <gco:CharacterString></gco:CharacterString>
                              </gfc:designation>
                              <gfc:code>
                                <gco:CharacterString><xsl:value-of select="'GEOMETRY'"/></gco:CharacterString>
                              </gfc:code>
                              <gfc:valueType>
                                <gco:TypeName>
                                  <gco:aName>
                                    <gco:CharacterString>
                                      <xsl:value-of select="concat(geometry_type, (if (n_3d = 'true') then ' - 3D' else ''), (if (linear_referencing_system = 'true') then ' - LRS' else ''), (if (crs != '') then concat(' (', crs, ')') else ''))"/>
                                    </gco:CharacterString>
                                  </gco:aName>
                                </gco:TypeName>
                              </gfc:valueType>
                              </gfc:FC_FeatureAttribute>
                            </gfc:carrierOfCharacteristics>
                          </xsl:if>

                          <xsl:for-each select="attributes">
                            <gfc:carrierOfCharacteristics>
                              <gfc:FC_FeatureAttribute>
                                <gfc:memberName><xsl:value-of select="name"/></gfc:memberName>
                                <gfc:definition>
                                  <gco:CharacterString><xsl:value-of select="description"/></gco:CharacterString>
                                </gfc:definition>
                                <gfc:cardinality>
                                  <gco:CharacterString>
                                    <xsl:value-of select="if(mandatory) then '1..1' else '1..0'"/>
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
