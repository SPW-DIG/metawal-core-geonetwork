<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
  exclude-result-prefixes="xs"
  version="2.0">
  
  <xsl:output doctype-public="html"/>
  
  <xsl:template match="/">
    <html>
      <head>
        <meta charset="utf-8"/>
        <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        
        <link rel="stylesheet" href="http://getbootstrap.com/dist/css/bootstrap.min.css"></link>
        <script src="http://getbootstrap.com/dist/js/bootstrap.min.js"></script>
      </head>
      <body>
        <div class="container-fluid">
          <h1>Validation report</h1>
          
          <xsl:apply-templates select="svrl:schematron-output"/>
          
        </div>
      </body>
    </html>
  </xsl:template>
  
  
  <xsl:template match="svrl:schematron-output">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="svrl:active-pattern">
    <h2><xsl:value-of select="@name"/></h2>
    <xsl:variable name="current" select="."/>
    <xsl:variable name="rules" 
      select="following-sibling::svrl:fired-rule[preceding-sibling::svrl:active-pattern[1] = $current]"/>
    <xsl:variable name="failures" 
      select="following-sibling::svrl:failed-assert[preceding-sibling::svrl:active-pattern[1] = $current]"/>
    <xsl:variable name="reports" 
      select="following-sibling::svrl:successful-report[preceding-sibling::svrl:active-pattern[1] = $current]"/>
    
    
    <table class="table table-striped">
      <tr>
        <td>Document</td>
        <td><xsl:value-of select="@document"/></td>
      </tr>
      <tr>
        <td>Number of elements checked</td>
        <td><xsl:value-of select="count($rules)"/></td>
      </tr>
    </table>
    
    <p class="info">
      <xsl:value-of select="svrl:text"/>
    </p>
    
    <ul>
      <xsl:for-each select="$failures">
        <li class="text-danger">
          <xsl:value-of select="svrl:diagnostic-reference[1]/text()"/>
          
          <ul>
            <li>Location: <xsl:value-of select="@location"/></li>
            <li>Test: <xsl:value-of select="@test"/></li>
          </ul>
        </li>
      </xsl:for-each>
      <xsl:for-each select="$reports">
        <li class="text-success">
          <xsl:value-of select="svrl:diagnostic-reference[1]/text()"/>
          
          <ul>
            <li>Location: <xsl:value-of select="@location"/></li>
            <li>Test: <xsl:value-of select="@test"/></li>
          </ul>
        </li>
      </xsl:for-each>
    </ul>
  </xsl:template>
  
  
  <xsl:template match="svrl:diagnostic-reference|svrl:failed-assert|svrl:fired-rule"/>
  
</xsl:stylesheet>