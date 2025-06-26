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

  <sch:title xmlns="http://www.w3.org/2001/XMLSchema">DCAT-AP High Value Dataset (HVD) - recommended</sch:title>
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


  <!-- One EU Legislation-->
  <sch:diagnostic id="rule.hvd.one.legislation.recommended-failure-en" xml:lang="en">
    Add the applicable European legislation from the 'Applicable Legislations' thesaurus.
  </sch:diagnostic>
  <sch:diagnostic id="rule.hvd.one.legislation.recommended-failure-fr" xml:lang="fr">
    Ajoutez la législation européenne applicable à partir du thésaurus "Applicable Legislations".
  </sch:diagnostic>
  <sch:diagnostic id="rule.hvd.one.legislation.recommended-success-en"
                  xml:lang="en"><sch:value-of select="count($keywordEncodingApplicableLegislationAsAnchor)"/> legislation encoded: <sch:value-of select="string-join($keywordEncodingApplicableLegislationAsAnchor, ', ')"/>.
  </sch:diagnostic>
  <sch:diagnostic id="rule.hvd.one.legislation.recommended-success-fr"
                  xml:lang="fr"><sch:value-of select="count($keywordEncodingApplicableLegislationAsAnchor)"/> législation(s) encodée(s) : <sch:value-of select="string-join($keywordEncodingApplicableLegislationAsAnchor, ', ')"/>.
  </sch:diagnostic>
  <sch:pattern>
    <sch:title xml:lang="en">It is recommended to enter the European legislation related to the resource</sch:title>
    <sch:title xml:lang="fr">Il est recommandé d'indiquer la législation européenne relative à la ressource</sch:title>
    <sch:rule context="//*:MD_Metadata">

      <!--
      See eu-dcat-ap-core-dataset.xsl
      -->
      <sch:let name="keywordEncodingApplicableLegislationAsAnchor"
               value="*:identificationInfo/*/*:descriptiveKeywords/*/
                              *:keyword[*:Anchor/@xlink:href != 'http://data.europa.eu/eli/reg_impl/2023/138/oj'
                                                and starts-with(*:Anchor/@xlink:href, 'http://data.europa.eu/eli/')]"/>

      <sch:let name="hasOneKeywordEncodingApplicableLegislationAsAnchor"
               value="count($keywordEncodingApplicableLegislationAsAnchor) > 0"/>

      <sch:assert test="$hasOneKeywordEncodingApplicableLegislationAsAnchor"
                  diagnostics="rule.hvd.one.legislation.recommended-failure-en rule.hvd.one.legislation.recommended-failure-fr"/>
      <sch:report test="$hasOneKeywordEncodingApplicableLegislationAsAnchor"
                  diagnostics="rule.hvd.one.legislation.recommended-success-en rule.hvd.one.legislation.recommended-success-fr"/>
    </sch:rule>
  </sch:pattern>

  <!-- Conforms To -->
  <sch:diagnostic id="rule.hvd.conformity.recommended-failure-en" xml:lang="en">
    Add a declaration of compliance with specifications by referencing them with an anchor.
    report specification to add one. For INSPIRE datasets, this is a data specification conformity.
  </sch:diagnostic>
  <sch:diagnostic id="rule.hvd.conformity.recommended-failure-fr" xml:lang="fr">
    Ajoutez une déclaration de conformité à des spécifications en les référençant avec une ancre.
  </sch:diagnostic>
  <sch:diagnostic id="rule.hvd.conformity.recommended-success-en"
                  xml:lang="en">
    Implementing rules or specifications found:<sch:value-of
    select="concat(' ', string-join($implementingRules, ', '))"/>.
  </sch:diagnostic>
  <sch:diagnostic id="rule.hvd.conformity.recommended-success-fr"
                  xml:lang="fr">
    Règles ou spécifications encodées :<sch:value-of select="concat(' ', string-join($implementingRules, ', '))"/>.
  </sch:diagnostic>
  <sch:pattern>
    <sch:title xml:lang="en">It is recommended to enter the compliance of the resource with specifications</sch:title>
    <sch:title xml:lang="fr">Il est recommandé d'indiquer la conformité de la ressource à des spécifications</sch:title>
    <sch:rule
      context="//*:MD_Metadata[(*:metadataScope/*/*:resourceScope|*:hierarchyLevel)/*/@codeListValue = 'dataset']">

      <!--
      conforms to
      Standard
      0..*
      An implementing rule or other specification.
      The provided information should enable to the verification whether the detailed information
      requirements by the HVD is satisfied. For more usage suggestions see section on specific data requirements.
      A

      ISO encoding
      <mdq:report>
          <mdq:DQ_DomainConsistency>
             <mdq:result>
                <mdq:DQ_ConformanceResult>
                   <mdq:specification>
                      <cit:CI_Citation>
                         <cit:title>
                            <gcx:Anchor xlink:href="https://inspire.ec.europa.eu/id/document/tg/ad">
                            INSPIRE Data Specification on Addresses – Technical Guidelines, version 3.1</gcx:Anchor>

          Rule:
          * More strict, at least one?
          * non INSPIRE datasets
      -->
      <!-- Any specification is considered valid (only check for anchor presence) -->
      <sch:let name="implementingRules"
               value="*:dataQualityInfo/*/*:report/*/*:result/*/*:specification/*/
                                    *:title/*:Anchor/@xlink:href"/>
      <sch:let name="hasOneOrMoreDataSpecConformity"
               value="count($implementingRules) > 0"/>

      <sch:assert test="$hasOneOrMoreDataSpecConformity"
                  diagnostics="rule.hvd.conformity.recommended-failure-en rule.hvd.conformity.recommended-failure-fr"/>
      <sch:report test="$hasOneOrMoreDataSpecConformity"
                  diagnostics="rule.hvd.conformity.recommended-success-en rule.hvd.conformity.recommended-success-fr"/>
    </sch:rule>
  </sch:pattern>
</sch:schema>
