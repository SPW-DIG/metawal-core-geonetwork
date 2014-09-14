<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gts="http://www.isotc211.org/2005/gts"
  xmlns:gco="http://www.isotc211.org/2005/gco" 
  xmlns:gmx="http://www.isotc211.org/2005/gmx" xmlns:srv="http://www.isotc211.org/2005/srv"
  xmlns:rw="http://metawal.wallonie.be/schemas/3.0"
  xmlns:gml="http://www.opengis.net/gml" xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:geonet="http://www.fao.org/geonetwork" xmlns:exslt="http://exslt.org/common"
  exclude-result-prefixes="gmd gco gml gts srv xlink exslt geonet">
  
  
  <!-- Main templates for view mode -->
  <xsl:template name="metadata-iso19139.rwview-simple">
    <xsl:call-template name="metadata-iso19139view-simple"/>
  </xsl:template>
  
  <xsl:template name="view-with-header-iso19139.rw">
    <xsl:param name="tabs"/>
    
    <xsl:call-template name="view-with-header-iso19139">
      <xsl:with-param name="tabs" select="$tabs"/>
    </xsl:call-template>
  </xsl:template>
  
  
  
  <!-- Some template required due to the missing gco:isoType on root element -->
  <xsl:template mode="iso19139" match="//rw:MD_Metadata/gmd:characterSet" priority="2">
    <xsl:param name="schema"/>
    <xsl:param name="edit"/>
    
    <xsl:call-template name="iso19139Codelist">
      <xsl:with-param name="schema"  select="$schema"/>
      <xsl:with-param name="edit"    select="false()"/>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template mode="superBrief" match="rw:MD_Metadata" priority="2">
    <xsl:variable name="langId">
      <xsl:call-template name="getLangId">
        <xsl:with-param name="langGui" select="/root/gui/language"/>
        <xsl:with-param name="md" select="."/>
      </xsl:call-template>
    </xsl:variable>
    
    <id><xsl:value-of select="geonet:info/id"/></id>
    <uuid><xsl:value-of select="geonet:info/uuid"/></uuid>
    <title>
      <xsl:apply-templates mode="localised" select="gmd:identificationInfo/*/gmd:citation/*/gmd:title">
        <xsl:with-param name="langId" select="$langId"/>
      </xsl:apply-templates>
    </title>
    <abstract>
      <xsl:apply-templates mode="localised" select="gmd:identificationInfo/*/gmd:abstract">
        <xsl:with-param name="langId" select="$langId"/>
      </xsl:apply-templates>
    </abstract>
  </xsl:template>
  
  <xsl:template mode="get-thumbnail" match="rw:MD_Metadata">
    <xsl:apply-templates mode="get-thumbnail" select="gmd:identificationInfo/*/gmd:graphicOverview"/>
  </xsl:template>
  
  
  
  
  
  
  <!-- Handle profil element -->
  <xsl:template name="metadata-iso19139.rw" match="metadata-iso19139.rw">
    <xsl:param name="schema"/>
    <xsl:param name="edit" select="false()"/>
    <xsl:param name="embedded"/>
    
    <!-- process in profile mode first -->
    <xsl:variable name="profileElements">
      <xsl:apply-templates mode="iso19139.rw" select=".">
        <xsl:with-param name="schema" select="$schema"/>
        <xsl:with-param name="edit" select="$edit"/>
        <xsl:with-param name="embedded" select="$embedded"/>
      </xsl:apply-templates>
    </xsl:variable>
    
    <xsl:choose>
      <!-- if we got a match in profile mode then show it -->
      <xsl:when test="count($profileElements/*)>0">
        <xsl:copy-of select="$profileElements"/>
      </xsl:when>
      <!-- If in view mode and at the root of the document,
        we try to match to a tab based on
       a missing element, then the profileElements is empty (in
       edit mode, it does not happen because usually it provides
       the option to add the missing element)
       and the iso19139 mode is applied to the root. Avoid this. -->
      <xsl:when test="$edit = false() 
        and name() = 'rw:MD_Metadata'
        and count($profileElements/*) = 0"></xsl:when>
      <!-- otherwise process in base iso19139 mode -->
      <xsl:otherwise> 
        <xsl:apply-templates mode="iso19139" select="." >
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="edit"   select="$edit"/>
          <xsl:with-param name="embedded" select="$embedded" />
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  
  <xsl:template mode="iso19139.rw" match="rw:*[gco:Integer|gco:Decimal|gco:Boolean|gco:Real]">
    <xsl:param name="schema"/>
    <xsl:param name="edit"/>
    
    <xsl:call-template name="iso19139String">
      <xsl:with-param name="schema" select="$schema"/>
      <xsl:with-param name="edit"   select="$edit"/>
    </xsl:call-template>
  </xsl:template>
  
  
  <!-- Trigger the enumeration to be properly displayed. Not sure why ? -->
  <xsl:template mode="iso19139.rw" match="rw:AD_AttributeCode_CodeList|rw:AD_AttributeCode_DomainCodes">
    <xsl:param name="schema"/>
    <xsl:param name="edit"/>
  </xsl:template>
  
  
  <xsl:template mode="iso19139.rw"
    match="rw:*[gco:CharacterString or gmd:PT_FreeText]"
    >
    <xsl:param name="schema" />
    <xsl:param name="edit" />
    
    <!-- Define a class variable if form element as
      to be a textarea instead of a simple text input.
      This parameter define the class of the textarea (see CSS). -->
    <xsl:variable name="class">
      <xsl:choose>
        <xsl:when test="name(.)='rw:attrLineage'">medium</xsl:when>
        <xsl:when test="name(.)='rw:attrSupplInfo' or name(.)='rw:legalReference'
          ">small</xsl:when>
        <xsl:otherwise></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:call-template name="localizedCharStringField">
      <xsl:with-param name="schema" select="$schema" />
      <xsl:with-param name="edit" select="$edit" />
      <xsl:with-param name="class" select="$class" />
    </xsl:call-template>
  </xsl:template>
  
  <!-- All of them match and returning nothing make the previous
  template delegating to iso19139 -->
  <xsl:template mode="iso19139.rw" match="*"/>
  
  
  <!-- Customize others -->
  <xsl:template mode="iso19139.rw" match="*[rw:CI_ResponsibleParty]" priority="2">
    <xsl:param name="schema"/>
    <xsl:param name="edit"/>
    
    <!-- TODO : check what's new for contact in that profile -->
    <xsl:call-template name="contactTemplateRw">
      <xsl:with-param name="edit" select="$edit"/>
      <xsl:with-param name="schema" select="$schema"/>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template name="contactTemplateRw">
    <xsl:param name="schema"/>
    <xsl:param name="edit"/>
    
    <xsl:variable name="content">
      
      <xsl:for-each select="rw:CI_ResponsibleParty">
        <col>
         <xsl:apply-templates mode="elementEP" select="../@xlink:href">
            <xsl:with-param name="schema" select="$schema"/>
            <xsl:with-param name="edit"   select="$edit"/>
          </xsl:apply-templates>
          
          <xsl:apply-templates mode="elementEP" select="gmd:individualName|geonet:child[string(@name)='individualName']
            |gmd:organisationName|geonet:child[string(@name)='organisationName']
            |gmd:positionName|geonet:child[string(@name)='positionName']
            |gmd:role|geonet:child[string(@name)='role']
            ">
            <xsl:with-param name="schema" select="$schema"/>
            <xsl:with-param name="edit"   select="$edit"/>
          </xsl:apply-templates>
        </col>
        <col>
         <xsl:apply-templates mode="elementEP" select="gmd:contactInfo|geonet:child[string(@name)='contactInfo']">
            <xsl:with-param name="schema" select="$schema"/>
            <xsl:with-param name="edit"   select="$edit"/>
          </xsl:apply-templates>
        </col>        
      </xsl:for-each>
    </xsl:variable>
    
    <xsl:apply-templates mode="complexElement" select=".">
      <xsl:with-param name="schema"  select="$schema"/>
      <xsl:with-param name="edit"    select="$edit"/>
      <xsl:with-param name="content">
        <xsl:call-template name="columnElementGui">
          <xsl:with-param name="cols" select="$content"/>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>
  
  
  
  
  <xsl:template mode="iso19139.rw"
    match="rw:*">
    <xsl:param name="schema"/>
    <xsl:param name="edit"/>
    
    <xsl:apply-templates mode="complexElement" select=".">
      <xsl:with-param name="schema" select="$schema"/>
      <xsl:with-param name="edit" select="$edit"/>
    </xsl:apply-templates>
  </xsl:template>
  
  
  <xsl:template mode="iso19139.rw" match="rw:legalStatement">
    <xsl:param name="schema"/>
    <xsl:param name="edit"/>
    
    <xsl:call-template name="localizedCharStringField">
      <xsl:with-param name="schema" select="$schema" />
      <xsl:with-param name="edit" select="$edit" />
      <xsl:with-param name="class" select="'medium'" />
    </xsl:call-template>
  </xsl:template>
  
  
  
  
  
  
  
  <!-- Overrides some templates for view mode -->
  
  <xsl:template mode="block" match="gmd:contact[rw:CI_ResponsibleParty]|gmd:pointOfContact[rw:CI_ResponsibleParty]" priority="101">
    <xsl:call-template name="simpleElementSimpleGUI">
      <xsl:with-param name="title">
        <xsl:value-of
          select="geonet:getCodeListValue(/root/gui/schemas, 'iso19139', 'gmd:CI_RoleCode', */gmd:role/gmd:CI_RoleCode/@codeListValue)"
        />
      </xsl:with-param>
      <xsl:with-param name="helpLink">
        <xsl:call-template name="getHelpLink">
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="name" select="name(.)"/>
        </xsl:call-template>
      </xsl:with-param>
      <xsl:with-param name="content">
        <xsl:apply-templates mode="iso19139-simple"
          select="
          rw:CI_ResponsibleParty/descendant::node()[(gco:CharacterString and normalize-space(gco:CharacterString)!='')]
          "/>
        
        <xsl:for-each select="rw:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:onlineResource/gmd:CI_OnlineResource">
          
          <xsl:call-template name="simpleElement">
            <xsl:with-param name="id" select="generate-id(.)"/>
            <xsl:with-param name="title">
              <xsl:call-template name="getTitle">
                <xsl:with-param name="name" select="'gmd:onlineResource'"/>
                <xsl:with-param name="schema" select="$schema"/>
              </xsl:call-template>
            </xsl:with-param>
            <xsl:with-param name="help"></xsl:with-param>
            <xsl:with-param name="content">
              <a href="{gmd:linkage/gmd:URL}" target="_blank">
                <xsl:value-of select="gmd:name/gco:CharacterString"/>
              </a>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:for-each>
        
        <xsl:if test="descendant::gmx:FileName">
          <img src="{descendant::gmx:FileName/@src}" alt="logo" class="orgLogo" style="float:right;"/>
          <!-- FIXME : css -->
        </xsl:if>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  
  
  
  
  <!-- Configure tabs -->
  <xsl:template name="iso19139.rwCompleteTab">
    <xsl:param name="tabLink"/>
    <xsl:param name="schema"/>
    
    <xsl:call-template name="iso19139rwCompleteTab">
      <xsl:with-param name="tabLink" select="$tabLink"/>
      <xsl:with-param name="schema" select="$schema"/>
    </xsl:call-template>
  </xsl:template>
  
  
  
  <xsl:template name="iso19139rwCompleteTab">
    <xsl:param name="tabLink"/>
    <xsl:param name="schema"/>
    
    <!-- INSPIRE tab -->
    <xsl:if test="/root/gui/env/inspire/enable = 'true' and /root/gui/env/metadata/enableInspireView = 'true'">
      <xsl:call-template name="mainTab">
        <xsl:with-param name="title" select="/root/gui/strings/inspireTab"/>
        <xsl:with-param name="default">inspire</xsl:with-param>
        <xsl:with-param name="menu">
          <item label="inspireTab">inspire</item>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>
    
    <xsl:if test="/root/gui/env/metadata/enableIsoView = 'true'">
      <xsl:call-template name="mainTab">
        <xsl:with-param name="title" select="/root/gui/strings/byGroup"/>
        <xsl:with-param name="default">ISOCore</xsl:with-param>
        <xsl:with-param name="menu">
          <item label="isoMinimum">ISOMinimum</item>
          <item label="isoCore">ISOCore</item>
          <item label="isoAll">ISOAll</item>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>
    
    
    
    <xsl:if test="/root/gui/config/metadata-tab/advanced">
      <xsl:call-template name="mainTab">
        <xsl:with-param name="title" select="/root/gui/strings/byPackage"/>
        <xsl:with-param name="default">identification</xsl:with-param>
        <xsl:with-param name="menu">
          <item label="metadata">metadata</item>
          <item label="identificationTab">identification</item>
          <item label="maintenanceTab">maintenance</item>
          <item label="constraintsTab">constraints</item>
          <item label="spatialTab">spatial</item>
          <item label="refSysTab">refSys</item>
          <item label="distributionTab">distribution</item>
          <item label="dataQualityTab">dataQuality</item>
          <item label="appSchInfoTab">appSchInfo</item>
          <item label="porCatInfoTab">porCatInfo</item>
          <item label="contentInfoTab">contentInfo</item>
          <item label="extensionInfoTab">extensionInfo</item>
          <item label="tableIdent">tableIdent</item>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>    
  </xsl:template>
  
  
  <xsl:template mode="iso19139.rw" match="rw:MD_Metadata|*[@gco:isoType='gmd:MD_Metadata']"
    priority="3">
    <xsl:param name="schema"/>
    <xsl:param name="edit"/>
    <xsl:param name="embedded"/>
    
    <xsl:variable name="dataset"
      select="gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue='dataset' or normalize-space(gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue)=''"/>
    <xsl:choose>
      
      <!-- metadata tab -->
      <xsl:when test="$currTab='metadata'">
        <xsl:call-template name="iso19139Metadata">
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="edit" select="$edit"/>
        </xsl:call-template>
      </xsl:when>
      
      <!-- identification tab -->
      <xsl:when test="$currTab='identification'">
        <xsl:apply-templates mode="elementEP"
          select="gmd:identificationInfo|geonet:child[string(@name)='identificationInfo']">
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="edit" select="$edit"/>
        </xsl:apply-templates>
      </xsl:when>
      
      <!-- maintenance tab -->
      <xsl:when test="$currTab='maintenance'">
        <xsl:apply-templates mode="elementEP"
          select="gmd:metadataMaintenance|geonet:child[string(@name)='metadataMaintenance']">
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="edit" select="$edit"/>
        </xsl:apply-templates>
      </xsl:when>
      
      <!-- constraints tab -->
      <xsl:when test="$currTab='constraints'">
        <xsl:apply-templates mode="elementEP"
          select="gmd:metadataConstraints|geonet:child[string(@name)='metadataConstraints']">
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="edit" select="$edit"/>
        </xsl:apply-templates>
      </xsl:when>
      
      <!-- spatial tab -->
      <xsl:when test="$currTab='spatial'">
        <xsl:apply-templates mode="elementEP"
          select="gmd:spatialRepresentationInfo|geonet:child[string(@name)='spatialRepresentationInfo']">
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="edit" select="$edit"/>
        </xsl:apply-templates>
      </xsl:when>
      
      <!-- refSys tab -->
      <xsl:when test="$currTab='refSys'">
        <xsl:apply-templates mode="elementEP"
          select="gmd:referenceSystemInfo|geonet:child[string(@name)='referenceSystemInfo']">
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="edit" select="$edit"/>
        </xsl:apply-templates>
      </xsl:when>
      
      <!-- distribution tab -->
      <xsl:when test="$currTab='distribution'">
        <xsl:apply-templates mode="elementEP"
          select="gmd:distributionInfo|geonet:child[string(@name)='distributionInfo']">
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="edit" select="$edit"/>
        </xsl:apply-templates>
      </xsl:when>
      
      <!-- embedded distribution tab -->
      <xsl:when test="$currTab='distribution2'">
        <xsl:apply-templates mode="elementEP"
          select="gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions">
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="edit" select="$edit"/>
        </xsl:apply-templates>
      </xsl:when>
      
      <!-- dataQuality tab -->
      <xsl:when test="$currTab='dataQuality'">
        <xsl:apply-templates mode="elementEP"
          select="gmd:dataQualityInfo|geonet:child[string(@name)='dataQualityInfo']">
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="edit" select="$edit"/>
        </xsl:apply-templates>
      </xsl:when>
      
      <!-- appSchInfo tab -->
      <xsl:when test="$currTab='appSchInfo'">
        <xsl:apply-templates mode="elementEP"
          select="gmd:applicationSchemaInfo|geonet:child[string(@name)='applicationSchemaInfo']">
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="edit" select="$edit"/>
        </xsl:apply-templates>
      </xsl:when>
      
      <!-- porCatInfo tab -->
      <xsl:when test="$currTab='porCatInfo'">
        <xsl:apply-templates mode="elementEP"
          select="gmd:portrayalCatalogueInfo|geonet:child[string(@name)='portrayalCatalogueInfo']">
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="edit" select="$edit"/>
        </xsl:apply-templates>
      </xsl:when>
      
      <!-- contentInfo tab -->
      <xsl:when test="$currTab='contentInfo'">
        <xsl:apply-templates mode="elementEP"
          select="gmd:contentInfo|geonet:child[string(@name)='contentInfo']">
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="edit" select="$edit"/>
        </xsl:apply-templates>
      </xsl:when>
      
      <!-- extensionInfo tab -->
      <xsl:when test="$currTab='extensionInfo'">
        <xsl:apply-templates mode="elementEP"
          select="gmd:metadataExtensionInfo|geonet:child[string(@name)='metadataExtensionInfo']">
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="edit" select="$edit"/>
        </xsl:apply-templates>
      </xsl:when>
      
      <!-- extensionInfo tab -->
      <xsl:when test="$currTab='tableIdent'">
        <xsl:apply-templates mode="elementEP"
          select="rw:tableIdent|geonet:child[string(@name)='tableIdent']">
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="edit" select="$edit"/>
        </xsl:apply-templates>
      </xsl:when>
      
      
      <!-- ISOMinimum tab -->
      <xsl:when test="$currTab='ISOMinimum'">
        <xsl:call-template name="isotabs">
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="edit" select="$edit"/>
          <xsl:with-param name="dataset" select="$dataset"/>
          <xsl:with-param name="core" select="false()"/>
        </xsl:call-template>
      </xsl:when>
      
      <!-- ISOCore tab -->
      <xsl:when test="$currTab='ISOCore'">
        <xsl:call-template name="isotabs">
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="edit" select="$edit"/>
          <xsl:with-param name="dataset" select="$dataset"/>
          <xsl:with-param name="core" select="true()"/>
        </xsl:call-template>
      </xsl:when>
      
      <!-- ISOAll tab -->
      <xsl:when test="$currTab='ISOAll'">
        <xsl:call-template name="iso19139Complete">
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="edit" select="$edit"/>
        </xsl:call-template>
      </xsl:when>
      
      <!-- INSPIRE tab -->
      <xsl:when test="$currTab='inspire'">
        <xsl:call-template name="inspiretabs">
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="edit" select="$edit"/>
          <xsl:with-param name="dataset" select="$dataset"/>
        </xsl:call-template>
      </xsl:when>
      <!-- default -->
      <xsl:otherwise>
        <xsl:call-template name="iso19139Simple">
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="edit" select="$edit"/>
          <xsl:with-param name="flat"
            select="/root/gui/config/metadata-tab/*[name(.)=$currTab]/@flat"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  
  <!-- Add some more element which are not multilingual -->
  <xsl:template mode="iso19139"
    match="
    gmd:version|gmd:name
    "
    priority="100">
    <xsl:param name="schema" />
    <xsl:param name="edit" />
    
    <xsl:call-template name="iso19139String">
      <xsl:with-param name="schema" select="$schema"/>
      <xsl:with-param name="edit"   select="$edit"/>
    </xsl:call-template>
  </xsl:template>
</xsl:stylesheet>
