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

<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">

  <sch:title xmlns="http://www.w3.org/2001/XMLSchema">DCAT-AP High Value Dataset (HVD)</sch:title>
  <sch:ns prefix="gml" uri="http://www.opengis.net/gml"/>
  <sch:ns prefix="gmd" uri="http://standards.iso.org/iso/19115/-3/gmd"/>
  <sch:ns prefix="gmx" uri="http://standards.iso.org/iso/19115/-3/gmx"/>
  <sch:ns prefix="geonet" uri="http://www.fao.org/geonetwork"/>
  <sch:ns prefix="skos" uri="http://www.w3.org/2004/02/skos/core#"/>
  <sch:ns prefix="xlink" uri="http://www.w3.org/1999/xlink"/>
  <sch:ns prefix="srv" uri="http://standards.iso.org/iso/19115/-3/srv/2.0"/>
  <sch:ns prefix="mdb" uri="http://standards.iso.org/iso/19115/-3/mdb/2.0"/>
  <sch:ns prefix="mcc" uri="http://standards.iso.org/iso/19115/-3/mcc/1.0"/>
  <sch:ns prefix="mri" uri="http://standards.iso.org/iso/19115/-3/mri/1.0"/>
  <sch:ns prefix="mrs" uri="http://standards.iso.org/iso/19115/-3/mrs/1.0"/>
  <sch:ns prefix="mrd" uri="http://standards.iso.org/iso/19115/-3/mrd/1.0"/>
  <sch:ns prefix="mco" uri="http://standards.iso.org/iso/19115/-3/mco/1.0"/>
  <sch:ns prefix="msr" uri="http://standards.iso.org/iso/19115/-3/msr/2.0"/>
  <sch:ns prefix="lan" uri="http://standards.iso.org/iso/19115/-3/lan/1.0"/>
  <sch:ns prefix="gcx" uri="http://standards.iso.org/iso/19115/-3/gcx/1.0"/>
  <sch:ns prefix="gex" uri="http://standards.iso.org/iso/19115/-3/gex/1.0"/>
  <sch:ns prefix="dqm" uri="http://standards.iso.org/iso/19157/-2/dqm/1.0"/>
  <sch:ns prefix="cit" uri="http://standards.iso.org/iso/19115/-3/cit/2.0"/>
  <sch:ns prefix="mdq" uri="http://standards.iso.org/iso/19157/-2/mdq/1.0"/>
  <sch:ns prefix="mrl" uri="http://standards.iso.org/iso/19115/-3/mrl/2.0"/>
  <sch:ns prefix="gco" uri="http://standards.iso.org/iso/19115/-3/gco/1.0"/>
  <sch:ns prefix="mdUtil" uri="java:org.fao.geonet.api.records.MetadataUtils"/>

  <!-- HVD legislation -->
  <sch:diagnostic id="rule.hvd.legislation.mandatory-failure-en" xml:lang="en">
   Add the European HVD legislation (2023/138 - High Value Datasets Regulation) from the 'Applicable Legislations' thesaurus.
  </sch:diagnostic>
  <sch:diagnostic id="rule.hvd.legislation.mandatory-failure-fr" xml:lang="fr">
    Ajoutez la législation européenne HVD (2023/138 - High Value Datasets Regulation) à partir du thésaurus "Applicable Legislations".
  </sch:diagnostic>
  <sch:diagnostic id="rule.hvd.legislation.mandatory-success-en"
                  xml:lang="en">The European HVD legislation is encoded.
  </sch:diagnostic>
  <sch:diagnostic id="rule.hvd.legislation.mandatory-success-fr"
                  xml:lang="fr">La législation européenne HVD est encodée.
  </sch:diagnostic>
  <sch:pattern>
    <sch:title xml:lang="en">The HVD legislation MUST be specified</sch:title>
    <sch:title xml:lang="fr">La législation HVD DOIT être indiquée</sch:title>
    <sch:rule
      context="//*:MD_Metadata">
      <!-- https://semiceu.github.io/DCAT-AP/releases/3.0.0-hvd/#Dataset -->

      <!--
      applicable legislation	Legal Resource	1..*
      The legislation that mandates the creation or management of the Dataset.
      For HVD the value must include the ELI http://data.europa.eu/eli/reg_impl/2023/138/oj.
      As multiple legislations may apply to the resource the maximum cardinality is not limited.
      -->
      <sch:let name="hasOneKeywordEncodingHvdLegislationAsAnchor"
               value="count(*:identificationInfo/*/*:descriptiveKeywords/*/
                              *:keyword[*:Anchor/@xlink:href
                                  = 'http://data.europa.eu/eli/reg_impl/2023/138/oj']) = 1"/>

      <sch:assert test="$hasOneKeywordEncodingHvdLegislationAsAnchor"
                  diagnostics="rule.hvd.legislation.mandatory-failure-en rule.hvd.legislation.mandatory-failure-fr"/>
      <sch:report test="$hasOneKeywordEncodingHvdLegislationAsAnchor"
                  diagnostics="rule.hvd.legislation.mandatory-success-en rule.hvd.legislation.mandatory-success-fr"/>
    </sch:rule>
  </sch:pattern>

  <!-- HVD category-->
  <sch:diagnostic id="rule.hvd.category.mandatory-failure-en" xml:lang="en">
    Choose a top-level category from the 'High Value Datasets Categories' thesaurus.
  </sch:diagnostic>
  <sch:diagnostic id="rule.hvd.category.mandatory-failure-fr" xml:lang="fr">
    Choisissez une catégorie de premier niveau depuis le thésaurus "High Value Datasets Categories".
  </sch:diagnostic>
  <sch:diagnostic id="rule.hvd.category.mandatory-success-en"
                  xml:lang="en">
    HVD categories found:<sch:value-of select="concat(' ', string-join($hvdTopCategories, ', '))"/>.
  </sch:diagnostic>
  <sch:diagnostic id="rule.hvd.category.mandatory-success-fr"
                  xml:lang="fr">
    Catégories HVD encodées :<sch:value-of select="concat(' ', string-join($hvdTopCategories, ', '))"/>.
  </sch:diagnostic>
  <sch:pattern>
    <sch:title xml:lang="en">The resource MUST be classified under one of the HVD categories</sch:title>
    <sch:title xml:lang="fr">La ressource DOIT être classée dans une des catégories HVD</sch:title>
    <sch:rule context="//*:MD_Metadata">
      <!--
      HVD Category and subcategory
      Concept
      1..*
      The HVD category to which this Dataset belongs.
      P

         <mri:descriptiveKeywords>
            <mri:MD_Keywords>
               <mri:keyword>
                  <gcx:Anchor xlink:href="http://data.europa.eu/bna/c_ac64a52d">Géospatiales</gcx:Anchor>
               </mri:keyword>
               <mri:type>
                  <mri:MD_KeywordTypeCode codeList="http://standards.iso.org/iso/19115/resources/Codelists/cat/codelists.xml#MD_KeywordTypeCode"
                                          codeListValue="theme"/>
               </mri:type>
               <mri:thesaurusName>
                  <cit:CI_Citation>
                     <cit:title>
                        <gcx:Anchor xlink:href="http://data.europa.eu/bna/asd487ae75">High-value dataset categories</gcx:Anchor>
                     </cit:title>
      -->
      <sch:let name="hvdTopCategoriesUris"
               value="( 'http://data.europa.eu/bna/c_164e0bf5',
                             'http://data.europa.eu/bna/c_a9135398',
                             'http://data.europa.eu/bna/c_ac64a52d',
                             'http://data.europa.eu/bna/c_b79e35eb',
                             'http://data.europa.eu/bna/c_dd313021',
                             'http://data.europa.eu/bna/c_e1da4e07')"/>
      <sch:let name="hvdCategories"
               value="*:identificationInfo/*/*:descriptiveKeywords/*[
               *:thesaurusName/*/*:title/*:CharacterString = 'High-value dataset categories'
               or *:thesaurusName/*/*:title/*:Anchor/@xlink:href = 'http://data.europa.eu/bna/asd487ae75']/*:keyword/*[text() != '']"/>
      <sch:let name="hvdTopCategories"
               value="*:identificationInfo/*/*:descriptiveKeywords/*[
               *:thesaurusName/*/*:title/*:CharacterString = 'High-value dataset categories'
               or *:thesaurusName/*/*:title/*:Anchor/@xlink:href = 'http://data.europa.eu/bna/asd487ae75']/*:keyword/*:Anchor[@xlink:href = $hvdTopCategoriesUris]"/>
      <sch:let name="hasOneOrMoreKeywordEncodingHvdCategory"
               value="count($hvdCategories) > 0"/>
      <sch:let name="hasOneOrMoreKeywordEncodingHvdTopCategory"
                     value="count($hvdTopCategories) > 0"/>

      <sch:assert test="$hasOneOrMoreKeywordEncodingHvdTopCategory"
                  diagnostics="rule.hvd.category.mandatory-failure-en rule.hvd.category.mandatory-failure-fr"/>
      <sch:report test="$hasOneOrMoreKeywordEncodingHvdTopCategory"
                  diagnostics="rule.hvd.category.mandatory-success-en rule.hvd.category.mandatory-success-fr"/>
    </sch:rule>
  </sch:pattern>

    <!-- License -->
    <sch:diagnostic id="rule.hvd.license.mandatory-failure-en" xml:lang="en">
        Define an open-use license by selecting the value 'LicenseUnrestricted' from the 'Access Constraints' list and by specifying the applicable standard open license under 'Other Constraints'.
        The terms of use must be grouped in a 'Resource Constraints' block and kept separate from the access conditions.
      </sch:diagnostic>
      <sch:diagnostic id="rule.hvd.license.mandatory-failure-fr" xml:lang="fr">
        Définissez une licence d'utilisation ouverte en choisissant la valeur "LicenseUnrestricted" de la liste "Contraintes d'accès" et en mentionnant dans "Autres contraintes" la licence ouverte standard applicable.
        Les conditions d'utilisation doivent être regroupées dans un bloc de "Contraintes sur la ressource" et séparées des conditions d'accès.
      </sch:diagnostic>
      <sch:diagnostic id="rule.hvd.license.mandatory-success-en"
                      xml:lang="en">
        Open license found:<sch:value-of select="concat(' ', string-join($license, ', '))"/>.
      </sch:diagnostic>
      <sch:diagnostic id="rule.hvd.license.mandatory-success-fr"
                      xml:lang="fr">
        Licence ouverte encodée :<sch:value-of select="concat(' ', string-join($license, ', '))"/>.
      </sch:diagnostic>
    <sch:pattern>
      <sch:title xml:lang="en">An open-use license MUST be defined for an HVD dataset</sch:title>
      <sch:title xml:lang="fr">Une licence d'utilisation ouverte DOIT être définie pour une donnée HVD</sch:title>
      <sch:rule context="//*:MD_Metadata[(*:metadataScope/*/*:resourceScope|*:hierarchyLevel)/*/@codeListValue = 'dataset']">

        <sch:let name="isPublicLicenseType"
                        value="count(*:identificationInfo/*/*:resourceConstraints/*/*:useConstraints/*/@codeListValue[. = ('licenceUnrestricted')]) > 0"/>
        <sch:let name="license"
                 value="*:identificationInfo/*/*:resourceConstraints/*[*:useConstraints]/*:otherConstraints/*/@xlink:href"/>

        <sch:let name="hasPublicLicense"
                  value="$isPublicLicenseType and count($license) > 0"/>

        <sch:assert test="$hasPublicLicense"
                    diagnostics="rule.hvd.license.mandatory-failure-en rule.hvd.license.mandatory-failure-fr"/>
        <sch:report test="$hasPublicLicense"
                    diagnostics="rule.hvd.license.mandatory-success-en rule.hvd.license.mandatory-success-fr"/>

      </sch:rule>
    </sch:pattern>

    <!-- Public Distribution -->
    <sch:diagnostic id="rule.hvd.distribution.mandatory-failure-en" xml:lang="en">
      Add a download page (online resource with protocol 'WWW:LINK' and function 'download')
      OR a direct download link (online resource with protocol 'WWW:DOWNLOAD' and function 'download')
      OR a reference to the record of a visualization or download service.
    </sch:diagnostic>
    <sch:diagnostic id="rule.hvd.distribution.mandatory-failure-fr" xml:lang="fr">
       Ajoutez une page de téléchargement (ressource en ligne avec protocole "WWW:LINK" et fonction "download")
       OU un lien de téléchargement direct (ressource en ligne avec protocole "WWW:DOWNLOAD" et fonction "download")
       OU une relation vers la fiche d'un service de visualisation ou de téléchargement.
    </sch:diagnostic>
    <sch:diagnostic id="rule.hvd.distribution.mandatory-success-en"
                    xml:lang="en">
      Distribution URLs found:<sch:value-of select="concat(' ', string-join($distributions, ', '))"/>.
    </sch:diagnostic>
    <sch:diagnostic id="rule.hvd.distribution.mandatory-success-fr"
                    xml:lang="fr">
      URL(s) de distribution encodées :<sch:value-of select="concat(' ', string-join($distributions, ', '))"/>.
    </sch:diagnostic>
  <sch:pattern>
    <sch:title xml:lang="en">An HVD dataset MUST be accessible to the public</sch:title>
    <sch:title xml:lang="fr">Une donnée HVD DOIT être accessible au public</sch:title>
    <sch:rule
      context="//*:MD_Metadata[(*:metadataScope/*/*:resourceScope|*:hierarchyLevel)/*/@codeListValue = 'dataset']">

      <!--
        dataset distribution
        Distribution
        1..*
        An available Distribution for the Dataset.	The HVD IR is a quality improvement of existing datasets.
        The intention is that HVD datasets are publicly and open accessible.
        Therefore a Distribution is expected to be present. (Article 3.1)	Link	A

        See mapping dcat-core-distribution.xsl, foaf:page are created for
              $function = ('information', 'search', 'completeMetadata', 'browseGraphic', 'upload', 'emailService')
              or (not($function) and matches($protocol, 'WWW:LINK.*'))
        else it is a distribution
        -->
      <sch:let name="distributions"
               value="*:distributionInfo//*:onLine/*[*:linkage/(*:CharacterString|*:URL)/text() != ''][not(
                                        cit:function/*/@codeListValue = ('information', 'search', 'completeMetadata', 'browseGraphic', 'upload', 'emailService')
                                        or (not(cit:function/*/@codeListValue) and matches(*:protocol/*/text(), 'WWW:LINK.*')))]/*:linkage/(*:CharacterString|*:URL)"/>

      <sch:let name="hasOneOrMoreDistributions"
               value="count($distributions) > 0"/>

      <sch:assert test="$hasOneOrMoreDistributions"
                  diagnostics="rule.hvd.distribution.mandatory-failure-en rule.hvd.distribution.mandatory-failure-fr"/>
      <sch:report test="$hasOneOrMoreDistributions"
                  diagnostics="rule.hvd.distribution.mandatory-success-en rule.hvd.distribution.mandatory-success-fr"/>
    </sch:rule>
  </sch:pattern>


  <sch:diagnostic id="rule.hvd.contactPoint.mandatory-failure-en" xml:lang="en">
    Add a Responsible Party with the role of 'point of contact'.
  </sch:diagnostic>
  <sch:diagnostic id="rule.hvd.contactPoint.mandatory-failure-fr" xml:lang="fr">
    Ajoutez un Responsable avec le rôle "point de contact"
  </sch:diagnostic>
  <sch:diagnostic id="rule.hvd.contactPoint.mandatory-success-en"
                  xml:lang="en">
    Point of contact found:<sch:value-of
    select="concat(' ', string-join($resourcePointOfContact, ', '))"/>.
  </sch:diagnostic>
  <sch:diagnostic id="rule.hvd.contactPoint.mandatory-success-fr"
                  xml:lang="fr">
    Point de contact encodé :<sch:value-of
    select="concat(' ', string-join($resourcePointOfContact, ', '))"/>.
  </sch:diagnostic>
  <sch:pattern>
    <sch:title xml:lang="en">A point of contact MUST be defined</sch:title>
    <sch:title xml:lang="fr">Un point de contact DOIT être défini</sch:title>
    <sch:rule
      context="//*:MD_Metadata[(*:metadataScope/*/*:resourceScope|*:hierarchyLevel)/*/@codeListValue = 'service']">

      <!--
      contact point
      Kind
      0..* (dataset) 1..* (service)
      Contact information that can be used for sending comments about the Dataset.
      A

      <mri:pointOfContact>
        <cit:CI_Responsibility>
          <cit:role>
          <cit:CI_RoleCode codeList="http://standards.iso.org/iso/19115/resources/Codelists/cat/codelists.xml#CI_RoleCode" codeListValue="pointOfContact"/>
          </cit:role>

       Rule is more strict than HVD because contact point is mandatory in ISO and INSPIRE.
      -->
      <sch:let name="resourcePointOfContact"
               value="*:identificationInfo/*/*:pointOfContact/*[*:role/*/@codeListValue = 'pointOfContact']/*:party/*/*:name/*[text() != '']"/>
      <sch:let name="hasOneOrMorePointOfContact"
               value="count($resourcePointOfContact) > 0"/>

      <sch:assert test="$hasOneOrMorePointOfContact"
                  diagnostics="rule.hvd.contactPoint.mandatory-failure-en rule.hvd.contactPoint.mandatory-failure-fr"/>
      <sch:report test="$hasOneOrMorePointOfContact"
                  diagnostics="rule.hvd.contactPoint.mandatory-success-en rule.hvd.contactPoint.mandatory-success-fr"/>

    </sch:rule>
  </sch:pattern>

      <!--
      documentation (service)
      Document
      1..*
      A page that provides additional information about the Data Service.	Quality of service covers a broad spectrum of aspects.
      The HVD regulation does not list any mandatory topic. Therefore quality of service information is considered
      part of the generic documentation of a Data Service.
      P
      -->
  <sch:diagnostic id="rule.hvd.servicedocumentation.mandatory-failure-en" xml:lang="en">
    Add a declaration of conformity with an anchor, a link to the Spatineo page, a quality report, or an online resource using the 'information' function.
  </sch:diagnostic>
  <sch:diagnostic id="rule.hvd.servicedocumentation.mandatory-failure-fr" xml:lang="fr">
    Ajoutez une déclaration de conformité avec une ancre, un lien vers la page Spatineo, un rapport de qualité ou une ressource en ligne avec la fonction "information".
  </sch:diagnostic>
  <sch:diagnostic id="rule.hvd.servicedocumentation.mandatory-success-en"
                  xml:lang="en">
    Documentation pages found:<sch:value-of select="concat(' ', string-join($documentationUrls, ', '))"/>.
  </sch:diagnostic>
  <sch:diagnostic id="rule.hvd.servicedocumentation.mandatory-success-fr"
                  xml:lang="fr">
    Documentations encodées :<sch:value-of select="concat(' ', string-join($documentationUrls, ', '))"/>.
  </sch:diagnostic>
  <sch:pattern>
    <sch:title xml:lang="en">The service MUST be documented</sch:title>
    <sch:title xml:lang="fr">Le service DOIT être documenté</sch:title>
    <sch:rule
      context="//*:MD_Metadata[(*:metadataScope/*/*:resourceScope|*:hierarchyLevel)/*/@codeListValue = 'service']">
      <sch:let name="onlineResource"
               value=".//(*:distributionInfo//mrd:onLine
                            |*:portrayalCatalogueCitation/*/*:onlineResource
                            |*:additionalDocumentation/*/*:onlineResource
                            |*:reportReference/*/*:onlineResource
                            |*:reportReference/*/cit:title[*:Anchor/@xlink:href]
                            |*:specification/*/*:onlineResource
                            |*:specification/*/cit:title[*:Anchor/@xlink:href]
                            |*:featureCatalogueCitation/*/*:onlineResource)"/>
      <sch:let name="documentationUrls"
               value="$onlineResource[*/*:function/*/@codeListValue = ('information')
                                  or count(ancestor::*:additionalDocumentation) = 1
                                  or count(ancestor::*:DQ_ConformanceResult) = 1
                                  or count(ancestor::*:DQ_StandaloneQualityReportInformation) = 1
                                  or starts-with(*/*:linkage/(*:CharacterString|*:URL), 'https://directory.spatineo.com')]/(*/*:linkage/(*:CharacterString|*:URL)|*:Anchor/@xlink:href)"/>

      <sch:let name="hasOneOrMoreDocumentation"
               value="count($documentationUrls) > 0"/>

      <sch:assert test="$hasOneOrMoreDocumentation"
                  diagnostics="rule.hvd.servicedocumentation.mandatory-failure-en rule.hvd.servicedocumentation.mandatory-failure-fr"/>
      <sch:report test="$hasOneOrMoreDocumentation"
                  diagnostics="rule.hvd.servicedocumentation.mandatory-success-en rule.hvd.servicedocumentation.mandatory-success-fr"/>
    </sch:rule>
  </sch:pattern>

    <!--
  serves dataset
  Dataset
  1..*
  This property refers to a collection of data that this data service can distribute.
  An API in the context of HVD is not a standalone resource. It is used to open up HVD datasets.
  Therefore each Data Service is at least tightly connected with a Dataset.
  -->
  <sch:diagnostic id="rule.hvd.operateson.mandatory-failure-en" xml:lang="en">
    Establish a link between the service and the data it delivers by associating the service through the data’s metadata page
  </sch:diagnostic>
  <sch:diagnostic id="rule.hvd.operateson.mandatory-failure-fr" xml:lang="fr">
    Ajoutez un lien entre le service et la la donnée qu'il sert en ajoutant le service depuis la fiche de la donnée
  </sch:diagnostic>
  <sch:diagnostic id="rule.hvd.operateson.mandatory-success-en"
                  xml:lang="en">
    Operates on dataset found:<sch:value-of select="concat(' ', string-join($operatesOnDatasets, ', '))"/>.
  </sch:diagnostic>
  <sch:diagnostic id="rule.hvd.operateson.mandatory-success-fr"
                  xml:lang="fr">
    Données associées encodées :<sch:value-of select="concat(' ', string-join($operatesOnDatasets, ', '))"/>.
  </sch:diagnostic>
  <sch:pattern>
    <sch:title xml:lang="en">The service data MUST be specified</sch:title>
    <sch:title xml:lang="fr">La donnée service DOIT être indiquée</sch:title>
    <sch:rule
      context="//*:MD_Metadata[(*:metadataScope/*/*:resourceScope|*:hierarchyLevel)/*/@codeListValue = 'service']">
      <sch:let name="operatesOnDatasets"
               value=".//*:operatesOn/(@xlink:href[. != ''], @uuidref[. != ''])[1]"/>

      <sch:let name="hasOneOrMoreOperatesOn"
               value="count($operatesOnDatasets) > 0"/>

      <sch:assert test="$hasOneOrMoreOperatesOn"
                  diagnostics="rule.hvd.operateson.mandatory-failure-en rule.hvd.operateson.mandatory-failure-fr"/>
      <sch:report test="$hasOneOrMoreOperatesOn"
                  diagnostics="rule.hvd.operateson.mandatory-success-en rule.hvd.operateson.mandatory-success-fr"/>


    </sch:rule>
  </sch:pattern>
</sch:schema>
