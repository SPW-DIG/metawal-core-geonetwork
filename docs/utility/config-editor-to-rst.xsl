<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output method="text"/>
    
    <xsl:param name="lang" select="'fre'"/>
    <xsl:param name="schema" select="'iso19115-3'"/>
    
    <xsl:variable name="i18n">
        <title>
            <eng>ISO Standard for metadata on Geographic Information - ISO </eng>
            <fre>Standard ISO pour les métadonnées liées aux informations géographiques - ISO </fre>
        </title>
        <views>
            <eng>View:</eng>
            <fre>Vue :</fre>
        </views>
        <tabs>
            <eng>Tab:</eng>
            <fre>Onglet :</fre>
        </tabs>
        <sections>
            <eng>Section:</eng>
            <fre>Section :</fre>
        </sections>
        <fields>
            <eng>Field:</eng>
            <fre>Champ :</fre>
        </fields>
        <unfields>
            <eng>Undefined field:</eng>
            <fre>Champ indéfini:</fre>
        </unfields>
        <code>
            <eng>Tag name</eng>
            <fre>Nom de la balise</fre>
        </code>
        <desc>
            <eng>Description</eng>
            <fre>Description</fre>
        </desc>
        <moreInfo>
            <eng>More details</eng>
            <fre>Informations complémentaires</fre>
        </moreInfo>
        <tbc>
            <eng>To be completed</eng>
            <fre>A compléter</fre>
        </tbc>
        <tbd>
            <eng>To be defined</eng>
            <fre>A définir</fre>
        </tbd>
        <helper>
            <eng>Recommended values</eng>
            <fre>Valeurs recommandées</fre>
        </helper>
        <cond>
            <eng>Condition</eng>
            <fre>Condition</fre>
        </cond>
        <glossary>
            <eng>List of element for schema:</eng>
            <fre>Liste des éléments du standard :</fre>
        </glossary>
        <codeLists>
            <eng>Code lists:</eng>
            <fre>Liste des codes :</fre>
        </codeLists>
        <notapp>
            <eng>Undefined element</eng>
            <fre>Element non défini</fre>
        </notapp>
        
    </xsl:variable>
    
    <xsl:variable name="labels" select="document(concat('../web/src/main/webapp/WEB-INF/data/config/schema_plugins/', $schema, '/loc/',$lang,'/labels.xml'))"/>
    <xsl:variable name="strings" select="document(concat('../web/src/main/webapp/WEB-INF/data/config/schema_plugins/', $schema, '/loc/',$lang,'/strings.xml'))"/>
    <xsl:variable name="codelists" select="document(concat('../web/src/main/webapp/WEB-INF/data/config/schema_plugins/', $schema, '/loc/',$lang,'/codelists.xml'))"/>
    <xsl:variable name="geoportalView" select="document(concat('../web/src/main/webapp/WEB-INF/data/config/schema_plugins/', $schema, '/layout/config-editor.xml'))"/>
    <xsl:strip-space elements="*"/>
    
    <xsl:template match="/">
        <xsl:value-of select="concat($i18n/title/*[name() = $lang], ' ', $schema)"/><xsl:text>&#xA;</xsl:text>
        <xsl:for-each select="1 to string-length(concat($i18n/title/*[name() = $lang], ' ', $schema))">#</xsl:for-each><xsl:text>&#xA;</xsl:text>
        <xsl:text>&#xA;</xsl:text>
        <xsl:for-each select="$geoportalView//views/view">     
            <xsl:variable name="viewName" 
                select="@name"/>
            <xsl:variable name="checkViewNameHelp" select="concat($viewName,'-help')"/>
            <xsl:for-each select="$strings/strings">
                <xsl:for-each select="node()">
                    <xsl:variable name="checkViewName">
                        <xsl:if test="name() = $viewName">
                            <xsl:value-of select="normalize-space(.)"/>
                        </xsl:if>
                    </xsl:variable>
                    <xsl:if test="name() = $viewName">
                        <xsl:value-of select="concat($i18n/views/*[name() = $lang], ' ', $checkViewName)"/><xsl:text>&#xA;</xsl:text>
                        <xsl:for-each select="1 to string-length(concat($i18n/views/*[name() = $lang], ' ', $checkViewName))">-</xsl:for-each><xsl:text>&#xA;</xsl:text>                    
                    </xsl:if>
                </xsl:for-each>
                <xsl:for-each select="node()">
                    <xsl:if test="name() = $checkViewNameHelp">
                        <xsl:choose>
                            <xsl:when test="normalize-space(.) = ''">
                                <xsl:value-of select="concat('**',$i18n/desc/*[name() = $lang],'** : ',$i18n/tbc/*[name() = $lang])"/><xsl:text>&#xA;</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="concat('**',$i18n/desc/*[name() = $lang],'** : ',normalize-space(.))"/><xsl:text>&#xA;</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                </xsl:for-each>
                <xsl:if test="count($strings/strings/*[name() = $checkViewNameHelp]) = 0">
                    <xsl:value-of select="concat('**',$i18n/desc/*[name() = $lang],'** view : ',$i18n/tbd/*[name() = $lang])"/><xsl:text>&#xA;</xsl:text>
                </xsl:if>
                <xsl:text>&#xA;</xsl:text>
            </xsl:for-each>
            <xsl:for-each select="tab">
                <xsl:variable name="tabName" 
                    select="@id"/>
                <xsl:variable name="checkTabNameHelp" select="concat($tabName,'-help')"/>
                <xsl:for-each select="$strings/strings">
                    <xsl:for-each select="node()">
                        <xsl:variable name="checkTabName">
                        <xsl:if test="name() = $tabName">
                            <xsl:value-of select="normalize-space(.)"/>
                        </xsl:if>
                        </xsl:variable>
                        <xsl:if test="name() = $tabName">
                            <xsl:value-of select="concat($i18n/tabs/*[name() = $lang], ' ', $checkTabName)"/><xsl:text>&#xA;</xsl:text>
                            <xsl:for-each select="1 to string-length(concat($i18n/tabs/*[name() = $lang], ' ', $checkTabName))">*</xsl:for-each><xsl:text>&#xA;</xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:for-each select="node()">
                        <xsl:if test="name() = $checkTabNameHelp">
                            <xsl:choose>
                                <xsl:when test="normalize-space(.) = ''">
                                    <xsl:value-of select="concat('**',$i18n/desc/*[name() = $lang],'** : ',$i18n/tbc/*[name() = $lang])"/><xsl:text>&#xA;</xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="concat('**',$i18n/desc/*[name() = $lang],'** : ',normalize-space(.))"/><xsl:text>&#xA;</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:if test="count($strings/strings/*[name() = $checkTabNameHelp]) = 0">
                        <xsl:value-of select="concat('**',$i18n/desc/*[name() = $lang],'** : ',$i18n/tbd/*[name() = $lang])"/><xsl:text>&#xA;</xsl:text>
                    </xsl:if>
                    <xsl:text>&#xA;</xsl:text>
                </xsl:for-each>
                <xsl:for-each select="section">
                    <xsl:variable name="sectionName" 
                        select="@name"/>
                    <xsl:variable name="checkSectionNameHelp" select="concat($sectionName,'-help')"/>
                    <xsl:choose>
                        <xsl:when test="contains(@name,':')">
                            <xsl:for-each select="$labels//element">
                                <xsl:variable name="labelsRef" 
                                    select="@name"/>
                                <xsl:if test="$sectionName = $labelsRef">
                                    <xsl:variable name="sectionLabelsLabel" 
                                        select="normalize-space(label)"/>   
                                    <xsl:value-of select="concat($i18n/sections/*[name() = $lang], ' ', $sectionLabelsLabel)"/><xsl:text>&#xA;</xsl:text>
                                    <xsl:for-each select="1 to string-length(concat($i18n/sections/*[name() = $lang], ' ', $sectionLabelsLabel))">=</xsl:for-each><xsl:text>&#xA;</xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                            <xsl:if test="count($strings/strings/*[name() = $checkSectionNameHelp]) = 0">
                                <xsl:value-of select="concat('**',$i18n/desc/*[name() = $lang],'**: ',$i18n/tbd/*[name() = $lang])"/><xsl:text>&#xA;</xsl:text>
                            </xsl:if>
                            <xsl:text>&#xA;</xsl:text>
                        </xsl:when>
                        <xsl:when test="@name">
                    
                    <xsl:for-each select="$strings/strings">
                        <xsl:for-each select="node()">
                            <xsl:variable name="checkSectionName">
                            <xsl:if test="name() = $sectionName">
                                <xsl:value-of select="normalize-space(.)"/>
                            </xsl:if>
                            </xsl:variable>
                            <xsl:if test="name() = $sectionName">
                                <xsl:value-of select="concat($i18n/sections/*[name() = $lang], ' ', $checkSectionName)"/><xsl:text>&#xA;</xsl:text>
                                <xsl:for-each select="1 to string-length(concat($i18n/sections/*[name() = $lang], ' ', $checkSectionName))">=</xsl:for-each><xsl:text>&#xA;</xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                        <xsl:for-each select="node()">
                            <xsl:if test="name() = $checkSectionNameHelp">
                                <xsl:choose>
                                    <xsl:when test="normalize-space(.) = ''">
                                        <xsl:value-of select="concat('**',$i18n/desc/*[name() = $lang],'** : ',$i18n/tbc/*[name() = $lang])"/><xsl:text>&#xA;</xsl:text>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="concat('**',$i18n/desc/*[name() = $lang],'** : ',normalize-space(.))"/><xsl:text>&#xA;</xsl:text>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:if>
                        </xsl:for-each>
                        <xsl:if test="count($strings/strings/*[name() = $checkSectionNameHelp]) = 0">
                            <xsl:value-of select="concat('**',$i18n/desc/*[name() = $lang],'**: ',$i18n/tbd/*[name() = $lang])"/><xsl:text>&#xA;</xsl:text>
                        </xsl:if>
                        <xsl:text>&#xA;</xsl:text>
                    </xsl:for-each> 
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:variable name="sectionRef" select="normalize-space(tokenize(@xpath,'/')[last()])"/>
                            <xsl:variable name="sectionRefUppercase" select="concat(upper-case(substring(substring-after($sectionRef, ':'),1,1)), substring(substring-after($sectionRef, ':'), 2))"/>
                            <xsl:for-each select="$labels//element">
                                <xsl:variable name="labelsRef" 
                                    select="@name"/>
                                <xsl:if test="$sectionRef = $labelsRef">
                                    <xsl:variable name="sectionLabelsLabel" 
                                        select="normalize-space(label)"/>   
                                    <xsl:value-of select="concat($i18n/sections/*[name() = $lang], ' ', $sectionLabelsLabel)"/><xsl:text>&#xA;</xsl:text>
                                    <xsl:for-each select="1 to string-length(concat($i18n/sections/*[name() = $lang], ' ', $sectionLabelsLabel))">=</xsl:for-each><xsl:text>&#xA;</xsl:text>
                                    </xsl:if>
                            </xsl:for-each>
                            <xsl:if test="count($strings/strings/*[name() = $checkSectionNameHelp]) = 0">
                                <xsl:value-of select="concat('**',$i18n/desc/*[name() = $lang],'** : ',$i18n/tbd/*[name() = $lang])"/><xsl:text>&#xA;</xsl:text>
                            </xsl:if>
                            <xsl:text>&#xA;</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                    
                    <xsl:for-each select="field">
                        <xsl:variable name="fieldRef" select="normalize-space(tokenize(@xpath,'/')[last()])"/>
                        <xsl:variable name="fieldRefUppercase" select="concat(upper-case(substring(substring-after($fieldRef, ':'),1,1)), substring(substring-after($fieldRef, ':'), 2))"/>
                        <xsl:variable name="fieldRefBase" select="substring-before(substring-after(substring-after(@xpath, '/'),'/'),'/')"/>
                        <!--TO DO Retreive the correct element in a list of element with the same name (context/path)-->
                        <xsl:variable name="duplicateElement">
                            <xsl:choose>
                                <xsl:when test="count($labels/labels/element[@name = $fieldRef]) > 1">yes</xsl:when>
                                <xsl:otherwise>no</xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:choose>
                            <xsl:when test="@name">
                                <xsl:variable name="fieldName" select="@name"/>
                                <xsl:for-each select="$strings/strings">
                                    <xsl:for-each select="node()">
                                        <xsl:variable name="checkFieldName">
                                            <xsl:if test="name() = $fieldName">
                                                <xsl:value-of select="normalize-space(.)"/>
                                            </xsl:if>
                                        </xsl:variable>
                                        <xsl:if test="name() = $fieldName">
                                            <xsl:value-of select="concat('**',$i18n/fields/*[name() = $lang], ' ', $checkFieldName,'**')"/><xsl:text>&#xA;</xsl:text><xsl:text>&#xA;</xsl:text>
                                            <!--xsl:for-each select="1 to string-length(concat($i18n/fields/*[name() = $lang], ' ', $checkFieldName))">'</xsl:for-each><xsl:text>&#xA;</xsl:text-->
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:for-each>
                             </xsl:when>
                             <xsl:otherwise>
                                <xsl:for-each select="$labels//element">
                                    <xsl:variable name="labelsRef" 
                                        select="@name"/>
                                    <xsl:if test="$fieldRef = $labelsRef">
                                        <xsl:variable name="labelsLabel" 
                                            select="normalize-space(label)"/>
                                        <xsl:value-of select="concat('**',$i18n/fields/*[name() = $lang], ' ', $labelsLabel,'**')"/><xsl:text>&#xA;</xsl:text><xsl:text>&#xA;</xsl:text>
                                        <!--xsl:for-each select="1 to string-length(concat($i18n/fields/*[name() = $lang], ' ', $labelsLabel))">'</xsl:for-each><xsl:text>&#xA;</xsl:text-->
                                    </xsl:if>
                                </xsl:for-each>
                                <xsl:if test="count($labels//element[@name = $fieldRef])=0">
                                    <xsl:value-of select="concat('**',$i18n/unfields/*[name() = $lang], ' ', $fieldRef,'**')"/><xsl:text>&#xA;</xsl:text><xsl:text>&#xA;</xsl:text>
                                 </xsl:if>
                             </xsl:otherwise>
                        </xsl:choose>

                        <xsl:for-each select="$labels//element">
                            <xsl:variable name="labelRef" 
                                select="@name"/>
                            <xsl:variable name="labelContext">
                                <xsl:if test="@context">
                                    <xsl:value-of select="@context"/>
                                </xsl:if>
                            </xsl:variable>
                            
                            <xsl:choose>
                                <xsl:when test="$fieldRef = $labelRef and $duplicateElement = 'no'">
                                    <xsl:if test="description[count(@iso)=0]">
                                        <xsl:if test="description[count(@iso)=0] = ''">
                                            <xsl:value-of select="concat('- **',$i18n/desc/*[name() = $lang],'** - ',$i18n/tbc/*[name() = $lang])"/>
                                            <xsl:text>&#xA;</xsl:text>
                                        </xsl:if>
                                        <xsl:if test="description[count(@iso)=0] != ''">
                                            <xsl:value-of select="concat('- **',$i18n/desc/*[name() = $lang],'** - ')"/><xsl:value-of select="normalize-space(description[count(@*)=0])"/>
                                            <xsl:text>&#xA;</xsl:text>
                                        </xsl:if>
                                    </xsl:if>
                                    <xsl:if test="description[count(@iso)=1]">
                                        <xsl:value-of select="concat('- **',$i18n/desc/*[name() = $lang],' (iso)** - ')"/><xsl:value-of select="normalize-space(description[count(@*)=1])"/>
                                        <xsl:text>&#xA;</xsl:text>
                                    </xsl:if>  
                                
                                <!--TO DO CODELISTS - generate full mtd to find links betewen labels definition and codelists-->
                                <!--
                                <xsl:for-each select="$codelists/codelists/codelist">
                                    <xsl:if test="substring-before(substring-after(@name, '_'),'Code')= $fieldRefUppercase">
                                        <xsl:text>:Code lists : </xsl:text>
                                        <xsl:text>&#xA;</xsl:text>
                                       <xsl:for-each select="entry">
                                           <xsl:text> - </xsl:text><xsl:value-of select="normalize-space(label)"/> <xsl:text> - </xsl:text>
                                           <xsl:value-of select="normalize-space(description)"/><xsl:text>&#xA;</xsl:text>
                                       </xsl:for-each>
                                       <xsl:value-of select="@name"/>
                                   </xsl:if>
                                </xsl:for-each>
                                -->
                                    <xsl:if test="help[count(@for)=0]">
                                        <xsl:if test="help[count(@for)=0] = ''">
                                            <xsl:value-of select="concat('- **',$i18n/moreInfo/*[name() = $lang],'** - ',$i18n/tbc/*[name() = $lang])"/>
                                            <xsl:text>&#xA;</xsl:text>
                                        </xsl:if>
                                        <xsl:if test="help[count(@for)=0] != ''">
                                            <xsl:for-each select="help[count(@for)=0]">
                                                <xsl:value-of select="concat('- **',$i18n/moreInfo/*[name() = $lang],'** - ')"/><xsl:value-of select="normalize-space(.)"/>
                                                <xsl:text>&#xA;</xsl:text>
                                            </xsl:for-each> 
                                        </xsl:if>
                                    </xsl:if>
                                    <xsl:if test="help[@for = 'inspire']">
                                        <xsl:for-each select="help[@for = 'inspire']">
                                            <xsl:value-of select="concat('- **',$i18n/moreInfo/*[name() = $lang],' (Inspire)** - ')"/><xsl:value-of select="normalize-space(.)"/>
                                            <xsl:text>&#xA;</xsl:text>
                                        </xsl:for-each>                    
                                    </xsl:if>
                                    <xsl:if test="helper">
                                        <xsl:value-of select="concat('- **',$i18n/helper/*[name() = $lang],'**')"/><xsl:text>&#xA;</xsl:text>
                                        <xsl:for-each select="helper/option">
                                            <xsl:text>&#x09;</xsl:text><xsl:value-of select="concat('- ',normalize-space(.))"/><xsl:text>&#xA;</xsl:text>
                                            <!--xsl:if test="@value">(<xsl:value-of select="@value"/>)</xsl:if-->
                                            <xsl:text>&#xA;</xsl:text>
                                    </xsl:for-each>
                                    <xsl:text>&#xA;</xsl:text>
                                    </xsl:if>
                             </xsl:when>
                            <!-- DUPLICATE ELEMENT
                            <xsl:when test="$fieldRef = $labelRef and $duplicateElement = 'yes'">
