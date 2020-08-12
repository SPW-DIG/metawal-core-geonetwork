<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:srv="http://standards.iso.org/iso/19115/-3/srv/2.1"
                xmlns:mri="http://standards.iso.org/iso/19115/-3/mri/1.0"
                xmlns:mco="http://standards.iso.org/iso/19115/-3/mco/1.0"
                xmlns:gcx="http://standards.iso.org/iso/19115/-3/gcx/1.0"
                xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/2.0"
                xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:gn="http://www.fao.org/geonetwork"
                xmlns:saxon="http://saxon.sf.net/"
                extension-element-prefixes="saxon"
                exclude-result-prefixes="#all">

  <xsl:output indent="yes" method="xml"/>

  <xsl:variable name="isService"
                select="count(//srv:SV_ServiceIdentification) > 0"/>

  <xsl:variable name="isInspireRecord"
                select="count(//mri:keyword[gco:CharacterString = 'Reporting INSPIRE']) > 0"/>

  <xsl:variable name="isRestrictedA1"
                select="count(//mco:otherConstraints/*[contains(., 'DataSPW-CPA-TypeA1')]) > 0"/>

  <xsl:variable name="isRestrictedD1"
                select="count(//mco:otherConstraints/*[contains(., 'DataSPW-CPA-TypeD1')]) > 0"/>

  <xsl:variable name="isRestrictedCPUC"
                select="count(//mco:otherConstraints/*[contains(., 'DataSPW-CPU-TypeC')]) > 0"/>

  <xsl:variable name="isRestrictedCPUA"
                select="count(//mco:otherConstraints/*[contains(., 'DataSPW-CPU-TypeA')]) > 0"/>



  <!-- Add helpdesk email to SPW Org when not set. -->
  <xsl:template match="cit:CI_Organisation[
                              cit:name/*/text() = 'Service public de Wallonie (SPW)'
                              and normalize-space(cit:contactInfo/*/cit:address/*/cit:electronicMailAddress) = '']/cit:contactInfo/*">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="cit:phone"/>

      <cit:address>
        <cit:CI_Address>
          <xsl:apply-templates select="cit:address/*/(cit:deliveryPoint|cit:city|cit:administrativeArea|cit:postalCode|cit:country)"/>
          <cit:electronicMailAddress>
            <gco:CharacterString>helpdesk.carto@spw.wallonie.be</gco:CharacterString>
          </cit:electronicMailAddress>
        </cit:CI_Address>
      </cit:address>

      <xsl:apply-templates select="cit:onlineResource|cit:hoursOfService|cit:contactInstructions|cit:contactType"/>
    </xsl:copy>
  </xsl:template>

  <!--
  We suppose we always have a resourceConstraints.
  We remove all.
  And on the last one, we do the update.
  -->
  <xsl:template match="mri:resourceConstraints"/>

  <xsl:template match="mri:resourceConstraints[following-sibling::*[1]/name(.) != 'mri:resourceConstraints']"
                priority="2">
    <!--
SQL :
* vérifier D1 ou A1
* uselimitation
* otherRestriction
* count(resourceConstraints)

WITH ns AS (
select ARRAY[ARRAY['xlink', 'http://www.w3.org/1999/xlink'],
       ARRAY['mdb', 'http://standards.iso.org/iso/19115/-3/mdb/2.0'],
       ARRAY['cit', 'http://standards.iso.org/iso/19115/-3/cit/2.0'],
       ARRAY['mri', 'http://standards.iso.org/iso/19115/-3/mri/1.0'],
       ARRAY['mco', 'http://standards.iso.org/iso/19115/-3/mco/1.0'],
       ARRAY['xsi', 'http://www.w3.org/2001/XMLSchema-instance'],
       ARRAY['gco', 'http://standards.iso.org/iso/19115/-3/gco/1.0']] AS n
)

