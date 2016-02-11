<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:gns="http://geonetwork-opensource.org/schemas/schema-ident"
    xmlns:gndoc="http://geonetwork-opensource.org/doc"
    exclude-result-prefixes="xs"
    version="2.0">

  <xsl:output method="text" encoding="UTF-8"/>
  <xsl:strip-space elements="*"/>

  <xsl:param name="lang" select="'fre'"/>
  <xsl:param name="schema" select="'iso19115-3'"/>


  <xsl:variable name="i18n">
    <eng>
      <!-- TODO: Move schema label in schema-ident.xml (to be done in GN) -->
      <!-- TODO: Add schema URL - link to the official version (to be done in GN) -->
      <title>ISO Standard for metadata on Geographic Information - ISO </title>
      <view>View: </view>
      <tab>Tab: </tab>
      <section>Section: </section>
      <field>Field: </field>
      <undefined>Undefined field: </undefined>
      <tag>Tag: </tag>
      <desc>Description: </desc>
      <more>More details: </more>
      <helper>Recommended values: </helper>
      <cond>Condition: </cond>
      <glossary>Standard elements list: </glossary>
      <codelist>Standard codelists: </codelist>
      <flatModeExceptions>This view allows to add the following element even if not in the current record:</flatModeExceptions>
      <xpath>XPath: </xpath>
    </eng>
    <fre>
      <title>Standard ISO pour les métadonnées liées aux informations géographiques - ISO </title>
      <view>Vue : </view>
      <tab>Onglet : </tab>
      <section>Section : </section>
      <field>Descripteur : </field>
      <undefined>Non défini : </undefined>
      <tag>Balise XML : </tag>
      <desc>Description : </desc>
      <more>Information complémentaire : </more>
      <helper>Valeurs recommandées : </helper>
      <cond>Condition : </cond>
      <glossary>Liste des descripteurs du standard : </glossary>
      <codelist>Liste de valeurs : </codelist>
      <flatModeExceptions>Cette vue permet la saisie des éléments suivant même s'ils ne sont pas dans la fiche en cours d'édition :</flatModeExceptions>
      <xpath>XPath : </xpath>
    </fre>
    <!-- TODO: revert -->
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
    <notapp>
        <eng>Undefined element</eng>
        <fre>Element non défini</fre>
    </notapp>
  </xsl:variable>

  <xsl:variable name="schemaFolder"
              select="concat('../../schemas/', $schema, '/src/main/plugin/', $schema)"/>
  <xsl:variable name="schemaConfig"
                select="document(concat($schemaFolder, '/schema-ident.xml'))"/>
  <xsl:variable name="labels"
                select="document(concat($schemaFolder, '/loc/', $lang, '/labels.xml'))/labels/element"/>
  <xsl:variable name="strings"
                select="document(concat($schemaFolder, '/loc/', $lang, '/strings.xml'))/strings/*"/>
  <xsl:variable name="codelists"
                select="document(concat($schemaFolder, '/loc/', $lang, '/codelists.xml'))/codelists/codelist"/>
  <xsl:variable name="editorConfig"
                select="document(concat($schemaFolder, '/layout/config-editor.xml'))"/>
  <xsl:variable name="t"
                select="$i18n/*[name() = $lang]"/>

  <xsl:variable name="schemaId"
                select="$schemaConfig/gns:schema/gns:name"/>

  <!-- Write a line -->
  <xsl:function name="gndoc:writeln">
    <xsl:param name="line" as="xs:string?"/>
