<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:mdb="http://standards.iso.org/iso/19115/-3/mdb/2.0"
                xmlns:mri="http://standards.iso.org/iso/19115/-3/mri/1.0"
                xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/2.0"
                xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
                xmlns:gn="http://www.fao.org/geonetwork"
                xmlns:saxon="http://saxon.sf.net/"
                extension-element-prefixes="saxon"
                exclude-result-prefixes="#all">
  <xsl:import href="process-utility.xsl"/>

  <xsl:output indent="yes" method="xml"/>



  <xsl:variable name="mw-add-publisher-loc">
    <msg id="add" xml:lang="eng">Add publisher information.</msg>
    <msg id="add" xml:lang="fre">Ajouter des informations sur l'éditeur (publication).</msg>
  </xsl:variable>

  <xsl:template name="list-mw-add-publisher">
    <suggestion process="mw-add-publisher"/>
  </xsl:template>

  <xsl:template name="analyze-mw-add-publisher">
    <xsl:param name="root"/>

    <xsl:variable name="hasPublisher"
                  select="count($root//mdb:identificationInfo/*/mri:pointOfContact/cit:CI_Responsibility[cit:role/*/@codeListValue = 'publisher']) > 0"/>

    <xsl:variable name="id"
                  select="generate-id(.)"/>

    <xsl:if test="not($hasPublisher)">
      <suggestion process="mw-add-publisher"
                  id="{$id}"
                  category="publisher">
        <name><xsl:value-of select="gn:i18n($mw-add-publisher-loc, 'add', $guiLang)"/></name>
        <operational>true</operational>
        <params>{}</params>
      </suggestion>
    </xsl:if>
  </xsl:template>




  <xsl:template match="mdb:identificationInfo/*/mri:pointOfContact[cit:CI_Responsibility]">
    <xsl:variable name="contactTagName"
                  select="name()"/>

    <xsl:if test="preceding-sibling::*[1][name() != $contactTagName]">
      <xsl:variable name="hasPublisher"
                    select="count(../*[name() = $contactTagName and */cit:role/*/@codeListValue = 'publisher']) > 0"/>

      <xsl:if test="not($hasPublisher)">
        <xsl:variable name="siblingCustodians"
                      select="../*[
                      name() = $contactTagName
                      and */cit:role/*/@codeListValue = 'custodian'
                      and matches(*/cit:party/cit:CI_Organisation/cit:name/gco:CharacterString, '.* \(SPW.*\)')]"/>
        <xsl:for-each select="$siblingCustodians">
          <xsl:element name="{$contactTagName}">
            <cit:CI_Responsibility>
              <cit:role>
                <cit:CI_RoleCode codeList="http://standards.iso.org/iso/19139/resources/gmxCodelists.xml#CI_RoleCode"
                                 codeListValue="publisher"/>
              </cit:role>
              <cit:party>
                <cit:CI_Organisation>
                  <cit:name>
                    <gco:CharacterString>
                      <xsl:value-of select="replace(*/cit:party/cit:CI_Organisation/cit:name/gco:CharacterString, '(.*) \(SPW.*\)', '$1')"/>
                    </gco:CharacterString>
                  </cit:name>

                  <xsl:variable name="email"
                                select="*/cit:party/cit:CI_Organisation/cit:contactInfo/*/cit:address/*/cit:electronicMailAddress/gco:CharacterString"/>

                  <xsl:if test="$email">
                    <cit:contactInfo>
                      <cit:CI_Contact>
                        <cit:address>
                          <cit:CI_Address>
                            <cit:electronicMailAddress>
                              <gco:CharacterString><xsl:value-of select="$email"/></gco:CharacterString>
                            </cit:electronicMailAddress>
                          </cit:CI_Address>
                        </cit:address>
                      </cit:CI_Contact>
                    </cit:contactInfo>
                  </xsl:if>
                </cit:CI_Organisation>
              </cit:party>
            </cit:CI_Responsibility>
          </xsl:element>
        </xsl:for-each>
      </xsl:if>
    </xsl:if>

    <xsl:copy-of select="."/>
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
