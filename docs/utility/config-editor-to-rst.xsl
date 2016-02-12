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
  <xsl:param name="schema"
             select="'iso19115-3'"/>


  <xsl:variable name="i18n"
                select="document('config-editor-i18n.xml')
                          /i18n"/>
  <xsl:variable name="schemaFolder"
                select="concat('../../schemas/', $schema, '/src/main/plugin/', $schema)"/>
  <xsl:variable name="ec"
                select="document(concat($schemaFolder, '/layout/config-editor.xml'))"/>
  <!-- A metadata template to detail encoding -->
  <xsl:variable name="tpl"
                select="concat('../../schemas/', $schema, '/doc/tpl.xml')"/>
  <xsl:variable name="sc"
                select="document(concat($schemaFolder, '/schema-ident.xml'))
                          /gns:schema"/>
  <xsl:variable name="l"
                select="document(concat($schemaFolder, '/loc/', $lang, '/labels.xml'))
                          /labels/element"/>
  <xsl:variable name="s"
                select="document(concat($schemaFolder, '/loc/', $lang, '/strings.xml'))
                          /strings/*"/>
  <xsl:variable name="c"
                select="document(concat($schemaFolder, '/loc/', $lang, '/codelists.xml'))
                          /codelists/codelist"/>
  <xsl:variable name="t"
                select="$i18n/*[name() = $lang]"/>
  <xsl:variable name="schemaId"
                select="$sc/gns:name"/>


  <xsl:template match="/">
    <!-- Reference based on schema identifier -->
    <xsl:value-of select="gndoc:ref($schemaId)"/>

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
                    select="$s[name() = concat($viewName,'-help')]"/>

      <xsl:value-of select="gndoc:ref(concat('view-', $viewName))"/>

      <xsl:value-of select="gndoc:writeln(
                              concat($t/view, $s[name() = $viewName],
                                     ' (', $viewName, ')'), '=')"/>
      <xsl:if test="$viewHelp != ''">
        <xsl:value-of select="gndoc:writeln($viewHelp)"/>
      </xsl:if>

      <!-- TODO screenshot if available -->

      <xsl:for-each select="flatModeExceptions/for">
        <xsl:if test="position() = 1">
          <xsl:value-of select="gndoc:nl(2)"/>
          <xsl:value-of select="gndoc:writeln($t/flatModeExceptions)"/>
          <xsl:value-of select="gndoc:nl()"/>
        </xsl:if>
        <!-- TODO Translate element -->
        <xsl:variable name="name" select="@name"/>
        <xsl:value-of select="gndoc:writeln(concat('* ', $l[@name = $name]/label, ' (', $name, ')'))"/>
      </xsl:for-each>
      <xsl:value-of select="gndoc:nl(2)"/>


      <!-- Tab details -->
      <xsl:for-each select="tab">
        <xsl:variable name="tabName"
                      select="@id"/>
        <xsl:variable name="tabHelp"
                      select="$s/*[name() = concat($tabName,'-help')]"/>

        <xsl:value-of select="gndoc:ref(concat('tab-', $tabName))"/>

        <xsl:value-of select="gndoc:writeln(
                              concat($t/tab, $s[name() = $tabName],
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
                        select="$s/*[name() = concat($sectionName,'-help')]"/>

          <!-- Section name is optional -->
          <xsl:choose>
            <xsl:when test="contains($sectionName,':')">
              <!-- Section name is a standard element -->
              <xsl:value-of select="gndoc:writeln(
                                        concat($t/section, $l[name() = $sectionName]), '~')"/>
            </xsl:when>
            <xsl:when test="$sectionName != ''">
              <xsl:value-of select="gndoc:writeln(
                                        concat($t/section, $s[name() = $sectionName]), '~')"/>
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
                          select="$l[@name = $nodeName]"/>

            <xsl:value-of select="gndoc:writeln(concat($t/section, $nodeDesc/label), '~')"/>
            <xsl:for-each select="$nodeDesc/description">
              <xsl:value-of select="gndoc:writeln(normalize-space(.))"/>
            </xsl:for-each>
            <xsl:value-of select="gndoc:nl()"/>
            <xsl:value-of select="gndoc:writeln(concat('* ', $t/xpath, '``', @xpath, '``'))"/>
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
                  <!-- Section name is a standard element -->
                  <xsl:value-of select="gndoc:writeln(
                                        concat('**', $l[name() = $name], '**'))"/>
                  <xsl:value-of select="gndoc:nl()"/>
                </xsl:when>
                <xsl:when test="$name != ''">
                  <xsl:value-of select="gndoc:writeln(
                                        concat('* ', $t/desc, $s[name() = $name]))"/>
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
                            select="$l[@name = $nodeName][position() = 1]"/>

              <!-- TODO Add inspire or other flag -->
              <xsl:value-of select="gndoc:writeln(concat('**', $nodeDesc/label, '**'))"/>
              <xsl:value-of select="gndoc:nl()"/>
              <xsl:for-each select="$nodeDesc/description">
                <xsl:value-of select="gndoc:writeln(concat('* ', $t/desc, normalize-space(.)))"/>
              </xsl:for-each>
              <xsl:value-of select="gndoc:nl()"/>

              <xsl:apply-templates select="$nodeDesc/helper" mode="doc"/>

              <xsl:value-of select="gndoc:writeln(concat('* ', $t/xpath, '``', @xpath, '``'))"/>
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

    <xsl:for-each select="$l">
      <xsl:sort select="@name"/>

      <xsl:variable name="name" select="@name"/>

      <xsl:value-of select="gndoc:writeln(concat('**', label, ' (', $name, ')**'))"/>
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

      <!-- Insert code list table. Another option would be to make a reference to the codelists -->
      <xsl:apply-templates select="$c[@name = $name]" mode="doc"/>

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
    <xsl:for-each select="option">
      <xsl:if test="position() = 1">
        <xsl:value-of select="gndoc:writeln($t/helper)"/>
        <!-- TODO conditional helper -->
        <xsl:value-of select="gndoc:nl(2)"/>
        <xsl:for-each select="@displayIf">
          <xsl:value-of select="gndoc:writeln(concat('(', $t/displayIf, '``', ., '``'))"/>
        </xsl:for-each>
      </xsl:if>
      <xsl:value-of select="gndoc:writeln(concat('* ', normalize-space(.), ' (', @value, ')'))"/>
    </xsl:for-each>
  </xsl:template>


  <xsl:template match="codelist" mode="doc">
    <xsl:value-of select="gndoc:nl(2)"/>

    <xsl:variable name="name" select="@name"/>
    <xsl:value-of select="gndoc:writeln(concat(
                            '**', $t/codelist, $l[@name = $name]/label, ' (', @name, ')**'
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