<xsl:text>&#xA;</xsl:text><xsl:value-of select="$line"/>
  </xsl:function>

  <!-- Write line and underline it -->
  <xsl:function name="gndoc:writeln">
    <xsl:param name="line" as="xs:string+"/>
    <xsl:param name="underline" as="xs:string?"/>
    <xsl:text>&#xA;</xsl:text><xsl:value-of select="$line"/>
    <xsl:text>&#xA;</xsl:text><xsl:value-of select="replace($line, '.', $underline)"/>
    <xsl:text>&#xA;</xsl:text>
  </xsl:function>

  <!-- Create a RST reference. Prefixed by schema identifier to have them unique
   accross all documentation refs. -->
  <xsl:function name="gndoc:ref">
    <xsl:param name="id" as="xs:string?"/>
    <xsl:text>&#xA;.. _</xsl:text><xsl:value-of select="concat($schemaId, '-', $id)"/>:
    <xsl:text>&#xA;</xsl:text>
  </xsl:function>

  <!-- New line -->
  <xsl:function name="gndoc:nl">
    <xsl:text>&#xA;</xsl:text>
  </xsl:function>

  <xsl:template match="/">
    <!-- Reference based on schema identifier -->
    <xsl:value-of select="gndoc:ref('')"/>:

    <!-- Schema details -->
    <xsl:value-of select="gndoc:writeln(concat($t/title, ' (', $schema, ')'), '#')"/>
    <!--
    TODO: add:
    * main namespace
    * schema URL
    * autodetection information from schema-ident.xml
    -->

    <!-- Editor configuration description -->
    <xsl:for-each select="$editorConfig//views/view">
      <!-- Describe each views -->
      <xsl:variable name="viewName"
                    select="@name"/>
      <xsl:variable name="viewHelp"
                    select="$strings[name() = concat($viewName,'-help')]"/>

      <xsl:value-of select="gndoc:ref(concat('view-', $viewName))"/>

      <xsl:value-of select="gndoc:writeln(
                              concat($t/view, $strings[name() = $viewName],
                                     ' (', $viewName, ')'), '=')"/>
      <xsl:if test="$viewHelp != ''">
        <xsl:value-of select="gndoc:writeln($viewHelp)"/>
      </xsl:if>


      <xsl:for-each select="flatModeExceptions/for">
        <xsl:if test="position() = 1">
          <xsl:value-of select="gndoc:nl()"/>
          <xsl:value-of select="gndoc:nl()"/>
          <xsl:value-of select="gndoc:writeln($t/flatModeExceptions)"/>
          <xsl:value-of select="gndoc:nl()"/>
        </xsl:if>
        <!-- TODO Translate element -->
        <xsl:value-of select="gndoc:writeln(concat('* ', @name))"/>
      </xsl:for-each>
      <xsl:value-of select="gndoc:nl()"/>
      <xsl:value-of select="gndoc:nl()"/>


      <!-- Tab details -->
      <xsl:for-each select="tab">
        <xsl:variable name="tabName"
                      select="@id"/>
        <xsl:variable name="tabHelp"
                      select="$strings/*[name() = concat($tabName,'-help')]"/>

        <xsl:value-of select="gndoc:ref(concat('tab-', $tabName))"/>

        <xsl:value-of select="gndoc:writeln(
                              concat($t/tab, $strings[name() = $tabName],
                                     ' (', $tabName, ')'), '-')"/>
        <xsl:if test="$tabHelp != ''">
          <xsl:value-of select="gndoc:writeln($tabHelp)"/>
        </xsl:if>
        <xsl:value-of select="gndoc:nl()"/>

        <!-- Sections
        TODO: check if field are allowed here ?
        TODO: Make apply-templates with a mode to traverse the tree
        -->
        <xsl:for-each select=".//section">
          <xsl:variable name="sectionName"
                        select="@name"/>
          <xsl:variable name="sectionHelp"
                        select="$strings/*[name() = concat($sectionName,'-help')]"/>

          <!-- Section name is optional -->
          <xsl:choose>
            <xsl:when test="contains($sectionName,':')">
              <!-- Section name is a standard element -->
              <xsl:value-of select="gndoc:writeln(
                                        concat($t/section, $labels[name() = $sectionName]), '~')"/>
            </xsl:when>
            <xsl:when test="$sectionName != ''">
              <xsl:value-of select="gndoc:writeln(
                                        concat($t/section, $strings[name() = $sectionName]), '~')"/>
            </xsl:when>
          </xsl:choose>

          <!-- Section help is optional -->
          <xsl:if test="$sectionHelp != ''">
            <xsl:value-of select="gndoc:writeln($sectionHelp)"/>
          </xsl:if>
          <xsl:value-of select="gndoc:nl()"/>

          <xsl:if test="@xpath">
            <xsl:variable name="nodeName"
                          select="normalize-space(tokenize(@xpath,'/')[last()])"/>
            <!-- TODO: Handle context -->
            <xsl:variable name="nodeDesc"
                          select="$labels[@name = $nodeName]"/>

            <xsl:value-of select="gndoc:writeln(concat($t/section, $nodeDesc/label), '~')"/>
            <xsl:for-each select="$nodeDesc/description">
              <xsl:value-of select="gndoc:writeln(normalize-space(.))"/>
            </xsl:for-each>
            <xsl:value-of select="gndoc:nl()"/>
            <xsl:value-of select="gndoc:writeln(concat('* ', $t/xpath, @xpath))"/>
            <xsl:value-of select="gndoc:nl()"/>
            <xsl:value-of select="gndoc:nl()"/>
          </xsl:if>


          <!-- TODO Handle template action -->
          <!-- TODO Handle template help -->
          <!-- TODO Handle nested elements -->

          <xsl:for-each select="field">
            <xsl:if test="@name">
              <!-- TODO same as section / use apply-templates -->
              <xsl:variable name="name"
                            select="@name"/>
              <xsl:variable name="help"
                            select="$strings/*[name() = concat($name,'-help')]"/>

              <!-- name is optional -->
              <xsl:choose>
                <xsl:when test="contains($name,':')">
                  <!-- Section name is a standard element -->
                  <xsl:value-of select="gndoc:writeln(
                                        concat('**', $labels[name() = $name], '**'))"/>
                  <xsl:value-of select="gndoc:nl()"/>
                </xsl:when>
                <xsl:when test="$name != ''">
                  <xsl:value-of select="gndoc:writeln(
                                        concat('* ', $t/desc, $strings[name() = $name]))"/>
                </xsl:when>
              </xsl:choose>

              <!-- help is optional -->
              <xsl:if test="$sectionHelp != ''">
                <xsl:value-of select="gndoc:writeln($sectionHelp)"/>
              </xsl:if>
              <xsl:value-of select="gndoc:nl()"/>
            </xsl:if>

            <xsl:if test="@xpath">
              <!-- TODO same as section / use apply-templates -->
              <xsl:variable name="nodeName"
                            select="normalize-space(tokenize(@xpath,'/')[last()])"/>
              <!-- TODO: Handle element with context = parent element or full xpath -->
              <xsl:variable name="nodeDesc"
                            select="$labels[@name = $nodeName][position() = 1]"/>

              <!-- TODO Add inspire or other flag -->
              <xsl:value-of select="gndoc:writeln(concat('**', $nodeDesc/label, '**'))"/>
              <xsl:value-of select="gndoc:nl()"/>
              <xsl:for-each select="$nodeDesc/description">
                <xsl:value-of select="gndoc:writeln(concat('* ', $t/desc, normalize-space(.)))"/>
              </xsl:for-each>
              <xsl:value-of select="gndoc:nl()"/>

              <!-- TODO: Handle conditional helper -->
              <xsl:for-each select="$nodeDesc/helper/option">
                <xsl:if test="position() = 1">
                  <xsl:value-of select="gndoc:writeln($t/helper)"/>
                </xsl:if>
                <xsl:value-of select="gndoc:writeln(concat('* ', ., ' (', @value, ')'))"/>
              </xsl:for-each>

              <xsl:value-of select="gndoc:writeln(concat('* ', $t/xpath, @xpath))"/>
              <xsl:value-of select="gndoc:nl()"/>
              <xsl:value-of select="gndoc:nl()"/>
            </xsl:if>
          </xsl:for-each>
            <!-- TODO Handle template field -->
            <!-- TODO CODELISTS - generate full mtd to find links between labels definition and codelists-->
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

              <!--<xsl:for-each select="$labels//element">
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
                   </xsl:when>-->
                  <!-- DUPLICATE ELEMENT
                  <xsl:when test="$fieldRef = $labelRef and $duplicateElement = 'yes'">
