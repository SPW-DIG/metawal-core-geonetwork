<?xml version="1.0" encoding="UTF-8"?>
<!--
    Processing steps are :
    Parameters:
    * process=metawal-schema-updates
    
    Calling the process using:
    http://localhost:8080/geonetwork/srv/fr/xml.search
    http://localhost:8080/geonetwork/srv/fr/metadata.select?id=0&selected=add-all
    http://localhost:8080/geonetwork/srv/en/metadata.batch.processing?process=metawal-schema-updates
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:geonet="http://www.fao.org/geonetwork" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:gco="http://www.isotc211.org/2005/gco" 
    xmlns:gmd="http://www.isotc211.org/2005/gmd"
    xmlns:srv="http://www.isotc211.org/2005/srv"
    xmlns:rw="http://metawal.wallonie.be/schemas/3.0"
    xmlns:gmx="http://www.isotc211.org/2005/gmx" 
    xmlns:exslt="http://exslt.org/common" version="2.0" exclude-result-prefixes="exslt geonet">
    
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
    
    
    <!-- Do a copy of every nodes and attributes -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- Remove geonet:* elements. -->
    <xsl:template match="geonet:*" priority="2"/>
    
    <!-- Add gco:isoType attribute when needed.
    eg. <rw:CI_ResponsibleParty> should be replaced by
    <rw:CI_ResponsibleParty gco:isoType="gmd:CI_ResponsibleParty"">
    -->
    <xsl:template match="rw:CI_ResponsibleParty[not(@gco:isoType)]|
        rw:LI_Lineage[not(@gco:isoType)]|
        rw:MD_LegalConstraints[not(@gco:isoType)]">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:attribute name="gco:isoType">
                <xsl:value-of select="concat('gmd:', local-name(.))"/>
            </xsl:attribute>
            <xsl:copy-of select="*[namespace-uri()!='http://www.fao.org/geonetwork']"/>
        </xsl:copy>
    </xsl:template>
    
    
    <!-- Move application hierarchyLevel to scope code instead of 
    hierarchyLevelName  -->
    <xsl:template match="rw:MD_Metadata">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:attribute name="gco:isoType">
                <xsl:value-of select="concat('gmd:', local-name(.))"/>
            </xsl:attribute>
            
            <xsl:copy-of select="gmd:fileIdentifier|gmd:language|gmd:characterSet|
                gmd:parentIdentifier"/>
            
            <!-- Add the application codelist -->
            <xsl:choose>
                <xsl:when test="gmd:hierarchyLevelName/gco:CharacterString = 'Application'">
                    <gmd:hierarchyLevel>
                        <gmd:MD_ScopeCode 
                            codeList="http://www.isotc211.org/2005/resources/codeList.xml#MD_ScopeCode" 
                            codeListValue="application" />
                    </gmd:hierarchyLevel>
                    <gmd:hierarchyLevelName>
                        <gco:CharacterString>Application</gco:CharacterString>
                    </gmd:hierarchyLevelName>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy-of select="gmd:hierarchyLevel"/>
                    <xsl:copy-of select="gmd:hierarchyLevelName"/>
                </xsl:otherwise>
            </xsl:choose>
            
            <xsl:copy-of select="gmd:contact|gmd:dateStamp|gmd:metadataStandardName|
                gmd:metadataStandardVersion|gmd:dataSetURI|gmd:locale|
                gmd:spatialRepresentationInfo|gmd:referenceSystemInfo|
                gmd:metadataExtensionInfo|gmd:identificationInfo|
                gmd:contentInfo|gmd:distributionInfo|
                gmd:dataQualityInfo|gmd:portrayalCatalogueInfo|
                gmd:metadataConstraints|gmd:applicationSchemaInfo|
                gmd:metadataMaintenance|gmd:series|
                gmd:describes|gmd:propertyType|
                gmd:featureType|gmd:featureAttribute|rw:*
                "/>
            
        </xsl:copy>
    </xsl:template>
    
    
    <!-- TODO: Update licence
    -->
    
    <!-- Store language in gmd:LanguageCode instead of gco:CharacterString (INSPIRE requirements). 
    
        eg. Old style encoding is replaced:
        <gmd:language>
        <gco:CharacterString>fre</gco:CharacterString>
        </gmd:language>
    -->
    <xsl:template match="gmd:language[gco:CharacterString]" priority="2">
        <xsl:copy>
            <gmd:LanguageCode codeList="http://www.loc.gov/standards/iso639-2/"
                codeListValue="{gco:CharacterString}"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>