TEST YES
duplicate - <xsl:value-of select="$fieldRef"/>- <xsl:value-of select="$fieldRefBase"/>
                                <xsl:text>&#xA;</xsl:text>
                            </xsl:when>
                            -->
                                <xsl:otherwise>
                                </xsl:otherwise>
                            </xsl:choose>
                            
                        </xsl:for-each>
                        <xsl:text>&#xA;</xsl:text>
                        <xsl:text>&#x09;</xsl:text>
                        <xsl:value-of select="normalize-space(@xpath)"/>
                        <xsl:text>&#xA;</xsl:text>
                    </xsl:for-each>
                </xsl:for-each> 
            </xsl:for-each> 
        </xsl:for-each>
        

        <xsl:value-of select="$i18n/glossary/*[name() = $lang]"/><xsl:text>&#xA;</xsl:text>
        <xsl:for-each select="1 to string-length($i18n/glossary/*[name() = $lang])">-</xsl:for-each><xsl:text>&#xA;</xsl:text>
        
        <xsl:for-each select="$labels//element">
            <xsl:sort select="@name"/>
            <xsl:text>&#xA;</xsl:text>
            <xsl:value-of select="@name"/> - <xsl:value-of select="label"/><xsl:text>&#xA;</xsl:text>
            <xsl:for-each select="1 to string-length(concat(@name, ' - ',label))">*</xsl:for-each><xsl:text>&#xA;</xsl:text>
            <xsl:text>&#xA;</xsl:text>
            <xsl:if test="@context">
                <xsl:text>&#x09;</xsl:text><xsl:value-of select="normalize-space(@context)"/><xsl:text>&#xA;</xsl:text>
            </xsl:if>