SELECT distinct(unnest(xpath('//mdb:identificationInfo/*/mri:citation/*/cit:title/*/text()',
 XMLPARSE(DOCUMENT data), n)))::text  AS node,
 unnest(xpath('//mco:uselimitation/*/text()',
 XMLPARSE(DOCUMENT data), n))::text  AS uselimitation,
 unnest(xpath('//mco:otherConstraints/*/text()',
 XMLPARSE(DOCUMENT data), n))::text  AS otherConstraints,
 unnest(xpath('count(//mco:otherConstraints/*[contains(text(), ''DataSPW-CPA-TypeA1'')]) > 0',
 XMLPARSE(DOCUMENT data), n))::text  AS A1,
 unnest(xpath('count(//mco:otherConstraints/*[contains(text(), ''DataSPW-CPA-TypeD1'')]) > 0',
 XMLPARSE(DOCUMENT data), n))::text  AS D1,
 unnest(xpath('count(//mri:resourceConstraints)',
 XMLPARSE(DOCUMENT data), n))::text  AS nbRC
FROM metadata, ns
WHERE data LIKE '%%'
WHERE data LIKE '%Reporting INSPIRE<%'
     -->
    <xsl:choose>
      <xsl:when test="$isInspireRecord">
        <xsl:choose>
          <xsl:when test="$isService">
            <mri:resourceConstraints>
              <mco:MD_LegalConstraints>
                <mco:accessConstraints>
                  <mco:MD_RestrictionCode
                    codeList="http://standards.iso.org/iso/19139/resources/gmxCodelists.xml#MD_RestrictionCode"
                    codeListValue="otherRestrictions"/>
                </mco:accessConstraints>
                <mco:otherConstraints>
                  <gcx:Anchor
                    xlink:href="http://inspire.ec.europa.eu/metadata-codelist/LimitationsOnPublicAccess/noLimitations">
                    No limitations to public access
                  </gcx:Anchor>
                </mco:otherConstraints>
              </mco:MD_LegalConstraints>
            </mri:resourceConstraints>
            <mri:resourceConstraints>
              <mco:MD_LegalConstraints>
                <mco:useConstraints>
                  <mco:MD_RestrictionCode
                    codeList="http://standards.iso.org/iso/19139/resources/gmxCodelists.xml#MD_RestrictionCode"
                    codeListValue="otherRestrictions"/>
                </mco:useConstraints>
                <mco:useLimitation>
                  <gco:CharacterString>Conditions d'utilisation spécifiques</gco:CharacterString>
                </mco:useLimitation>
                <mco:otherConstraints>
                  <gco:CharacterString>Les conditions d'utilisation du service sont régies par les Conditions d’accès et d’utilisation des services web géographiques de visualisation du Service public de Wallonie consultables à l'adresse https://geoportail.wallonie.be/files/documents/ConditionsSPW/LicServicesSPW.pdf.</gco:CharacterString>
                </mco:otherConstraints>
              </mco:MD_LegalConstraints>
            </mri:resourceConstraints>
          </xsl:when>
          <xsl:otherwise>

            <mri:resourceConstraints>
              <mco:MD_LegalConstraints>
                <mco:accessConstraints>
                  <mco:MD_RestrictionCode
                    codeList="http://standards.iso.org/iso/19139/resources/gmxCodelists.xml#MD_RestrictionCode"
                    codeListValue="otherRestrictions"/>
                </mco:accessConstraints>
                <mco:otherConstraints>
                  <gcx:Anchor
                    xlink:href="http://inspire.ec.europa.eu/metadata-codelist/LimitationsOnPublicAccess/noLimitations">
                    No limitations to public access
                  </gcx:Anchor>
                </mco:otherConstraints>
              </mco:MD_LegalConstraints>
            </mri:resourceConstraints>

            <mri:resourceConstraints>
              <mco:MD_LegalConstraints>
                <mco:useLimitation>
                  <gco:CharacterString>Conditions d'accès et d'utilisation spécifiques</gco:CharacterString>
                </mco:useLimitation>

                <mco:useConstraints>
                  <mco:MD_RestrictionCode
                    codeList="http://standards.iso.org/iso/19139/resources/gmxCodelists.xml#MD_RestrictionCode"
                    codeListValue="otherRestrictions"/>
                </mco:useConstraints>

                <mco:otherConstraints>

                  <!--<xsl:message>
                    D<xsl:value-of select="$isRestrictedD1"/>
                    A<xsl:value-of select="$isRestrictedA1"/>
                    C<xsl:value-of select="$isRestrictedCPUC"/>
                  </xsl:message>-->
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
                </mco:otherConstraints>
              </mco:MD_LegalConstraints>
            </mri:resourceConstraints>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="../mri:resourceConstraints"/>
      </xsl:otherwise>
    </xsl:choose>
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
