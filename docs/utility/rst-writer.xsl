<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:gndoc="http://geonetwork-opensource.org/doc"
                xmlns:saxon="http://saxon.sf.net/"
                xmlns:java="http://www.java.com/"
                extension-element-prefixes="saxon"
                exclude-result-prefixes="#all"
                version="2.0">

  <xsl:output method="text" encoding="UTF-8"/>
  <xsl:strip-space elements="*"/>

  <xsl:output name="default-serialize-mode"
              indent="yes"
              omit-xml-declaration="yes"
              encoding="utf-8"
              escape-uri-attributes="yes"/>

  <xsl:function name="java:file-exists"
                xmlns:file="java.io.File"
                as="xs:boolean">
    <xsl:param name="file" as="xs:string"/>
    <xsl:param name="base-uri" as="xs:string"/>

    <xsl:variable name="absolute-uri"
                  select="resolve-uri($file, $base-uri)"
                  as="xs:anyURI"/>
    <xsl:sequence select="file:exists(file:new($absolute-uri))"/>
  </xsl:function>


  <!-- Write a line -->
  <xsl:function name="gndoc:writeln">
    <xsl:param name="line" as="xs:string?"/>
    <xsl:text>&#xA;</xsl:text><xsl:value-of select="normalize-space($line)"/>
  </xsl:function>

  <xsl:function name="gndoc:writelnhtml">
    <xsl:param name="line"/>
    <xsl:text>&#xA;.. raw:: html</xsl:text>
    <xsl:text>&#xA;</xsl:text>
    <xsl:text>&#xA;</xsl:text>
    <!--<xsl:text>&#xA;  &lt;embed&gt;</xsl:text>-->
    <xsl:text>&#xA;  </xsl:text><xsl:copy-of select="$line"/>
    <!--<xsl:text>&#xA;  &lt;/embed&gt;</xsl:text>-->
    <xsl:text>&#xA;</xsl:text>
  </xsl:function>


  <xsl:function name="gndoc:writelnfield">
    <xsl:param name="line" as="xs:string?"/>
    <xsl:text>&#xA;</xsl:text>
    <xsl:text>&#xA;:</xsl:text><xsl:value-of select="normalize-space($line)"/>:
  </xsl:function>
  <xsl:function name="gndoc:writelnfield">
    <xsl:param name="field" as="xs:string?"/>
    <xsl:param name="value" as="xs:string?"/>
    <xsl:text>&#xA;</xsl:text>
    <xsl:text>&#xA;:</xsl:text><xsl:value-of select="normalize-space($field)"/>:
    <xsl:text>&#xA;    </xsl:text><xsl:value-of select="normalize-space($value)"/>
  </xsl:function>

  <!-- Write line and underline it -->
  <xsl:function name="gndoc:writeln">
    <xsl:param name="line" as="xs:string?"/>
    <xsl:param name="underline" as="xs:string?"/>
    <xsl:text>&#xA;</xsl:text><xsl:value-of select="normalize-space($line)"/>
    <xsl:text>&#xA;</xsl:text><xsl:value-of select="replace(normalize-space($line), '.', $underline)"/>
    <xsl:text>&#xA;</xsl:text>
  </xsl:function>

  <!-- Create a RST reference. Prefixed by schema identifier to have them unique
   accross all documentation refs. -->
  <xsl:function name="gndoc:ref">
    <xsl:param name="id" as="xs:string?"/>
    <xsl:text>&#xA;.. _</xsl:text><xsl:value-of select="replace($id, ':', '-')"/>:
    <xsl:text>&#xA;</xsl:text>
  </xsl:function>

  <xsl:function name="gndoc:refTo">
    <xsl:param name="id" as="xs:string?"/>
    <xsl:text>:ref:`</xsl:text><xsl:value-of select="replace($id, ':', '-')"/>`
  </xsl:function>

  <xsl:function name="gndoc:figure">
    <xsl:param name="folder" as="xs:string?"/>
    <xsl:param name="image" as="xs:string?"/>

    <xsl:choose>
      <xsl:when
              xmlns:file="java.io.File"
              test="file:exists(file:new(concat($folder, '/', $image)))">
        <xsl:text>&#xA;.. figure:: </xsl:text><xsl:value-of select="$image"/><xsl:text>&#xA;</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message>  * Figure: <xsl:value-of select="concat($folder, '/', $image, ' does not exist.')"/></xsl:message>
      </xsl:otherwise>
    </xsl:choose>
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
    <xsl:param name="rows" as="node()*"/>
    <!-- Hide in edit mode-->

    <xsl:variable name="s" select="'  '"/>
    <xsl:value-of select="gndoc:nl(2)"/>

    <!-- Rows -->
    <xsl:for-each select="$rows">
      <!-- TODO: Should we sort ? -->
      <!-- Header -->
      <xsl:if test="position() = 1">
        <!-- Cols -->
        <xsl:for-each select="*">
          <xsl:variable name="colName" select="name()"/>
          <xsl:for-each select="1 to gndoc:mll($rows/*[name() = $colName])">=</xsl:for-each>
          <xsl:if test="position() != last()">
            <xsl:value-of select="$s"/>
          </xsl:if>
        </xsl:for-each>
        <xsl:text>&#xA;</xsl:text>
        <!-- Cols label -->
        <xsl:for-each select="*">
          <xsl:variable name="colName" select="name()"/>
          <xsl:variable name="maxColLength"
                        select="gndoc:mll($rows/*[name() = $colName])"/>
          <xsl:variable name="missingSpaces"
                        select="$maxColLength - string-length($colName)"/>

          <xsl:value-of select="$colName"/>
          <xsl:if test="position() != last()">
            <xsl:value-of select="$s"/>
          </xsl:if>
          <xsl:for-each select="1 to $missingSpaces"><xsl:text> </xsl:text></xsl:for-each>
        </xsl:for-each>
        <xsl:text>&#xA;</xsl:text>
        <xsl:for-each select="*">
          <xsl:variable name="colName" select="name()"/>
          <xsl:for-each select="1 to gndoc:mll($rows/*[name() = $colName])">=</xsl:for-each>
          <xsl:if test="position() != last()">
            <xsl:value-of select="$s"/>
          </xsl:if>
        </xsl:for-each>
        <xsl:value-of select="gndoc:nl()"/>
      </xsl:if>


      <xsl:for-each select="*">
        <xsl:variable name="colName" select="name()"/>
        <xsl:variable name="colValue" select="normalize-space()"/>
        <xsl:variable name="maxColLength"
                      select="gndoc:mll($rows/*[name() = $colName])"/>
        <xsl:variable name="missingSpaces"
                      select="$maxColLength - string-length($colValue)"/>
        <xsl:value-of select="$colValue"/>
        <xsl:if test="position() != last()">
          <xsl:value-of select="$s"/>
        </xsl:if>
        <xsl:for-each select="1 to $missingSpaces"><xsl:text> </xsl:text></xsl:for-each>
      </xsl:for-each>
      <xsl:value-of select="gndoc:nl()"/>

      <!-- Footer -->
      <xsl:if test="position() = last()">
        <xsl:for-each select="*">
          <xsl:variable name="colName" select="name()"/>
          <xsl:for-each select="1 to gndoc:mll($rows/*[name() = $colName])">=</xsl:for-each>
          <xsl:if test="position() != last()">
            <xsl:value-of select="$s"/>
          </xsl:if>
        </xsl:for-each>
        <xsl:value-of select="gndoc:nl()"/>
      </xsl:if>
    </xsl:for-each>

    <xsl:value-of select="gndoc:nl(2)"/>
  </xsl:function>

  <xsl:function name="gndoc:writeCode">
    <xsl:param name="code" as="node()*"/>

    <xsl:text>&#xA;</xsl:text>.. code-block:: xml
    <xsl:value-of select="gndoc:nl(2)"/>
    <xsl:variable name="text"
                  select="saxon:serialize($code, 'default-serialize-mode')"/>
    <xsl:for-each select="tokenize($text, '\n')">
      <xsl:choose>
        <!-- Strip namespaces -->
        <xsl:when test="matches(normalize-space(.), '^xmlns:.*&quot;$')">
          <!--<xsl:if test="position() = 2"><xsl:text>    </xsl:text>...<xsl:text>&#xA;</xsl:text></xsl:if>-->
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>    </xsl:text><xsl:value-of select="."/><xsl:text>&#xA;</xsl:text>
        </xsl:otherwise>
      </xsl:choose>

    </xsl:for-each>
    <xsl:value-of select="gndoc:nl(2)"/>
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
</xsl:stylesheet>