<!--TO DO HTML - Check result in order to tranform html element in rst element if necessary-->      
            <xsl:if test="description[count(@iso)=0]">
                <xsl:if test="description[count(@iso)=0] = ''">
                    <xsl:value-of select="concat('- **',$i18n/desc/*[name() = $lang],'** - ',$i18n/tbc/*[name() = $lang])"/>
                    <xsl:text>&#xA;</xsl:text>
                </xsl:if>
                <xsl:if test="description[count(@iso)=0] != ''">
                    <xsl:value-of select="concat('- **',$i18n/desc/*[name() = $lang],'** - ')"/><xsl:value-of select="normalize-space(description[count(@*)=0])"/>
                    <xsl:text>&#xA;</xsl:text>
                </xsl:if>
            </xsl:if>
            <xsl:if test="description[count(@iso)=1]">
                <xsl:value-of select="concat('- **',$i18n/desc/*[name() = $lang],' (iso)** - ')"/><xsl:value-of select="normalize-space(description[count(@*)=1])"/>
                <xsl:text>&#xA;</xsl:text>
            </xsl:if>
            <xsl:if test="condition != ''">
                <xsl:value-of select="concat('- **',$i18n/cond/*[name() = $lang],' (iso)** - ')"/><xsl:value-of select="normalize-space(condition)"/>
                <xsl:text>&#xA;</xsl:text>
            </xsl:if>
            <xsl:if test="_condition != ''">
                <xsl:value-of select="concat('- **',$i18n/cond/*[name() = $lang],' (iso)** - ')"/><xsl:value-of select="normalize-space(_condition)"/>
                <xsl:text>&#xA;</xsl:text>
            </xsl:if>
            <xsl:if test="help[count(@for)=0]">
                <xsl:if test="help[count(@for)=0] = ''">
                    <xsl:value-of select="concat('- **',$i18n/moreInfo/*[name() = $lang],'** - ',$i18n/tbc/*[name() = $lang])"/>
                    <xsl:text>&#xA;</xsl:text>
                </xsl:if>
                <xsl:if test="help[count(@for)=0] != ''">
                <xsl:for-each select="help[count(@for)=0]">
                    <xsl:value-of select="concat('- **',$i18n/moreInfo/*[name() = $lang],'** - ')"/><xsl:value-of select="normalize-space(.)"/>
                    <xsl:text>&#xA;</xsl:text>
                </xsl:for-each> 
                </xsl:if>
            </xsl:if>
            <xsl:if test="help[@for = 'inspire']">
                <xsl:for-each select="help[@for = 'inspire']">
                    <xsl:value-of select="concat('- **',$i18n/moreInfo/*[name() = $lang],' (Inspire)** - ')"/><xsl:value-of select="normalize-space(.)"/>
                    <xsl:text>&#xA;</xsl:text>
                </xsl:for-each>                    
            </xsl:if>
            <xsl:if test="helper">
                <xsl:value-of select="concat('- **',$i18n/helper/*[name() = $lang],'**')"/><xsl:text>&#xA;</xsl:text>
                <xsl:for-each select="helper/option">
                    <xsl:text>&#x09;</xsl:text><xsl:value-of select="concat('- ',normalize-space(.))"/><xsl:text>&#xA;</xsl:text>
                    <!--xsl:if test="@value">(<xsl:value-of select="@value"/>)</xsl:if-->
                </xsl:for-each>
                <xsl:text>&#xA;</xsl:text>
            </xsl:if>
