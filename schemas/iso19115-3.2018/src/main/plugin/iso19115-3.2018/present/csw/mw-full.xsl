<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:gn="http://www.fao.org/geonetwork"
  xmlns:gco115-3="http://standards.iso.org/iso/19115/-3/gco/1.0"
  xmlns:gco="http://www.isotc211.org/2005/gco"
  xmlns:gmd="http://www.isotc211.org/2005/gmd"
  xmlns:srv="http://www.isotc211.org/2005/srv"
  xmlns:mcc="http://standards.iso.org/iso/19115/-3/mcc/1.0"
  xmlns:gcx="http://standards.iso.org/iso/19115/-3/gcx/1.0"
  xmlns:mdb="http://standards.iso.org/iso/19115/-3/mdb/2.0"
  xmlns:mri="http://standards.iso.org/iso/19115/-3/mri/1.0"
  xmlns:srv115-3="http://standards.iso.org/iso/19115/-3/srv/2.1"
  xmlns:mco="http://standards.iso.org/iso/19115/-3/mco/1.0"
  xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/2.0"
  xmlns:lan="http://standards.iso.org/iso/19115/-3/lan/1.0"
  xmlns:srv2="http://standards.iso.org/iso/19115/-3/srv/2.1"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:util="java:org.fao.geonet.util.XslUtil"
  exclude-result-prefixes="#all">

  <xsl:import href="../../convert/ISO19139/toISO19139.xsl"/>

  <xsl:param name="displayInfo"/>

  <xsl:variable name="nodeUrl"
                select="util:getSettingValue('nodeUrl')"/>

  <!-- Replace all 115-3 anchors by CharacterString -->
  <xsl:template match="gcx:Anchor[count(ancestor::mdb:referenceSystemInfo) = 0]"
                priority="99999">
    <gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
  </xsl:template>

  <xsl:variable name="isUsingAnchorForConstraints"
                select="count(//mco:otherConstraints/*[@xlink:href]) > 0"/>

  <xsl:variable name="isService"
                select="count(//srv115-3:SV_ServiceIdentification) > 0"/>

  <xsl:variable name="isInspireRecord"
                select="count(//mri:keyword[gco:CharacterString = 'Reporting INSPIRE']) > 0"/>

  <xsl:variable name="isCGU"
                select="count(//mco:otherConstraints/*[@xlink:href='https://geoportail.wallonie.be/files/documents/ConditionsSPW/DataSPW-CGU.pdf']) > 0"/>

  <xsl:variable name="isCGA"
                select="count(//mco:otherConstraints/*[@xlink:href='https://geoportail.wallonie.be/files/documents/ConditionsSPW/DataSPW-CGA.pdf']) > 0"/>

  <xsl:variable name="isRestrictedA1"
                select="count(//mco:otherConstraints/*[@xlink:href='https://geoportail.wallonie.be/files/documents/ConditionsSPW/DataSPW-CPA-TypeA1.pdf']) > 0"/>

  <xsl:variable name="isRestrictedD1"
                select="count(//mco:otherConstraints/*[@xlink:href='https://geoportail.wallonie.be/files/documents/ConditionsSPW/DataSPW-CPA-TypeD1.pdf']) > 0"/>

  <xsl:variable name="isRestrictedCPUC"
                select="count(//mco:otherConstraints/*[@xlink:href='https://geoportail.wallonie.be/files/documents/ConditionsSPW/DataSPW-CPU-TypeC.pdf']) > 0"/>

  <xsl:variable name="isRestrictedCPUA"
                select="count(//mco:otherConstraints/*[@xlink:href='https://geoportail.wallonie.be/files/documents/ConditionsSPW/DataSPW-CPU-TypeA.pdf']) > 0"/>

  <xsl:template match="mri:resourceConstraints/*[mco:otherConstraints/*/text() = 'No limitations to public access']">
    <gmd:MD_LegalConstraints>
      <xsl:apply-templates select="mco:accessConstraints"/>
      <xsl:apply-templates select="mco:otherConstraints[not(contains(*, 'No limitations to public access'))]" />
    </gmd:MD_LegalConstraints>
  </xsl:template>


  <xsl:template match="mdb:identificationInfo">
    <gmd:identificationInfo>
      <xsl:apply-templates select="@*"/>
      <xsl:for-each select="./*">
        <xsl:variable name="nameSpacePrefix">
          <xsl:call-template name="getNamespacePrefix"/>
        </xsl:variable>

        <xsl:variable name="isService"
                      select="local-name(.) = 'SV_ServiceIdentification'"/>

        <xsl:element name="{concat($nameSpacePrefix,':',local-name(.))}">
          <xsl:apply-templates select="@*"/>
          <xsl:apply-templates select="mri:citation"/>
          <xsl:call-template name="writeCharacterStringElement">
            <xsl:with-param name="elementName" select="'gmd:abstract'"/>
            <xsl:with-param name="nodeWithStringToWrite" select="mri:abstract"/>
          </xsl:call-template>
          <xsl:call-template name="writeCharacterStringElement">
            <xsl:with-param name="elementName" select="'gmd:purpose'"/>
            <xsl:with-param name="nodeWithStringToWrite" select="mri:purpose"/>
          </xsl:call-template>
          <xsl:call-template name="writeCharacterStringElement">
            <xsl:with-param name="elementName" select="'gmd:credit'"/>
            <xsl:with-param name="nodeWithStringToWrite" select="mri:credit"/>
          </xsl:call-template>
          <xsl:call-template name="writeCodelistElement">
            <xsl:with-param name="elementName" select="'gmd:status'"/>
            <xsl:with-param name="codeListValue" select="mri:status/mcc:MD_ProgressCode/@codeListValue"/>
            <xsl:with-param name="codeListName" select="'gmd:MD_ProgressCode'"/>
          </xsl:call-template>
          <xsl:apply-templates select="mri:pointOfContact"/>
          <xsl:apply-templates select="mri:resourceMaintenance"/>
          <xsl:apply-templates select="mri:graphicOverview"/>
          <xsl:apply-templates select="mri:resourceFormat"/>
          <xsl:apply-templates select="mri:descriptiveKeywords"/>
          <xsl:apply-templates select="mri:resourceSpecificUsage"/>
          <xsl:apply-templates select="mri:resourceConstraints"/>
          <xsl:apply-templates select="mri:associatedResource"/>
          <xsl:call-template name="writeCodelistElement">
            <xsl:with-param name="elementName" select="'gmd:spatialRepresentationType'"/>
            <xsl:with-param name="codeListName" select="'gmd:MD_SpatialRepresentationTypeCode'"/>
            <xsl:with-param name="codeListValue" select="mri:spatialRepresentationType/mcc:MD_SpatialRepresentationTypeCode/@codeListValue"/>
          </xsl:call-template>
          <xsl:apply-templates select="mri:spatialResolution"/>
          <!-- This is here to handle early adopters of temporalResolution -->
          <xsl:apply-templates select="mri:temporalResolution"/>
          <xsl:apply-templates select="mri:defaultLocale/lan:PT_Locale/lan:language"/>
          <xsl:apply-templates select="mri:otherLocale/lan:PT_Locale/lan:language"/>
          <xsl:for-each select="mri:defaultLocale/lan:PT_Locale/lan:characterEncoding|
                                mri:otherLocale/lan:PT_Locale/lan:characterEncoding">
            <xsl:call-template name="writeCodelistElement">
              <xsl:with-param name="elementName" select="'gmd:characterSet'"/>
              <xsl:with-param name="codeListName" select="'gmd:MD_CharacterSetCode'"/>
              <xsl:with-param name="codeListValue" select="lan:MD_CharacterSetCode/@codeListValue"/>
            </xsl:call-template>
          </xsl:for-each>
          <xsl:apply-templates select="mri:topicCategory"/>

          <xsl:call-template name="writeCharacterStringElement">
            <xsl:with-param name="elementName" select="'gmd:environmentDescription'"/>
            <xsl:with-param name="nodeWithStringToWrite" select="mri:environmentDescription"/>
          </xsl:call-template>

          <!-- Service Identification Information -->
          <xsl:if test="srv2:serviceType">
            <srv:serviceType>
              <gco:LocalName>
