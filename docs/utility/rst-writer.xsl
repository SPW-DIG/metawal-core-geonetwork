<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:gndoc="http://geonetwork-opensource.org/doc"
                exclude-result-prefixes="xs"
                version="2.0">

  <xsl:output method="text" encoding="UTF-8"/>
  <xsl:strip-space elements="*"/>

  <!-- Write a line -->
  <xsl:function name="gndoc:writeln">
    <xsl:param name="line" as="xs:string?"/>
    <xsl:text>&#xA;</xsl:text><xsl:value-of select="normalize-space($line)"/>
  </xsl:function>

  <!-- Write line and underline it -->
  <xsl:function name="gndoc:writeln">
    <xsl:param name="line" as="xs:string+"/>
    <xsl:param name="underline" as="xs:string?"/>
    <xsl:text>&#xA;</xsl:text><xsl:value-of select="normalize-space($line)"/>
    <xsl:text>&#xA;</xsl:text><xsl:value-of select="replace(normalize-space($line), '.', $underline)"/>
    <xsl:text>&#xA;</xsl:text>
  </xsl:function>

  <!-- Create a RST reference. Prefixed by schema identifier to have them unique
   accross all documentation refs. -->
  <xsl:function name="gndoc:ref">
    <xsl:param name="id" as="xs:string?"/>
    <xsl:text>&#xA;.. _</xsl:text><xsl:value-of select="$id"/>:
    <xsl:text>&#xA;</xsl:text>
  </xsl:function>

  <xsl:function name="gndoc:refTo">
    <xsl:param name="id" as="xs:string?"/>
    <xsl:text>:ref:`</xsl:text><xsl:value-of select="$id"/>`
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
    <!-- Hide in edit mode-->

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
</xsl:stylesheet>