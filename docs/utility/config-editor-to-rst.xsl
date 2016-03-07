<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:gns="http://geonetwork-opensource.org/schemas/schema-ident"
    xmlns:gndoc="http://geonetwork-opensource.org/doc"
    exclude-result-prefixes="xs"
    version="2.0">

  <xsl:import href="rst-writer.xsl"/>



  <xsl:param name="lang"
             select="'fre'"/>
  <xsl:param name="iso2lang"
             select="'fr'"/>
  <xsl:param name="schema"
             select="'iso19115-3'"/>


  <xsl:variable name="i18n"
                select="document('config-editor-i18n.xml')
                          /i18n"/>
  <xsl:variable name="folder"
                select="concat('../../schemas/', $schema)"/>
  <xsl:variable name="docFolder"
                select="concat($folder, '/doc/', $iso2lang)"/>
  <xsl:variable name="pluginFolder"
                select="concat($folder, '/src/main/plugin/', $schema)"/>
  <xsl:variable name="ec"
                select="document(concat($pluginFolder, '/layout/config-editor.xml'))"/>
  <!-- A metadata template to detail encoding -->
  <xsl:variable name="tpl"
                select="document(concat('../../schemas/', $schema, '/doc/tpl.xml'))"/>
  <xsl:variable name="sc"
                select="document(concat($pluginFolder, '/schema-ident.xml'))
                          /gns:schema"/>
  <xsl:variable name="l"
                select="document(concat($pluginFolder, '/loc/', $lang, '/labels.xml'))
                          /labels/element"/>
  <xsl:variable name="s"
                select="document(concat($pluginFolder, '/loc/', $lang, '/strings.xml'))
                          /strings/*"/>
  <xsl:variable name="c"
                select="document(concat($pluginFolder, '/loc/', $lang, '/codelists.xml'))
                          /codelists/codelist"/>
  <xsl:variable name="t"
                select="$i18n/*[name() = $lang]"/>
  <xsl:variable name="schemaId"
                select="$sc/gns:name"/>
  <xsl:variable name="schemaTitle"
                select="$sc/gns:title[@xml:lang = $iso2lang or not(@xml:lang)]"/>
  <xsl:variable name="schemaDesc"
                select="$sc/gns:description[@xml:lang = $iso2lang or not(@xml:lang)]"/>
  <xsl:variable name="schemaUrl"
                select="$sc/gns:standardUrl[@xml:lang = $iso2lang or not(@xml:lang)]"/>



  <xsl:template match="/">
    <!-- Reference based on schema identifier -->
    <xsl:value-of select="gndoc:ref($schemaId)"/>

    <!-- Schema details -->
    <xsl:value-of select="gndoc:writeln(concat($schemaTitle, ' (', $schema, ')'), '#')"/>

    <xsl:value-of select="gndoc:nl(2)"/>
    <xsl:value-of select="gndoc:writeln($schemaDesc)"/>
    <xsl:value-of select="gndoc:nl(2)"/>
    <xsl:value-of select="gndoc:writeln(concat($t/schema-url, $schemaUrl))"/>
    <xsl:value-of select="gndoc:nl(2)"/>

    <!--
    TODO: add:
    * main namespace
    * autodetection information from schema-ident.xml
    -->

    <xsl:call-template name="write-editor-doc"/>
    <xsl:call-template name="write-schema-details"/>
    <xsl:call-template name="write-glossary"/>
    <xsl:call-template name="write-codelist"/>
  </xsl:template>

  <xsl:template name="write-editor-doc">
    <xsl:value-of select="gndoc:writeln($t/editor-config, '*')"/>
    <xsl:value-of select="gndoc:nl()"/>


    <xsl:value-of select="gndoc:writeln(concat($t/nbOfViews, count($ec//views/view), $t/views))"/>
    <xsl:value-of select="gndoc:nl(2)"/>
    <xsl:for-each select="$ec//views/view">
      <xsl:text>* </xsl:text><xsl:value-of select="gndoc:refTo(concat($schemaId, '-view-', @name))"/>
      <xsl:value-of select="gndoc:nl()"/>
    </xsl:for-each>

    <!-- Editor configuration description -->
    <xsl:for-each select="$ec//views/view">
      <!-- Describe each views -->
      <xsl:variable name="viewName"
                    select="@name"/>
      <xsl:variable name="viewHelp"
                    select="$s[name() = concat($viewName,'-help')]"/>

      <xsl:value-of select="gndoc:ref(concat($schemaId, '-view-', $viewName))"/>

      <xsl:value-of select="gndoc:writeln(
                              concat($t/view, ' ', $s[name() = $viewName],
                                     ' (', $viewName, ')'), '=')"/>
      <xsl:if test="$viewHelp != ''">
        <xsl:value-of select="gndoc:writeln($viewHelp)"/>
      </xsl:if>

      <!-- Number of tabs in this view -->
      <xsl:value-of select="gndoc:writeln(concat($t/nbOfTabs, count(tab), $t/tabs))"/>
      <xsl:value-of select="gndoc:nl(2)"/>
      <xsl:for-each select="tab">
        <xsl:text>* </xsl:text><xsl:value-of select="gndoc:refTo(concat($schemaId, '-tab-', @id))"/>
        <xsl:value-of select="gndoc:nl()"/>
      </xsl:for-each>

      <!-- TODO screenshot if available -->

      <xsl:for-each select="flatModeExceptions/for">
        <xsl:if test="position() = 1">
          <xsl:value-of select="gndoc:nl(2)"/>
          <xsl:value-of select="gndoc:writeln($t/flatModeExceptions)"/>
          <xsl:value-of select="gndoc:nl()"/>
        </xsl:if>

        <xsl:variable name="name" select="@name"/>
        <xsl:choose>
          <xsl:when test="$l[@name = $name]/label = ''">
            <xsl:message>  * Missing label for <xsl:value-of select="$name"/> </xsl:message>
          </xsl:when>
          <xsl:otherwise>
            <!-- TODO handle context/xpath and remove select first -->
            <xsl:value-of select="gndoc:writeln(concat('* ', $l[@name = $name][1]/label, ' (', $name, ')'))"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
      <xsl:value-of select="gndoc:nl(2)"/>


      <!-- Tab details -->
      <xsl:for-each select="tab">
        <xsl:variable name="tabName"
                      select="@id"/>
        <xsl:variable name="tabHelp"
                      select="$s/*[name() = concat($tabName,'-help')]"/>

        <xsl:value-of select="gndoc:ref(concat($schemaId, '-tab-', $tabName))"/>

        <xsl:value-of select="gndoc:writeln(
                              concat($t/tab, ' ', $s[name() = $tabName],
                                     ' (', $tabName, ')'), '-')"/>
        <xsl:if test="$tabHelp != ''">
          <xsl:value-of select="gndoc:writeln($tabHelp)"/>
        </xsl:if>
        <xsl:value-of select="gndoc:nl()"/>

        <xsl:value-of select="gndoc:figure($docFolder, concat('img/', $schemaId, '-tab-', $tabName, '.png'))"/>


        <xsl:value-of select="gndoc:writeln(
            if (@mode = 'flat') then $t/flatMode else $t/notFlatMode)"/>
        <xsl:value-of select="gndoc:nl()"/>


        <!-- Sections
        TODO: check if field are allowed here ?
        TODO: Make apply-templates with a mode to traverse the tree
        -->
        <xsl:for-each select=".//section">
          <xsl:variable name="sectionName"
                        select="@name"/>

          <!-- Section name is optional -->
          <xsl:choose>
            <!-- Section name is an element name -->
            <xsl:when test="contains($sectionName,':')">
              <!-- Section name is a standard element eg. mdb:MD_Metadata. Use labels.xml. -->
              <xsl:variable name="nodeDesc"
                            select="$l[@name = $sectionName]"/>
              <xsl:value-of select="gndoc:writeln(
                                        concat($t/section, ' ', $nodeDesc/label), '^')"/>

              <xsl:for-each select="$nodeDesc/(description|help)">
                <xsl:value-of select="gndoc:writeln(normalize-space(.))"/>
                <xsl:value-of select="gndoc:nl(2)"/>
              </xsl:for-each>

              <xsl:value-of select="$t/cf"/><xsl:value-of select="gndoc:refTo(concat($schemaId, '-elem-', $sectionName))"/>
            </xsl:when>
            <xsl:when test="$sectionName != ''">
              <!-- Section name is a custom name. Use strings.xml. -->
              <xsl:choose>
                <xsl:when test="normalize-space($s[name() = $sectionName][1]) = ''">
                  <xsl:message>  * Missing section name for <xsl:value-of select="$sectionName"/> </xsl:message>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="gndoc:writeln(
                                        concat($t/section, ' ', $s[name() = $sectionName]), '^')"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
          </xsl:choose>



          <!-- Section help is optional. -->
          <xsl:variable name="sectionHelp"
                        select="$s/*[name() = concat($sectionName,'-help')]"/>

          <xsl:if test="$sectionHelp != ''">
            <xsl:value-of select="gndoc:writeln($sectionHelp)"/>
          </xsl:if>
          <xsl:value-of select="gndoc:nl()"/>


          <!-- Section is an XPath. Retrieve last element name of the XPath
          and display information from labels.xml -->
          <xsl:if test="@xpath">
            <xsl:variable name="nodeName"
                          select="tokenize(
                                      tokenize(
                                        normalize-space(@xpath),
                                      '\[')[1],
                                    '/')[last()]"/>
            <!-- TODO: Handle context -->
            <xsl:variable name="nodeDesc"
                          select="$l[@name = $nodeName][1]"/>

            <xsl:value-of select="gndoc:writeln(concat($t/section, ' ', $nodeDesc/label), '^')"/>
            <xsl:for-each select="$nodeDesc/description">
              <xsl:value-of select="gndoc:writeln(normalize-space(.))"/>
            </xsl:for-each>
            <xsl:value-of select="gndoc:nl(2)"/>
            <xsl:value-of select="$t/cf"/><xsl:value-of select="gndoc:refTo(concat($schemaId, '-elem-', $nodeName))"/>
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
                            select="$s/*[name() = concat($name,'-help')]"/>
              <!-- name is optional -->
              <xsl:choose>
                <xsl:when test="contains($name,':')">
                  <!-- Section name is a standard element eg. mdb:MD_Metadata. Use labels.xml. -->
                  <xsl:variable name="nodeDesc"
                                select="$l[@name = $name]"/>
                  <xsl:value-of select="gndoc:writeln($nodeDesc/label, '&quot;')"/>

                  <!--<xsl:choose>
                    <xsl:when test="$nodeDesc/label = ''">
                      <xsl:message> Missing label for field <xsl:value-of select="$name"/>. </xsl:message>
                    </xsl:when>
                    <xsl:otherwise>
                    </xsl:otherwise>
                  </xsl:choose>-->

                  <xsl:for-each select="$nodeDesc/(description|help)">
                    <xsl:value-of select="gndoc:writeln(normalize-space(.))"/>
                    <xsl:value-of select="gndoc:nl(2)"/>
                  </xsl:for-each>

                  <xsl:value-of select="$t/cf"/><xsl:value-of select="gndoc:refTo(concat($schemaId, '-elem-', $name))"/>
                </xsl:when>
                <xsl:when test="$name != ''">
                  <xsl:value-of select="gndoc:writeln($s[name() = $name], '&quot;')"/>
                </xsl:when>
              </xsl:choose>

              <!-- help is optional -->
              <xsl:if test="$help != ''">
                <xsl:value-of select="gndoc:writeln($help)"/>
              </xsl:if>
              <xsl:value-of select="gndoc:nl()"/>
            </xsl:if>

            <xsl:if test="@xpath">
              <!-- TODO same as section / use apply-templates -->
              <!-- Extract node name from XPath,
                  ie. last element name before the filter expression -->
              <xsl:variable name="nodeName"
                            select="tokenize(
                                      tokenize(
                                        normalize-space(@xpath),
                                      '\[')[1],
                                    '/')[last()]"/>
              <!-- TODO: Handle element with context = parent element or full xpath -->
              <xsl:variable name="nodeDesc"
                            select="$l[@name = $nodeName][position() = 1]"/>

              <!-- TODO Add inspire or other flag -->
              <xsl:value-of select="gndoc:writeln($nodeDesc/label, '&quot;')"/>
              <xsl:value-of select="gndoc:nl()"/>
              <xsl:for-each select="$nodeDesc/(description|help)">
                <xsl:value-of select="gndoc:writeln(concat('* ', $t/desc, ' ', normalize-space(.)))"/>
              </xsl:for-each>
              <xsl:value-of select="gndoc:nl()"/>

              <xsl:apply-templates select="$nodeDesc/helper" mode="doc"/>

              <xsl:value-of select="gndoc:writeln(concat('* ', $t/xpath, ' ``', @xpath, '``'))"/>
              <xsl:value-of select="gndoc:nl(2)"/>

              <xsl:value-of select="$t/cf"/><xsl:value-of select="gndoc:refTo(concat($schemaId, '-elem-', $nodeName))"/>
            </xsl:if>
          </xsl:for-each>
            <!-- TODO Handle template field -->
            <!-- TODO CODELISTS - generate full mtd to find links between labels definition and codelists-->

        </xsl:for-each>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="write-schema-details">
    <xsl:variable name="rows">
      <!-- TODO i18n-->
      <row>
        <name>Schema identifier</name>
        <value><xsl:value-of select="$sc/gns:name"/></value>
      </row>
      <row>
        <name>Version</name>
        <value><xsl:value-of select="$sc/gns:version"/></value>
      </row>
      <row>
        <name>Schema location</name>
        <value><xsl:value-of select="$sc/gns:schemaLocation"/></value>
      </row>
      <row>
        <name>Schema namespaces</name>
        <value>
          <!-- TODO: Some namespaces may be missing. -->
          <xsl:value-of select="string-join($sc/gns:autodetect/namespace::*, ', ')"/>
        </value>
      </row>
      <row>
        <name>Schema detection mode</name>
        <value>
          <xsl:value-of select="name($sc/gns:autodetect/*)"/>
          (<xsl:value-of select="$sc/gns:autodetect/*/@type"/>)
        </value>
      </row>
      <row>
        <name>Schema detection elements</name>
        <value>
          <xsl:value-of select="string-join($sc/gns:autodetect/*/*/name(), ', ')"/>
        </value>
      </row>
    </xsl:variable>

    <xsl:value-of select="gndoc:writeln($t/schema-details, '*')"/>
    <xsl:value-of select="gndoc:table($rows)"/>
    <xsl:value-of select="gndoc:nl(2)"/>
  </xsl:template>




  <xsl:template name="write-glossary">
    <xsl:value-of select="gndoc:writeln($t/glossary, '*')"/>
    <xsl:value-of select="gndoc:nl()"/>
    <xsl:value-of select="gndoc:writeln($t/glossary-help)"/>
    <xsl:value-of select="gndoc:nl(2)"/>

    <xsl:for-each select="$l">
      <xsl:sort select="@name"/>

      <xsl:variable name="name" select="@name"/>

      <xsl:value-of select="gndoc:ref(concat($schemaId, '-elem-', $name))"/>
      <xsl:value-of select="gndoc:writeln(concat(label, ' (', $name, ')'), '=')"/>
      <xsl:value-of select="gndoc:nl(2)"/>

      <!-- A table would be better -->
      <xsl:if test="@context != ''">
        <xsl:value-of select="gndoc:writeln(concat('* ', $t/context, ' ',  @context))"/>
      </xsl:if>

      <xsl:value-of select="gndoc:nl(1)"/>
      <xsl:for-each select="(description|help)[text() != '']">
        <xsl:value-of select="if (@for) then gndoc:writeln(concat('[', @for, ']')) else ''"/>
        <xsl:value-of select="gndoc:writeln(normalize-space(.))"/>
        <xsl:value-of select="gndoc:nl()"/>
      </xsl:for-each>

      <xsl:value-of select="gndoc:nl()"/>

      <xsl:for-each select="condition[normalize-space() != '']">
        <xsl:value-of select="gndoc:writeln(concat('* ', $t/cond, ' ', normalize-space(.)))"/>
        <xsl:value-of select="gndoc:nl()"/>
      </xsl:for-each>

      <xsl:apply-templates select="helper" mode="doc"/>

      <!-- Insert code list table. Another option would be to make a reference to the codelists -->
      <xsl:apply-templates select="$c[@name = $name]" mode="doc"/>

      <xsl:variable name="xmlSnippet" select="$tpl/descendant-or-self::*[name() = $name]"/>
      <xsl:if test="$xmlSnippet instance of node()">
        <xsl:value-of select="gndoc:writeCode($xmlSnippet)"/>
      </xsl:if>

      <xsl:value-of select="gndoc:nl(3)"/>
    </xsl:for-each>
  </xsl:template>




  <xsl:template name="write-codelist">
    <xsl:value-of select="gndoc:writeln($t/codelists, '*')"/>
    <xsl:value-of select="gndoc:nl()"/>
    <xsl:value-of select="gndoc:writeln($t/codelists-help)"/>
    <xsl:value-of select="gndoc:nl(2)"/>

    <xsl:if test="not($c)">
      <xsl:value-of select="$t/noCodelist"/>
    </xsl:if>

    <xsl:apply-templates select="$c" mode="doc"/>
  </xsl:template>






  <xsl:template match="helper" mode="doc">
    <xsl:value-of select="gndoc:writeln($t/helper)"/>

    <xsl:variable name="rows">
      <xsl:for-each select="option">
        <row>
          <code><xsl:value-of select="@value"/></code>
          <label><xsl:value-of select="."/></label>
        </row>
      </xsl:for-each>
    </xsl:variable>
    <xsl:value-of select="gndoc:table($rows/*)"/>

    <!--<xsl:for-each select="option">
      <xsl:if test="position() = 1">
        <xsl:value-of select="gndoc:writeln($t/helper)"/>
        &lt;!&ndash; TODO conditional helper &ndash;&gt;
        <xsl:value-of select="gndoc:nl(2)"/>
        <xsl:for-each select="@displayIf">
          <xsl:value-of select="gndoc:writeln(concat('(', $t/displayIf, '``', ., '``'))"/>
        </xsl:for-each>
      </xsl:if>
      <xsl:value-of select="gndoc:writeln(concat('* ', normalize-space(.), ' (', @value, ')'))"/>
    </xsl:for-each>-->
  </xsl:template>


  <xsl:template match="codelist" mode="doc">
    <xsl:value-of select="gndoc:nl(2)"/>

    <xsl:variable name="name" select="@name"/>
    <xsl:value-of select="gndoc:ref(concat($schemaId, '-cl-', $name))"/>
    <!-- TODO: Handle context instead of selecting first -->
    <xsl:value-of select="gndoc:writeln(concat(
                            $t/codelist, ' ', $l[@name = $name][1]/label, ' (', @name, ')'
                            ), '=')"/>
    <xsl:value-of select="gndoc:nl()"/>
    <!--
    Display using list
    <xsl:apply-templates select="entry" mode="doc"/>
    <xsl:value-of select="gndoc:nl(3)"/>

    ... or table layout
    -->
    <!--<xsl:message><xsl:copy-of select="*[not(@hideInEditMode)]"/></xsl:message>-->
    <xsl:value-of select="gndoc:table(*[not(@hideInEditMode)])"/>

    <xsl:if test="count(*[@hideInEditMode]) > 0">
      <xsl:value-of select="gndoc:nl()"/>
      <xsl:value-of select="gndoc:writeln($t/hiddenInEditMode)"/>

      <xsl:value-of select="gndoc:table(*[@hideInEditMode])"/>
    </xsl:if>
  </xsl:template>


  <xsl:template match="entry" mode="doc">
    <xsl:value-of select="gndoc:writeln(concat(
                            '* ', label, ' (', code, '): ', normalize-space(description)
                            ))"/>
  </xsl:template>
</xsl:stylesheet>