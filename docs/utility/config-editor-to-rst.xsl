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
      <editor-config>Metadata editor</editor-config>
      <glossary>Standard elements</glossary>
      <glossary-help>List of all elements available in the standard.</glossary-help>
      <codelists>Standard codelists</codelists>
      <codelists-help>List of all codelists available in the standard.</codelists-help>
      <noCodelist>No codelist defined.</noCodelist>
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
      <codelist>Standard codelists: </codelist>
      <flatModeExceptions>This view allows to add the following element even if not in the current record:</flatModeExceptions>
      <xpath>XPath: </xpath>
      <displayIf>Display only if: </displayIf>
    </eng>
    <fre>
      <title>Standard ISO pour les métadonnées liées aux informations géographiques - ISO </title>
      <editor-config>Encodage de métadonnée</editor-config>
      <glossary>Éléments du standard</glossary>
      <glossary-help>Liste des descripteurs définis dans le standard de métadonnées.</glossary-help>
      <codelists>Listes de valeurs du standard</codelists>
      <codelists-help>Listes de valeurs définies dans le standard de métadonnées.</codelists-help>
      <noCodelist>Aucune liste de valeurs.</noCodelist>
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
      <codelist>Liste de valeurs : </codelist>
      <flatModeExceptions>Cette vue permet la saisie des éléments suivant même s'ils ne sont pas dans la fiche en cours d'édition :</flatModeExceptions>
      <xpath>XPath : </xpath>
      <displayIf>Afficher uniquement si : </displayIf>
    </fre>
  </xsl:variable>

  <xsl:variable name="schemaFolder"
              select="concat('../../schemas/', $schema, '/src/main/plugin/', $schema)"/>
  <xsl:variable name="editorConfig"
                select="document(concat($schemaFolder, '/layout/config-editor.xml'))"/>
  <xsl:variable name="schemaConfig"
                select="document(concat($schemaFolder, '/schema-ident.xml'))"/>
  <xsl:variable name="labels"
                select="document(concat($schemaFolder, '/loc/', $lang, '/labels.xml'))/labels/element"/>
  <xsl:variable name="strings"
                select="document(concat($schemaFolder, '/loc/', $lang, '/strings.xml'))/strings/*"/>
  <xsl:variable name="codelists"
                select="document(concat($schemaFolder, '/loc/', $lang, '/codelists.xml'))/codelists/codelist"/>
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

  <xsl:function name="gndoc:refTo">
    <xsl:param name="id" as="xs:string?"/>
    <xsl:text>:ref:`</xsl:text><xsl:value-of select="concat($schemaId, '-', $id)"/>`
  </xsl:function>



  <!-- max-line-length -->
  <xsl:function name="gndoc:mll" as="xs:integer">
    <xsl:param name="arg" as="node()*"/>

    <xsl:sequence select="max(
                     for $line in $arg
                     return string-length($line))"/>
  </xsl:function>



  <!-- Table builder

      =======  ==========
      code     label
      =======  ==========
      after    Après
      before   Avant
      now      Maintenant
      unknown  Inconnu
      =======  ==========
  -->
  <xsl:function name="gndoc:table">
    <xsl:param name="rows" as="node()"/>

    <xsl:variable name="s" select="'  '"/>
    <xsl:text>&#xA;</xsl:text>
    <xsl:text></xsl:text>
    <!-- Rows -->
    <xsl:for-each select="$rows">
      <!-- Header -->
      <xsl:if test="position() = 1">
        <!-- Cols -->
        <xsl:for-each select="*[1]/*">
          <xsl:variable name="colName" select="name()"/>
          <xsl:for-each select="1 to gndoc:mll($rows/*/*[name() = $colName])">=</xsl:for-each>
          <xsl:if test="position() != last()">
            <xsl:value-of select="$s"/>
          </xsl:if>
        </xsl:for-each>
        <xsl:text>&#xA;</xsl:text>
        <!-- Cols label -->
        <xsl:for-each select="*[1]/*">
          <xsl:variable name="colName" select="name()"/>
          <xsl:variable name="maxColLength"
                        select="gndoc:mll($rows/*/*[name() = $colName])"/>
          <xsl:variable name="missingSpaces"
                        select="$maxColLength - string-length($colName)"/>

          <xsl:value-of select="$colName"/>
          <xsl:if test="position() != last()">
            <xsl:value-of select="$s"/>
          </xsl:if>
          <xsl:for-each select="1 to $missingSpaces"><xsl:text> </xsl:text></xsl:for-each>
        </xsl:for-each>
        <xsl:text>&#xA;</xsl:text>
        <xsl:for-each select="*[1]/*">
          <xsl:variable name="colName" select="name()"/>
          <xsl:for-each select="1 to gndoc:mll($rows/*/*[name() = $colName])">=</xsl:for-each>
          <xsl:if test="position() != last()">
            <xsl:value-of select="$s"/>
          </xsl:if>
        </xsl:for-each>
        <xsl:text>&#xA;</xsl:text>
      </xsl:if>

      <xsl:for-each select="*">
        <xsl:for-each select="*">
          <xsl:variable name="colName" select="name()"/>
          <xsl:variable name="colValue" select="normalize-space()"/>
          <xsl:variable name="maxColLength"
                        select="gndoc:mll($rows/*/*[name() = $colName])"/>
          <xsl:variable name="missingSpaces"
                        select="$maxColLength - string-length($colValue)"/>
          <xsl:value-of select="$colValue"/>
          <xsl:if test="position() != last()">
            <xsl:value-of select="$s"/>
          </xsl:if>
          <xsl:for-each select="1 to $missingSpaces"><xsl:text> </xsl:text></xsl:for-each>
        </xsl:for-each>
        <xsl:text>&#xA;</xsl:text>
      </xsl:for-each>

      <!-- Footer -->
      <xsl:for-each select="*[1]/*">
        <xsl:variable name="colName" select="name()"/>
        <xsl:for-each select="1 to gndoc:mll($rows/*/*[name() = $colName])">=</xsl:for-each>
        <xsl:if test="position() != last()">
          <xsl:value-of select="$s"/>
        </xsl:if>
      </xsl:for-each>
      <xsl:text>&#xA;</xsl:text>
    </xsl:for-each>
    <xsl:text>&#xA;</xsl:text>
  </xsl:function>
  
  
  <!-- New line -->
  <xsl:function name="gndoc:nl">
    <xsl:value-of select="gndoc:nl(1)"/>
  </xsl:function>

  <xsl:function name="gndoc:nl">
    <xsl:param name="howMany" as="xs:integer"/>

    <xsl:for-each select="1 to $howMany">
      <xsl:text>&#xA;</xsl:text>
    </xsl:for-each>
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

    <xsl:call-template name="write-editor-doc"/>
    <xsl:call-template name="write-glossary"/>
    <xsl:call-template name="write-codelist"/>
  </xsl:template>

  <xsl:template name="write-editor-doc">
    <xsl:value-of select="gndoc:writeln($t/editor-config, '*')"/>
    <xsl:value-of select="gndoc:nl()"/>

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
          <xsl:value-of select="gndoc:nl(2)"/>
          <xsl:value-of select="gndoc:writeln($t/flatModeExceptions)"/>
          <xsl:value-of select="gndoc:nl()"/>
        </xsl:if>
        <!-- TODO Translate element -->
        <xsl:value-of select="gndoc:writeln(concat('* ', @name))"/>
      </xsl:for-each>
      <xsl:value-of select="gndoc:nl(2)"/>


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
            <xsl:value-of select="gndoc:nl(2)"/>
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

              <xsl:apply-templates select="$nodeDesc/helper" mode="doc"/>

              <xsl:value-of select="gndoc:writeln(concat('* ', $t/xpath, @xpath))"/>
              <xsl:value-of select="gndoc:nl(2)"/>
            </xsl:if>
          </xsl:for-each>
            <!-- TODO Handle template field -->
            <!-- TODO CODELISTS - generate full mtd to find links between labels definition and codelists-->

        </xsl:for-each>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>


  <xsl:template name="write-glossary">
    <xsl:value-of select="gndoc:writeln($t/glossary, '*')"/>
    <xsl:value-of select="gndoc:nl()"/>
    <xsl:value-of select="gndoc:writeln($t/glossary-help)"/>
    <xsl:value-of select="gndoc:nl(2)"/>

    <xsl:for-each select="$labels">
      <xsl:sort select="@name"/>

      <xsl:value-of select="gndoc:writeln(concat('**', label, '**'))"/>
      <xsl:value-of select="gndoc:nl(2)"/>

      <!-- A table would be better -->
      <xsl:value-of select="gndoc:writeln(concat('* ', @context, ''))"/>
      <xsl:for-each select="description|help">
        <xsl:variable name="flag"
                      select="if (@for) then concat('(', @for, ') ') else ''"/>
        <xsl:value-of select="gndoc:writeln(concat('* ', $flag, normalize-space(.)))"/>
      </xsl:for-each>

      <xsl:value-of select="gndoc:nl()"/>

      <xsl:for-each select="condition">
        <xsl:value-of select="gndoc:writeln(concat('* ', $t/cond, normalize-space(.)))"/>
      </xsl:for-each>

      <xsl:apply-templates select="helper" mode="doc"/>

      <!--TODO CODELISTS - generate full mtd to find links betewen labels definition and codelists-->
      <xsl:value-of select="gndoc:nl(3)"/>
    </xsl:for-each>
  </xsl:template>




  <xsl:template name="write-codelist">
    <xsl:value-of select="gndoc:writeln($t/codelists, '*')"/>
    <xsl:value-of select="gndoc:nl()"/>
    <xsl:value-of select="gndoc:writeln($t/codelists-help)"/>
    <xsl:value-of select="gndoc:nl(2)"/>

    <xsl:if test="not($codelists)">
      <xsl:value-of select="$t/noCodelist"/>
    </xsl:if>

    <xsl:apply-templates select="$codelists" mode="doc"/>
  </xsl:template>






  <xsl:template match="helper" mode="doc">
    <xsl:for-each select="option">
      <xsl:if test="position() = 1">
        <xsl:value-of select="gndoc:writeln($t/helper)"/>
        <!-- TODO conditional helper -->
        <xsl:value-of select="gndoc:nl(2)"/>
        <xsl:for-each select="@displayIf">
          <xsl:value-of select="gndoc:writeln(concat('(', $t/displayIf, .))"/>
        </xsl:for-each>
      </xsl:if>
      <xsl:value-of select="gndoc:writeln(concat('* ', normalize-space(.), ' (', @value, ')'))"/>
    </xsl:for-each>
  </xsl:template>


  <xsl:template match="codelist" mode="doc">
    <xsl:variable name="name" select="@name"/>
    <xsl:value-of select="gndoc:writeln(concat(
                            '**', $labels[@name = $name]/label, ' (', @name, ')**'
                            ))"/>
    <xsl:value-of select="gndoc:nl()"/>
    <!--
    Display using list
    <xsl:apply-templates select="entry" mode="doc"/>
    <xsl:value-of select="gndoc:nl(3)"/>

    ... or table layout
    -->
    <xsl:value-of select="gndoc:table(.)"/>
  </xsl:template>


  <xsl:template match="entry" mode="doc">
    <xsl:value-of select="gndoc:writeln(concat(
                            '* ', label, ' (', code, '): ', normalize-space(description)
                            ))"/>
  </xsl:template>
</xsl:stylesheet>