<!--TO DO CODELISTS - generate full mtd to find links betewen labels definition and codelists-->
<!--<xsl:for-each select="$codelists/codelists/codelist">
     <xsl:if test="substring-before(substring-after(@name, '_'),'Code')= $fieldRefUppercase">
           <xsl:text>Links  to be added </xsl:text>
      </xsl:if>
</xsl:for-each>-->   
        </xsl:for-each>
        

        
        <!-- Create the codelists glossary -->

        <xsl:text>&#xA;</xsl:text><xsl:value-of select="$i18n/codeLists/*[name() = $lang]"/><xsl:text>&#xA;</xsl:text>
        <xsl:for-each select="1 to string-length($i18n/codeLists/*[name() = $lang])">-</xsl:for-each><xsl:text>&#xA;</xsl:text>
        <xsl:if test="not($codelists//codelist)">
            <xsl:value-of select="$i18n/notapp/*[name() = $lang]"/>
        </xsl:if>
        <xsl:for-each select="$codelists//codelist">
            
            <xsl:sort select="@name"/>
            <xsl:if test="not(codelist)"></xsl:if>
            <xsl:variable name="codeListName" select="@name"/>
            <xsl:value-of select="$codeListName"/><xsl:text>&#xA;</xsl:text>
            <xsl:for-each select="1 to string-length($codeListName)">*</xsl:for-each><xsl:text>&#xA;</xsl:text>
            <xsl:for-each select="entry">
                <xsl:value-of select="concat('- ',normalize-space(label))"/>
                <xsl:if test="description"><xsl:text> - </xsl:text>
                    <xsl:value-of select="normalize-space(description)"/>
                </xsl:if>
                <xsl:text>&#xA;</xsl:text>
            </xsl:for-each>
            <xsl:text>&#xA;</xsl:text>
        </xsl:for-each>

    </xsl:template>
</xsl:stylesheet>