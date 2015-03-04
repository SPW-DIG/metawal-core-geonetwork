<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:geonet="http://www.fao.org/geonetwork">

  <xsl:import href="../../convert/to19139.xsl"/>

  <xsl:param name="displayInfo"/>

  <xsl:template match="geonet:*">
    <xsl:if test="$displayInfo = 'true'">
      <xsl:copy-of select="."/>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>