<!--                <xsl:apply-templates select="srv2:serviceType/gco2:ScopedName/@codeSpace"/>-->
                <xsl:value-of select="srv2:serviceType/gco115-3:ScopedName"/>
              </gco:LocalName>
            </srv:serviceType>
          </xsl:if>

          <xsl:call-template name="writeCharacterStringElement">
            <xsl:with-param name="elementName" select="'srv:serviceTypeVersion'"/>
            <xsl:with-param name="nodeWithStringToWrite" select="srv2:serviceTypeVersion"/>
          </xsl:call-template>

          <xsl:apply-templates select="mri:extent | srv:extent"/>
          <xsl:call-template name="writeCharacterStringElement">
            <xsl:with-param name="elementName" select="'gmd:supplementalInformation'"/>
            <xsl:with-param name="nodeWithStringToWrite" select="mri:supplementalInformation"/>
          </xsl:call-template>
          <xsl:call-template name="writeCodelistElement">
            <xsl:with-param name="elementName" select="'srv:couplingType'"/>
            <xsl:with-param name="codeListName" select="'srv:SV_CouplingType'"/>
            <xsl:with-param name="codeListValue" select="srv2:couplingType/srv2:SV_CouplingType/@codeListValue"/>
          </xsl:call-template>
          <xsl:apply-templates select="srv2:containsOperations"/>

          <!-- Add mandatory contains operation -->
          <xsl:if test="$isService and not(srv2:containsOperations)">
            <srv:containsOperations/>
          </xsl:if>

          <xsl:apply-templates select="srv2:operatesOn"/>
        </xsl:element>
      </xsl:for-each>
    </gmd:identificationInfo>
  </xsl:template>


  <xsl:template match="mri:resourceConstraints/*[mco:useLimitation/*/text() = 'Conditions d''accès et d''utilisation spécifiques' and $isUsingAnchorForConstraints]">
    <gmd:MD_LegalConstraints>
      <!--xsl:apply-templates select="mco:useLimitation|mco:useConstraints"/-->
      <xsl:apply-templates select="mco:useConstraints"/>
      <gmd:otherConstraints>
        <xsl:choose>
          <xsl:when test="$isRestrictedA1">
            <gco:CharacterString>ACCÈS : Les conditions générales d'accès s’appliquent (https://geoportail.wallonie.be/files/documents/ConditionsSPW/DataSPW-CGA.pdf) mais sont restreintes par les conditions particulières de type A1 (https://geoportail.wallonie.be/files/documents/ConditionsSPW/DataSPW-CPA-TypeA1.pdf).
              UTILISATION : Les conditions générales d'utilisation s'appliquent (https://geoportail.wallonie.be/files/documents/ConditionsSPW/DataSPW-CGU.pdf).</gco:CharacterString>
          </xsl:when>
          <xsl:when test="$isRestrictedD1">
            <gco:CharacterString>ACCÈS : Les conditions générales d'accès s’appliquent (https://geoportail.wallonie.be/files/documents/ConditionsSPW/DataSPW-CGA.pdf) mais sont restreintes par les conditions particulières de type D1 (https://geoportail.wallonie.be/files/documents/ConditionsSPW/DataSPW-CPA-TypeD1.pdf).
              UTILISATION : Les conditions générales d'utilisation s'appliquent (https://geoportail.wallonie.be/files/documents/ConditionsSPW/DataSPW-CGU.pdf).</gco:CharacterString>
          </xsl:when>
          <xsl:when test="$isRestrictedCPUA">
            <gco:CharacterString>ACCÈS : Les conditions générales d'accès s’appliquent (https://geoportail.wallonie.be/files/documents/ConditionsSPW/DataSPW-CGA.pdf).
              UTILISATION : Les conditions générales d'utilisation s'appliquent (https://geoportail.wallonie.be/files/documents/ConditionsSPW/DataSPW-CGU.pdf) mais sont étendues par les conditions particulières de type A(https://geoportail.wallonie.be/files/documents/ConditionsSPW/DataSPW-CPU-TypeA.pdf).</gco:CharacterString>
          </xsl:when>
          <xsl:when test="$isRestrictedCPUC">
            <gco:CharacterString>ACCÈS : Les conditions générales d'accès s’appliquent (https://geoportail.wallonie.be/files/documents/ConditionsSPW/DataSPW-CGA.pdf).
              UTILISATION : Les conditions générales d'utilisation s'appliquent (https://geoportail.wallonie.be/files/documents/ConditionsSPW/DataSPW-CGU.pdf) et sont étendues par les conditions particulières de type C (https://geoportail.wallonie.be/files/documents/ConditionsSPW/DataSPW-CPU-TypeC.pdf).</gco:CharacterString>
          </xsl:when>
          <xsl:otherwise>
            <gco:CharacterString>ACCÈS : Les conditions générales d'accès s’appliquent (https://geoportail.wallonie.be/files/documents/ConditionsSPW/DataSPW-CGA.pdf).
              UTILISATION : Les conditions générales d'utilisation s'appliquent (https://geoportail.wallonie.be/files/documents/ConditionsSPW/DataSPW-CGU.pdf).</gco:CharacterString>
          </xsl:otherwise>
        </xsl:choose>
      </gmd:otherConstraints>
    </gmd:MD_LegalConstraints>
  </xsl:template>


  <xsl:template match="mri:resourceConstraints[following-sibling::*[1]/name(.) != 'mri:resourceConstraints']">
    <gmd:resourceConstraints>
      <xsl:apply-templates select="*"/>
    </gmd:resourceConstraints>

    <!--
    Add aggregates http://metawal.wallonie.be/geonetwork/srv/api/records/1880/related?type=associated
    -->
    <xsl:variable name="apiUrlRelated"
                  select="concat($nodeUrl, 'api/records/', //mdb:metadataIdentifier/*/mcc:code/*/text(), '/related?type=associated&amp;type=brothersAndSisters')"/>
    <xsl:variable name="associatedRecords"
                  select="document($apiUrlRelated)"/>
    <xsl:variable name="existingAssociations"
                  select="../mri:associatedResource/*/mri:metadataReference/@uuidref"/>
    <xsl:for-each select="$associatedRecords/related/*/item">
      <xsl:variable name="uuid" select="id"/>
      <xsl:if test="count($existingAssociations[. = $uuid]) = 0">
        <xsl:comment>Added from <xsl:value-of select="$apiUrlRelated"/> </xsl:comment>
        <gmd:aggregationInfo>
          <gmd:MD_AggregateInformation>
            <gmd:aggregateDataSetIdentifier>
              <gmd:MD_Identifier>
                <gmd:code>
                  <gco:CharacterString><xsl:value-of select="$uuid"/></gco:CharacterString>
                </gmd:code>
              </gmd:MD_Identifier>
            </gmd:aggregateDataSetIdentifier>
            <gmd:associationType>
              <gmd:DS_AssociationTypeCode codeList="http://standards.iso.org/iso/19139/resources/gmxCodelists.xml#DS_AssociationTypeCode" codeListValue="crossReference" />
            </gmd:associationType>
          </gmd:MD_AggregateInformation>
        </gmd:aggregationInfo>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>


  <xsl:variable name="mwThemes">
    <item old="(1010) Faune et flore" new="Faune et flore"/>
    <item old="(1020) Eau" new="Eau"/>
    <item old="(1030) Sol et sous-sol" new="Sol et sous-sol"/>
    <item old="(1040) Air" new="Air"/>
    <item old="(10) Nature et environnement" new="Nature et environnement"/>
    <item old="(2010) Plans et règlements" new="Plans et règlements"/>
    <item old="(2020) Risques et contraintes" new="Risques et contraintes"/>
    <item old="(20) Aménagement du territoire" new="Aménagement du territoire"/>
    <item old="(3010) Routes" new="Routes"/>
    <item old="(3020) A pied et à vélo" new="A pied et à vélo"/>
    <item old="(3030) Voies navigables" new="Voies navigables"/>
    <item old="(3040) Transports en commun" new="Transports en commun"/>
    <item old="(30) Mobilité" new="Mobilité"/>
    <item old="(4010) Tourisme" new="Tourisme"/>
    <item old="(4020) Loisirs" new="Loisirs"/>
    <item old="(40) Tourisme et loisirs" new="Tourisme et loisirs"/>
    <item old="(5010) Données topographiques" new="Données topographiques"/>
    <item old="(5020) Limites administratives" new="Limites administratives"/>
    <item old="(5030) Photos et imagerie" new="Photos et imagerie"/>
    <item old="(5040) Cartes anciennes" new="Cartes anciennes"/>
    <item old="(50) Données de base" new="Données de base"/>
    <item old="(6010) Industrie et services" new="Industrie et services"/>
    <item old="(6020) Agriculture" new="Agriculture"/>
    <item old="(6030) Logement et habitat" new="Logement et habitat"/>
    <item old="(6040) Bruit" new="Bruit"/>
    <item old="(60) Société et activités" new="Société et activités"/>
  </xsl:variable>


  <xsl:template match="mri:descriptiveKeywords/*[mri:thesaurusName/*/cit:identifier/*/mcc:code/*/text() = 'geonetwork.thesaurus.external.theme.Themes_geoportail_wallon_hierarchy']">
    <gmd:MD_Keywords>
      <xsl:for-each select="mri:keyword/gco115-3:CharacterString">
        <gmd:keyword>
          <gco:CharacterString>
            <xsl:variable name="keyword"
                          select="."/>
            <xsl:value-of select="if ($mwThemes//item[@new = $keyword])
                                  then $mwThemes//item[@new = $keyword]/@old
                                  else $keyword"/>
          </gco:CharacterString>
        </gmd:keyword>
      </xsl:for-each>
      <xsl:apply-templates select="mri:type|mri:thesaurusName"/>
    </gmd:MD_Keywords>
  </xsl:template>


  <xsl:template match="/">
    <xsl:for-each select="/*">
      <xsl:variable name="info" select="gn:info"/>
      <xsl:variable name="nameSpacePrefix">
        <xsl:call-template name="getNamespacePrefix"/>
      </xsl:variable>
      <xsl:element name="{concat($nameSpacePrefix,':',local-name(.))}">
        <xsl:call-template name="add-namespaces"/>
        <xsl:apply-templates select="mdb:metadataIdentifier"/>
        <xsl:apply-templates select="mdb:defaultLocale"/>
        <xsl:apply-templates select="mdb:parentMetadata"/>
        <xsl:apply-templates select="mdb:metadataScope"/>
        <xsl:apply-templates select="mdb:contact"/>
        <xsl:apply-templates select="mdb:dateInfo"/>
        <xsl:apply-templates select="mdb:metadataStandard"/>
        <xsl:apply-templates select="mdb:metadataProfile"/>
        <xsl:apply-templates select="mdb:alternativeMetadataReference"/>
        <xsl:apply-templates select="mdb:otherLocale"/>
        <xsl:apply-templates select="mdb:metadataLinkage"/>
        <xsl:apply-templates select="mdb:spatialRepresentationInfo"/>
        <xsl:apply-templates select="mdb:referenceSystemInfo"/>
        <xsl:apply-templates select="mdb:metadataExtensionInfo"/>
        <xsl:apply-templates select="mdb:identificationInfo"/>
        <xsl:apply-templates select="mdb:contentInfo"/>
        <xsl:apply-templates select="mdb:distributionInfo"/>
        <xsl:apply-templates select="mdb:dataQualityInfo"/>
        <xsl:apply-templates select="mdb:resourceLineage"/>
        <xsl:apply-templates select="mdb:portrayalCatalogueInfo"/>
        <xsl:apply-templates select="mdb:metadataConstraints"/>
        <xsl:apply-templates select="mdb:applicationSchemaInfo"/>
        <xsl:apply-templates select="mdb:metadataMaintenance"/>
        <xsl:if test="$displayInfo = 'true'">
          <xsl:copy-of select="$info"/>
        </xsl:if>
      </xsl:element>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