TEST YES
duplicate - <xsl:value-of select="$fieldRef"/>- <xsl:value-of select="$fieldRefBase"/>
                      <xsl:text>&#xA;</xsl:text>
                  </xsl:when>
                  -->
        </xsl:for-each>
      </xsl:for-each>
    </xsl:for-each>

        <xsl:value-of select="$i18n/glossary/*[name() = $lang]"/><xsl:text>&#xA;</xsl:text>
        <xsl:for-each select="1 to string-length($i18n/glossary/*[name() = $lang])">-</xsl:for-each><xsl:text>&#xA;</xsl:text>

        <xsl:for-each select="$labels">
            <xsl:sort select="@name"/>
            <xsl:text>&#xA;</xsl:text>
            <xsl:value-of select="@name"/> - <xsl:value-of select="label"/><xsl:text>&#xA;</xsl:text>
            <xsl:for-each select="1 to string-length(concat(@name, ' - ',label))">*</xsl:for-each><xsl:text>&#xA;</xsl:text>
            <xsl:text>&#xA;</xsl:text>
            <xsl:if test="@context">
                <xsl:text>&#x09;</xsl:text><xsl:value-of select="normalize-space(@context)"/><xsl:text>&#xA;</xsl:text>
            </xsl:if>
<!--TODO: HTML - Check result in order to tranform html element in rst element if necessary-->
            <xsl:for-each select="description[count(@iso)=0][text()!='']">
                <xsl:value-of select="concat('- **',$i18n/desc/*[name() = $lang],'** - ',$i18n/tbc/*[name() = $lang])"/>
                <xsl:text>&#xA;</xsl:text>
                <xsl:value-of select="concat('- **',$i18n/desc/*[name() = $lang],'** - ')"/><xsl:value-of select="normalize-space(.)"/>
                <xsl:text>&#xA;</xsl:text>
            </xsl:for-each>
          <!--
          Error on line 389 of config-editor-to-rst.xsl:
  XPTY0004: A sequence of more than one item is not allowed as the first argument of
  normalize-space() ("Indication sur le résultat de...", "")
  at xsl:for-each (file:/data/dev/gn/mw/4.x/docs/utility/config-editor-to-rst.xsl#373)
     processing /labels/element[160]
          -->
            <xsl:for-each select="description[count(@iso)=1]">
                <xsl:value-of select="concat('- **',$i18n/desc/*[name() = $lang],' (iso)** - ')"/><xsl:value-of select="normalize-space(.)"/>
                <xsl:text>&#xA;</xsl:text>
            </xsl:for-each>
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
        <xsl:if test="not($codelists)">
            <xsl:value-of select="$i18n/notapp/*[name() = $lang]"/>
        </xsl:if>
        <xsl:for-each select="$codelists">

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