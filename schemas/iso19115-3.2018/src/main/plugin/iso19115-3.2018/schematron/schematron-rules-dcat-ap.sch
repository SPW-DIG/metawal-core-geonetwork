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

  <sch:title xmlns="http://www.w3.org/2001/XMLSchema">DCAT-AP</sch:title>
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

<!-- Resource ID -->
  <sch:diagnostic id="rule.dcatap.resourceid.mandatory-failure-en" xml:lang="en">
    Resource identifier is mandatory. Add a citation identifier with a codespace starting with http.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.resourceid.mandatory-failure-fr" xml:lang="fr">
    L'identifiant de la ressource est obligatoire. Ajoutez un identifiant de citation avec un codespace commençant par
    http.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.resourceid.mandatory-success-en"
                  xml:lang="en">Resource identifier found:
    <sch:value-of select="string-join($resourceIdentifier, ', ')"/>
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.resourceid.mandatory-success-fr"
                  xml:lang="fr">Identifiant de la ressource encodé:
    <sch:value-of select="string-join($resourceIdentifier, ', ')"/>
  </sch:diagnostic>
  <sch:pattern id="resource-identifier">
    <sch:title xml:lang="en">Resource identifier is defined</sch:title>
    <sch:title xml:lang="fr">L'identifiant de la resource est défini</sch:title>
    <sch:rule context="//*:MD_Metadata">

      <sch:let name="resourceIdentifier"
               value="*:identificationInfo/*/*:citation/*/*:identifier/*[*:codeSpace/*[starts-with(text(), 'http')]]/*:code/*[text() != '']"/>
      <sch:let name="hasResourceIdentifier"
               value="count($resourceIdentifier) > 0"/>

      <sch:assert test="$hasResourceIdentifier"
                  diagnostics="rule.dcatap.resourceid.mandatory-failure-en rule.dcatap.resourceid.mandatory-failure-fr"/>
      <sch:report test="$hasResourceIdentifier"
                  diagnostics="rule.dcatap.resourceid.mandatory-success-en rule.dcatap.resourceid.mandatory-success-fr"/>
    </sch:rule>
    </sch:pattern>

    <!-- Resource TITLE-->
    <sch:diagnostic id="rule.dcatap.resourcetitle.mandatory-failure-en" xml:lang="en">
      Add resource title.
    </sch:diagnostic>
    <sch:diagnostic id="rule.dcatap.resourcetitle.mandatory-failure-fr" xml:lang="fr">
      Ajoutez le titre de la resource.
    </sch:diagnostic>
    <sch:diagnostic id="rule.dcatap.resourcetitle.mandatory-success-en"
                    xml:lang="en">Resource title found:
      <sch:value-of select="$resourceTitle"/>
    </sch:diagnostic>
    <sch:diagnostic id="rule.dcatap.resourcetitle.mandatory-success-fr"
                    xml:lang="fr">Titre de la resource encodé :
      <sch:value-of select="$resourceTitle"/>
    </sch:diagnostic>
  <sch:pattern id="resource-title">
    <sch:title xml:lang="en">Resource title is defined</sch:title>
    <sch:title xml:lang="fr">La ressource a un nom</sch:title>
    <sch:rule context="//*:MD_Metadata">

      <sch:let name="resourceTitle"
               value="*:identificationInfo/*/*:citation/*/*:title/*[text() != '']"/>
      <sch:let name="hasResourceTitle"
               value="count($resourceTitle) > 0"/>

      <sch:assert test="$hasResourceTitle"
                  diagnostics="rule.dcatap.resourcetitle.mandatory-failure-en rule.dcatap.resourcetitle.mandatory-failure-fr"/>
      <sch:report test="$hasResourceTitle"
                  diagnostics="rule.dcatap.resourcetitle.mandatory-success-en rule.dcatap.resourcetitle.mandatory-success-fr"/>
    </sch:rule>
  </sch:pattern>

  <!-- Resource Abstract-->
  <sch:diagnostic id="rule.dcatap.resourceabstract.mandatory-failure-en" xml:lang="en">
    Add an abstract.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.resourceabstract.mandatory-failure-fr" xml:lang="fr">
    Ajoutez une description de la ressource.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.resourceabstract.mandatory-success-en"
                  xml:lang="en">Resource abstract found.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.resourceabstract.mandatory-success-fr"
                  xml:lang="fr">La resource a un descriptif.
  </sch:diagnostic>
  <sch:pattern id="resource-abstract">
    <sch:title xml:lang="en">Resource abstract is defined</sch:title>
    <sch:title xml:lang="fr">La ressource a un descriptif</sch:title>
    <sch:rule context="//*:MD_Metadata">
      <sch:let name="resourceAbstract"
               value="*:identificationInfo/*/*:abstract/*[text() != '']"/>
      <sch:let name="hasResourceAbstract"
               value="count($resourceAbstract) > 0"/>

      <sch:assert test="$hasResourceAbstract"
                  diagnostics="rule.dcatap.resourceabstract.mandatory-failure-en rule.dcatap.resourceabstract.mandatory-failure-fr"/>
      <sch:report test="$hasResourceAbstract"
                  diagnostics="rule.dcatap.resourceabstract.mandatory-success-en rule.dcatap.resourceabstract.mandatory-success-fr"/>
    </sch:rule>
  </sch:pattern>

  <!-- Resource Publication date-->
  <sch:diagnostic id="rule.dcatap.resourcepublicationdate.mandatory-failure-en" xml:lang="en">
    Resource publication date is mandatory.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.resourcepublicationdate.mandatory-failure-fr" xml:lang="fr">
    La date de publication de la ressource est obligatoire.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.resourcepublicationdate.mandatory-success-en"
                  xml:lang="en">Resource publication date found:
    <sch:value-of select="string-join($resourcePublicationDate, ', ')"/>
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.resourcepublicationdate.mandatory-success-fr"
                  xml:lang="fr">Date de publication de la resource encodée :
    <sch:value-of select="string-join($resourcePublicationDate, ', ')"/>
  </sch:diagnostic>
  <sch:pattern id="resource-publication-date">
    <sch:title xml:lang="en">Resource publication date is defined</sch:title>
    <sch:title xml:lang="fr">La date de publication de la ressource est renseignée</sch:title>
    <sch:rule
      context="//*:MD_Metadata[(*:metadataScope/*/*:resourceScope|*:hierarchyLevel)/*/@codeListValue != 'series']">

      <sch:let name="resourcePublicationDate"
               value="*:identificationInfo/*/*:citation/*/*:date/*[*:dateType/*/@codeListValue = 'publication']/*:date[*/text() != '']"/>
      <sch:let name="hasResourcePublicationDate"
               value="count($resourcePublicationDate) > 0"/>

      <sch:assert test="$hasResourcePublicationDate"
                  diagnostics="rule.dcatap.resourcepublicationdate.mandatory-failure-en rule.dcatap.resourcepublicationdate.mandatory-failure-fr"/>
      <sch:report test="$hasResourcePublicationDate"
                  diagnostics="rule.dcatap.resourcepublicationdate.mandatory-success-en rule.dcatap.resourcepublicationdate.mandatory-success-fr"/>
      </sch:rule>
    </sch:pattern>

  <!-- Contact Point-->
  <sch:diagnostic id="rule.dcatap.contactPoint.mandatory-failure-en" xml:lang="en">
    Add a contact with a role of pointOfContact.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.contactPoint.mandatory-failure-fr" xml:lang="fr">
    Ajoutez un responsable avec le rôle "point de contact".
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.contactPoint.mandatory-success-en"
                  xml:lang="en">
    Point of contact found:<sch:value-of
    select="concat(' ', string-join($resourcePointOfContact, ', '))"/>.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.contactPoint.mandatory-success-fr"
                  xml:lang="fr">
    Point de contact encodé :<sch:value-of
    select="concat(' ', string-join($resourcePointOfContact, ', '))"/>.
  </sch:diagnostic>
  <sch:pattern id="resource-contact">
    <sch:title xml:lang="en">Resource's contact points defined</sch:title>
    <sch:title xml:lang="fr">Le point de contact est défini</sch:title>
    <sch:rule context="//*:MD_Metadata">
      <sch:let name="resourcePointOfContact"
               value="*:identificationInfo/*/*:pointOfContact/*[*:role/*/@codeListValue = 'pointOfContact']/*:party/*/*:name/*[text() != '']"/>
      <sch:let name="hasOneOrMorePointOfContact"
               value="count($resourcePointOfContact) > 0"/>

      <sch:assert test="$hasOneOrMorePointOfContact"
                  diagnostics="rule.dcatap.contactPoint.mandatory-failure-en rule.dcatap.contactPoint.mandatory-failure-fr"/>
      <sch:report test="$hasOneOrMorePointOfContact"
                  diagnostics="rule.dcatap.contactPoint.mandatory-success-en rule.dcatap.contactPoint.mandatory-success-fr"/>
    </sch:rule>
  </sch:pattern>

  <!-- Custodian -->
  <sch:diagnostic id="rule.dcatap.custodian.mandatory-failure-en" xml:lang="en">
    Add a contact with a role of custodian.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.custodian.mandatory-failure-fr" xml:lang="fr">
     Ajoutez un responsable avec le rôle "gestionnaire".
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.custodian.mandatory-success-en"
                  xml:lang="en">
    Custodian found:<sch:value-of
    select="concat(' ', string-join($resourceCustodian, ', '))"/>.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.custodian.mandatory-success-fr"
                  xml:lang="fr">
    Gestionnaire encodé :<sch:value-of
    select="concat(' ', string-join($resourceCustodian, ', '))"/>.
  </sch:diagnostic>
  <sch:pattern id="resource-custodian">
    <sch:title xml:lang="en">Resource custodian is defined</sch:title>
    <sch:title xml:lang="fr">Le gestionnaire est défini</sch:title>
    <sch:rule context="//*:MD_Metadata">
      <sch:let name="resourceCustodian"
               value="*:identificationInfo/*/*:pointOfContact/*[*:role/*/@codeListValue = 'custodian']/*:party/*/*:name/*[text() != '']"/>
      <sch:let name="hasOneOrMoreCustodian"
               value="count($resourceCustodian) > 0"/>

      <sch:assert test="$hasOneOrMoreCustodian"
                  diagnostics="rule.dcatap.custodian.mandatory-failure-en rule.dcatap.custodian.mandatory-failure-fr"/>
      <sch:report test="$hasOneOrMoreCustodian"
                  diagnostics="rule.dcatap.custodian.mandatory-success-en rule.dcatap.custodian.mandatory-success-fr"/>
      </sch:rule>
    </sch:pattern>

    <!-- Theme -->
    <sch:diagnostic id="rule.dcatap.themes.mandatory-failure-en" xml:lang="en">
      Add a theme from thesaurus "Data Theme DCAT-AP" of Publication Europa
    </sch:diagnostic>
    <sch:diagnostic id="rule.dcatap.themes.mandatory-failure-fr" xml:lang="fr">
      Ajoutez un thème provenant du thésaurus "Themes de données européens DCAT-AP"
    </sch:diagnostic>
    <sch:diagnostic id="rule.dcatap.themes.mandatory-success-en"
                    xml:lang="en">
      DCAT themes found:<sch:value-of
      select="concat(' ', string-join($dcatThemes, ', '))"/>.
    </sch:diagnostic>
    <sch:diagnostic id="rule.dcatap.themes.mandatory-success-fr"
                    xml:lang="fr">
      Thèmes DCAT encodés :<sch:value-of
      select="concat(' ', string-join($dcatThemes, ', '))"/>.
    </sch:diagnostic>
    <sch:pattern id="resource-theme">
      <sch:title xml:lang="en">The resource is classified under one of the European data themes of DCAT-AP</sch:title>
      <sch:title xml:lang="fr">La ressource est classée dans un des thèmes de données européens DCAT-AP</sch:title>
      <sch:rule
        context="//*:MD_Metadata[(*:metadataScope/*/*:resourceScope|*:hierarchyLevel)/*/@codeListValue != 'series']">


      <sch:let name="dcatThemes"
               value="*:identificationInfo/*/*:descriptiveKeywords/*/
                              *:keyword[starts-with(*:Anchor/@xlink:href, 'http://publications.europa.eu/resource/authority/data-theme')]"/>
      <sch:let name="hasDcatThemes"
               value="count($dcatThemes) > 0"/>

      <sch:assert test="$hasDcatThemes"
                  diagnostics="rule.dcatap.themes.mandatory-failure-en rule.dcatap.themes.mandatory-failure-fr"/>
      <sch:report test="$hasDcatThemes"
                  diagnostics="rule.dcatap.themes.mandatory-success-en rule.dcatap.themes.mandatory-success-fr"/>
      </sch:rule>
    </sch:pattern>

    <!-- Keywords -->
    <sch:diagnostic id="rule.dcatap.keywords.mandatory-failure-en" xml:lang="en">
      Add keywords.
    </sch:diagnostic>
    <sch:diagnostic id="rule.dcatap.keywords.mandatory-failure-fr" xml:lang="fr">
      Décrivez votre ressource à l'aide de mots-clés
    </sch:diagnostic>
    <sch:diagnostic id="rule.dcatap.keywords.mandatory-success-en"
                    xml:lang="en">
      <sch:value-of
        select="count($keywords)"/>
      keyword(s) found.
    </sch:diagnostic>
    <sch:diagnostic id="rule.dcatap.keywords.mandatory-success-fr"
                    xml:lang="fr">
      <sch:value-of
        select="count($keywords)"/>
      mot(s) clé(s) encodé(s).
    </sch:diagnostic>
    <sch:pattern id="resource-keywords">
      <sch:title xml:lang="en">Keywords are defined</sch:title>
      <sch:title xml:lang="fr">Des mots-clés sont définis</sch:title>
      <sch:rule
        context="//*:MD_Metadata[(*:metadataScope/*/*:resourceScope|*:hierarchyLevel)/*/@codeListValue != 'series']">
      <!--
      Keywords can be mapped to DCAT themes, legislation, or excluded eg. internal themes.
      See dcat-core-keywords.xsl.
      Only consider others.
      -->
      <sch:let name="thesaurusToIgnore"
               value="('http://publications.europa.eu/resource/authority/data-theme',
                            'http://data.europa.eu/r5r/applicableLegislation',
                            'https://metawal.wallonie.be/thesaurus/theme-geoportail-wallon',
                            'https://metawal.wallonie.be/thesaurus/infrasig')"/>

      <sch:let name="keywords"
               value="*:identificationInfo/*/*:descriptiveKeywords/*[
               not(mri:thesaurusName/*/cit:title/*/@xlink:href = $thesaurusToIgnore)
               ]/*:keyword[*/text() != '']"/>
      <sch:let name="hasKeywords"
               value="count($keywords) > 0"/>

      <sch:assert test="$hasKeywords"
                  diagnostics="rule.dcatap.keywords.mandatory-failure-en rule.dcatap.keywords.mandatory-failure-fr"/>
      <sch:report test="$hasKeywords"
                  diagnostics="rule.dcatap.keywords.mandatory-success-en rule.dcatap.keywords.mandatory-success-fr"/>

    </sch:rule>
  </sch:pattern>

  <sch:diagnostic id="rule.dcatap.dataset.access.constraints.mandatory-failure-en" xml:lang="en">
    Define the applicable standard access constraints or, if not applicable, specify non-standard access constraints by selecting a value from the 'Access Constraints' list and indicating any 'Other Constraints'
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.dataset.access.constraints.mandatory-failure-fr" xml:lang="fr">
    Définissez les conditions d'accès standard applicables ou à défaut spécifiez des conditions d'accès non-standard en choisissant une valeur de la liste "Contraintes d'accès" et en mentionnant des "Autres contraintes"
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.dataset.access.constraints.mandatory-success-en"
                  xml:lang="en">
    Access constraints found.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.dataset.access.constraints.mandatory-success-fr"
                  xml:lang="fr">
    Contraintes d'accès encodées.
  </sch:diagnostic>
  <sch:pattern id="dataset-accessconstraints">
   <sch:title xml:lang="en">Dataset - Access constraints are defined</sch:title>
   <sch:title xml:lang="fr">Dataset - Les contraintes d'accès sont définies</sch:title>
   <sch:rule
      context="//*:MD_Metadata[(*:metadataScope/*/*:resourceScope|*:hierarchyLevel)/*/@codeListValue = 'dataset']">

      <sch:let name="accessConstraints"
               value="*:identificationInfo/*/*:resourceConstraints/*[not(*:useConstraints) and *:otherConstraints/*/text() != '' and *:accessConstraints/*/@codeListValue != '']/*:otherConstraints/*/text()"/>

      <sch:let name="hasAccessConstraints"
               value="count($accessConstraints) > 0"/>

      <sch:assert test="$hasAccessConstraints"
                  diagnostics="rule.dcatap.dataset.access.constraints.mandatory-failure-en rule.dcatap.dataset.access.constraints.mandatory-failure-fr"/>
      <sch:report test="$hasAccessConstraints"
                  diagnostics="rule.dcatap.dataset.access.constraints.mandatory-success-en rule.dcatap.dataset.access.constraints.mandatory-success-fr"/>

   </sch:rule>
  </sch:pattern>

  <sch:diagnostic id="rule.dcatap.dataset.use.constraints.mandatory-failure-en" xml:lang="en">
    Define the applicable standard license or, if not applicable, specify non-standard terms of use.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.dataset.use.constraints.mandatory-failure-fr" xml:lang="fr">
    Définissez la licence standard applicable ou à défaut spécifiez des conditions d'utilisation non-standard.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.dataset.use.constraints.mandatory-success-en"
                  xml:lang="en">
    Use constraints found.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.dataset.use.constraints.mandatory-success-fr"
                  xml:lang="fr">
    Contraintes d'utilisation encodées.
  </sch:diagnostic>
  <sch:pattern id="dataset-useconstraints">
     <sch:title xml:lang="en">Dataset - License or use-constraints are defined</sch:title>
     <sch:title xml:lang="fr">Dataset - La licence ou les conditions d'utilisation sont spécifiées</sch:title>
      <sch:rule
        context="//*:MD_Metadata[(*:metadataScope/*/*:resourceScope|*:hierarchyLevel)/*/@codeListValue = 'dataset']">

        <sch:let name="useConstraints"
                 value="*:identificationInfo/*/*:resourceConstraints/*[not(*:accessConstraints) and *:otherConstraints/*/text() != '' and *:useConstraints/*/@codeListValue != '']/*:otherConstraints/*/text()"/>
        <sch:let name="hasUseConstraints"
                 value="count($useConstraints) > 0"/>

        <sch:assert test="$hasUseConstraints"
                    diagnostics="rule.dcatap.dataset.use.constraints.mandatory-failure-en rule.dcatap.dataset.use.constraints.mandatory-failure-fr"/>
        <sch:report test="$hasUseConstraints"
                    diagnostics="rule.dcatap.dataset.use.constraints.mandatory-success-en rule.dcatap.dataset.use.constraints.mandatory-success-fr"/>
      </sch:rule>
    </sch:pattern>

  <!-- Series - has dataset -->
  <sch:diagnostic id="rule.dcatap.series.has-dataset.mandatory-failure-en" xml:lang="en">
    Add a link between the series and its constituent datasets.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.series.has-dataset.mandatory-failure-fr" xml:lang="fr">
    Ajoutez un lien entre la série et ses données constitutives.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.series.has-dataset.mandatory-success-en"
                  xml:lang="en">
    Serie associated with one ore more datasets.
    <sch:value-of select="string-join($children/root/resourceIdentifier, ' | ')"/>
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.series.has-dataset.mandatory-success-fr"
                  xml:lang="fr">
    Série associée à une ou plusieures resources.
    <sch:value-of select="string-join($children/root/resourceIdentifier, ' | ')"/>
  </sch:diagnostic>
  <sch:pattern id="series-hasdataset">
         <sch:title xml:lang="en">Series - A dataset is part of the series</sch:title>
         <sch:title xml:lang="fr">Série - Une donnée fait partie de la série</sch:title>
    <sch:rule
      context="//*:MD_Metadata[(*:metadataScope/*/*:resourceScope|*:hierarchyLevel)/*/@codeListValue = 'series']">

      <sch:let name="associations"
               value="mdUtil:getAssociatedAsXml(mdb:metadataIdentifier/*/mcc:code/*/text())/relations"/>
      <sch:let name="children"
               value="$associations/children"/>
      <sch:let name="hasRelatedDataset"
               value="count($children) > 0"/>


      <sch:assert test="$hasRelatedDataset"
                  diagnostics="rule.dcatap.series.has-dataset.mandatory-failure-en rule.dcatap.series.has-dataset.mandatory-failure-fr"/>
      <sch:report test="$hasRelatedDataset"
                  diagnostics="rule.dcatap.series.has-dataset.mandatory-success-en rule.dcatap.series.has-dataset.mandatory-success-fr"/>
    </sch:rule>
  </sch:pattern>

  <!-- Distribution -->
  <sch:diagnostic id="rule.dcatap.has-download-page.mandatory-failure-en" xml:lang="en">
    No download page found. Add an online resource with protocol WWW:LINK and function download.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.has-download-page.mandatory-failure-fr" xml:lang="fr">
    Ajoutez la page de téléchargement avec une ressource en ligne dont le protocole est "WWW:LINK"
    et la fonction est "download". Complétez aussi les informations
    "adresse internet", "titre" et "description" pour la page de téléchargement.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.has-download-page.mandatory-success-en"
                  xml:lang="en">
    <sch:value-of select="count($onlineResourceDownloadPages)"/>  download page(s) found:
    <sch:value-of select="string-join($onlineResourceDownloadPages, ', ')"/>
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.has-download-page.mandatory-success-fr"
                  xml:lang="fr">
    <sch:value-of select="count($onlineResourceDownloadPages)"/> page(s) de téléchargement encodée(s) :
    <sch:value-of select="string-join($onlineResourceDownloadPages, ', ')"/>
  </sch:diagnostic>


  <sch:diagnostic id="rule.dcatap.has-distribution.mandatory-failure-en" xml:lang="en">
    No distribution found. Add an online resource with protocol WWW:DOWNLOAD:code_IANA_format and function download.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.has-distribution.mandatory-failure-fr" xml:lang="fr">
    Pas de distribution trouvée. Ajoutez un téléchargement avec une ressource en ligne
    dont le protocole est "WWW:DOWNLOAD:code_IANA_du_format" et la fonction est "download".
    Complétez les informations "adresse internet", "titre" et "description"  pour le fichier de téléchargement.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.has-distribution.mandatory-success-en"
                  xml:lang="en">
    <sch:value-of select="count($onlineResourceMappedAsDistribution)"/>  distribution(s) found:
    <sch:value-of select="string-join($onlineResourceMappedAsDistribution, ', ')"/>
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.has-distribution.mandatory-success-fr"
                  xml:lang="fr">
    <sch:value-of select="count($onlineResourceMappedAsDistribution)"/> distribution(s) encodée(s) :
    <sch:value-of select="string-join($onlineResourceMappedAsDistribution, ', ')"/>
  </sch:diagnostic>


  <sch:diagnostic id="rule.dcatap.distribution-has-name.mandatory-failure-en" xml:lang="en">
    Distribution
    <sch:value-of select="$linkage"/>
    has no name.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.distribution-has-name.mandatory-failure-fr" xml:lang="fr">
    Nom du fichier manquant dans la distribution <sch:value-of select="$linkage"/>.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.distribution-has-name.mandatory-success-en"
                  xml:lang="en">
    Distribution <sch:value-of select="$linkage"/>
    name is set to <sch:value-of select="$name"/>.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.distribution-has-name.mandatory-success-fr"
                  xml:lang="fr">
    Distribution <sch:value-of select="$linkage"/>. Nom du fichier encodé : <sch:value-of select="$name"/>.
  </sch:diagnostic>

  <sch:diagnostic id="rule.dcatap.distribution-has-description.mandatory-failure-en" xml:lang="en">
    Distribution <sch:value-of select="$linkage"/>
    has no description.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.distribution-has-description.mandatory-failure-fr" xml:lang="fr">
    Description du fichier manquant dans la distribution <sch:value-of select="$linkage"/>.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.distribution-has-description.mandatory-success-en"
                  xml:lang="en">
    Distribution <sch:value-of select="$linkage"/>
    description is set to <sch:value-of select="$description"/>.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.distribution-has-description.mandatory-success-fr"
                  xml:lang="fr">
    Distribution <sch:value-of select="$linkage"/>. Description encodée : <sch:value-of select="$description"/>.
  </sch:diagnostic>

  <sch:diagnostic id="rule.dcatap.distribution-has-downloadprotocol.mandatory-failure-en" xml:lang="en">
    Distribution <sch:value-of select="$linkage"/>
    has no download protocol (WWW:DOWNLOAD:IANA).
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.distribution-has-downloadprotocol.mandatory-failure-fr" xml:lang="fr">
    Protocol du fichier manquant dans la distribution <sch:value-of select="$linkage"/>
    (WWW:DOWNLOAD:IANA).
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.distribution-has-downloadprotocol.mandatory-success-en"
                  xml:lang="en">
    Distribution <sch:value-of select="$linkage"/>
    download protocol is set to<sch:value-of select="$protocol"/>.
  </sch:diagnostic>
  <sch:diagnostic id="rule.dcatap.distribution-has-downloadprotocol.mandatory-success-fr"
                  xml:lang="fr">
    Distribution <sch:value-of select="$linkage"/>. Protocole encodé : <sch:value-of select="$protocol"/>.
  </sch:diagnostic>

  <sch:pattern id="distribution">
    <sch:title>DCAT-AP (Distribution)</sch:title>
    <sch:rule
      context="//*:MD_Metadata[(*:metadataScope/*/*:resourceScope|*:hierarchyLevel)/*/@codeListValue = ('dataset', 'series')]/*:distributionInfo">


      <sch:let name="onlineResourceDownloadPages"
               value=".//*:onLine[*/*:protocol/*/text() = 'WWW:LINK' and */*:function/*/@codeListValue = 'download']/*/*:linkage/*[text() != '']"/>

      <sch:assert test="exists($onlineResourceDownloadPages)"
                  diagnostics="rule.dcatap.has-download-page.mandatory-failure-en rule.dcatap.has-download-page.mandatory-failure-fr"/>
      <sch:report test="exists($onlineResourceDownloadPages)"
                  diagnostics="rule.dcatap.has-download-page.mandatory-success-en rule.dcatap.has-download-page.mandatory-success-fr"/>



      <sch:let name="onlineResourceMappedAsDistribution"
               value=".//*:onLine[
                                   not(*/*:protocol/*/text() = 'WWW:LINK' and */*:function/*/@codeListValue = 'download')
                                   and
                                   not(
                                    */*:function/*/@codeListValue = ('information', 'information.content', 'information.portrayal', 'information.lineage', 'information.qualitySpecification', 'information.qualityReport', 'search', 'completeMetadata', 'browseGraphic', 'upload', 'emailService')
                                    or (*/*:function/*/@codeListValue = 'browsing' and matches(*/*:protocol/*/text(), 'WWW:LINK.*'))
                                    or ((not(*/*:function/*) or */*:function/*/@codeListValue = '') and (matches(*/*:protocol/*/text(), 'WWW:LINK.*') or not(*/*:protocol/*) or */*:protocol/*/text() = ''))
                                   )
                                   and not(*/*:protocol/* = ('ESRI:REST', 'ESRI:REST-TILED', 'OGC:WMS', 'OGC:WMTS', 'OGC:WFS', 'OGC:WCS', 'atom:feed', 'INSPIRE atom', 'OGC API - Features'))
                                 ]/*/*:linkage/*[text() != '']"/>

      <sch:let name="hasDistribution"
               value="count($onlineResourceMappedAsDistribution) > 0"/>

      <sch:assert test="$hasDistribution"
                  diagnostics="rule.dcatap.has-distribution.mandatory-failure-en rule.dcatap.has-distribution.mandatory-failure-fr"/>
      <sch:report test="$hasDistribution"
                  diagnostics="rule.dcatap.has-distribution.mandatory-success-en rule.dcatap.has-distribution.mandatory-success-fr"/>

    </sch:rule>

    <sch:rule context="//*:MD_Metadata[(*:metadataScope/*/*:resourceScope|*:hierarchyLevel)/*/@codeListValue = ('dataset', 'series')]/*:distributionInfo//*:onLine[
                                   not(*/*:protocol/*/text() = 'WWW:LINK' and */*:function/*/@codeListValue = 'download')
                                   and
                                   not(
                                    */*:function/*/@codeListValue = ('information', 'information.content', 'information.portrayal', 'information.lineage', 'information.qualitySpecification', 'information.qualityReport', 'search', 'completeMetadata', 'browseGraphic', 'upload', 'emailService')
                                    or (*/*:function/*/@codeListValue = 'browsing' and matches(*/*:protocol/*/text(), 'WWW:LINK.*'))
                                    or ((not(*/*:function/*) or */*:function/*/@codeListValue = '') and (matches(*/*:protocol/*/text(), 'WWW:LINK.*') or not(*/*:protocol/*) or */*:protocol/*/text() = ''))
                                   )
                                   and not(*/*:protocol/* = ('ESRI:REST', 'ESRI:REST-TILED', 'OGC:WMS', 'OGC:WMTS', 'OGC:WFS', 'OGC:WCS', 'atom:feed', 'INSPIRE atom', 'OGC API - Features'))
                                 ][*/*:linkage/*/text() != '']">

      <sch:let name="linkage"
               value="*/*:linkage/*[text() != '']"/>
      <sch:let name="name"
               value="*/*:name/*[text() != '']"/>
      <sch:let name="description"
               value="*/*:description/*[text() != '']"/>
      <sch:let name="protocol"
               value="*/*:protocol/*[text() != '']"/>

      <sch:assert test="exists($name)"
                  diagnostics="rule.dcatap.distribution-has-name.mandatory-failure-en rule.dcatap.distribution-has-name.mandatory-failure-fr"/>
      <sch:report test="exists($name)"
                  diagnostics="rule.dcatap.distribution-has-name.mandatory-success-en rule.dcatap.distribution-has-name.mandatory-success-fr"/>
      <sch:assert test="exists($description)"
                  diagnostics="rule.dcatap.distribution-has-description.mandatory-failure-en rule.dcatap.distribution-has-description.mandatory-failure-fr"/>
      <sch:report test="exists($description)"
                  diagnostics="rule.dcatap.distribution-has-description.mandatory-success-en rule.dcatap.distribution-has-description.mandatory-success-fr"/>
      <sch:assert test="matches($protocol, 'WWW:DOWNLOAD:.*')"
                  diagnostics="rule.dcatap.distribution-has-downloadprotocol.mandatory-failure-en rule.dcatap.distribution-has-downloadprotocol.mandatory-failure-fr"/>
      <sch:report test="matches($protocol, 'WWW:DOWNLOAD:.*')"
                  diagnostics="rule.dcatap.distribution-has-downloadprotocol.mandatory-success-en rule.dcatap.distribution-has-downloadprotocol.mandatory-success-fr"/>
    </sch:rule>

  </sch:pattern>
</sch:schema>
