<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="#all">
	
	<xsl:output omit-xml-declaration="no" method="html"
		 indent="yes" encoding="UTF-8" />
	
	<xsl:include href="metawal-banner.xsl"/>
	<xsl:include href="metawal-footer.xsl"/>
    <xsl:template match="/">
		<html xmlns="http://www.w3.org/1999/xhtml">
		  <head>
		    <title>GeoNetwork</title>
		
		    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"></meta>
		  	<meta http-equiv="X-UA-Compatible" content="IE=9" />

        <link rel="shortcut icon" type="image/x-icon" href="../../../favicon.ico"/>
        <link href="../../srv/en/rss.latest?georss=gml" rel="alternate" type="application/rss+xml"
		      title="GeoNetwork opensource GeoRSS | Recent Changes"></link>
		    <link href="../../srv/en/portal.opensearch" rel="search"
		      type="application/opensearchdescription+xml" title="GeoNetwork"></link>
		
		    
		    <link rel="stylesheet" type="text/css" href="../../apps/js/ext/resources/css/ext-all.css"/>
		    <link rel="stylesheet" type="text/css" href="../../apps/js/ext/resources/css/xtheme-gray.css"/>
		    <link rel="stylesheet" type="text/css" href="../../apps/js/ext-ux/Rating/rating.css"/>
		    <link rel="stylesheet" type="text/css" href="../../apps/js/ext-ux/SuperBoxSelect/superboxselect.css" />
		    <link rel="stylesheet" type="text/css" href="../../apps/js/ext-ux/LightBox/lightbox.css"/>
		    <link rel="stylesheet" type="text/css" href="../../apps/js/ext-ux/FileUploadField/file-upload.css"/>
		    <link rel="stylesheet" type="text/css" href="../../apps/js/ext-ux/MultiselectItemSelector-3.0/Multiselect.css"/>
		    <link rel="stylesheet" type="text/css" href="../../apps/js/OpenLayers/theme/default/style.css"/>
		    <link rel="stylesheet" type="text/css" href="../../apps/css/gndefault.css"/>
		    <link rel="stylesheet" type="text/css" href="../../apps/css/gnmapdefault.css"/>
		    <link rel="stylesheet" type="text/css" href="../../apps/css/gnmetadatadefault.css"/>
		    <link rel="stylesheet" type="text/css" href="../../apps/css/metadata-view.css"/>
		    <link rel="stylesheet" type="text/css" href="../../apps/metawal/css/metawal.css"/>
		  </head>
		  <body>
		    <div id="loading-mask"></div>
		    <div id="loading">
		      <div class="loading-indicator">Loading ...</div>
		    </div>
		    
	        <xsl:call-template name="metawal-banner">
	        	<xsl:with-param name="withLogin" select="true()"/>
	      	</xsl:call-template>
	      	
	      	<xsl:call-template name="metawal-footer">
	      	</xsl:call-template>
    
		    
		    <div id="infoContent">
		     
		    </div>
		    <div id="tag">
		      
		    </div>
		    <div id="shortcut" style="display:none;">
		     
		    </div>
		    
		    <xsl:choose>
		    	<xsl:when test="/root/request/debug">
		    		<script type="text/javascript" src="../../apps/js/ext/adapter/ext/ext-base.js"></script>
				    <script type="text/javascript" src="../../apps/js/ext/ext-all-debug.js"></script>
				    <script type="text/javascript" src="../../apps/js/ext-ux/Rating/RatingItem.js"></script>
				    <script type="text/javascript" src="../../apps/js/ext-ux/FileUploadField/FileUploadField.js"></script>
				    <script type="text/javascript" src="../../apps/js/ext-ux/TwinTriggerComboBox/TwinTriggerComboBox.js"></script>
				    <script type="text/javascript" src="../../apps/js/ext-ux/DateTime/DateTime.js"></script>
				    <script type="text/javascript" src="../../apps/js/ext-ux/RowExpander/RowExpander.js"></script>
				    <script type="text/javascript" src="../../apps/js/ext-ux/MultiselectItemSelector-3.0/DDView.js"></script>
				    <script type="text/javascript" src="../../apps/js/ext-ux/MultiselectItemSelector-3.0/Multiselect.js"></script>
				    <script type="text/javascript" src="../../apps/js/ext-ux/SuperBoxSelect/SuperBoxSelect.js"></script>
				    <script type="text/javascript" src="../../apps/js/ext-ux/LightBox/lightbox.js"></script>
				    
				    
				    <script type="text/javascript" src="../../apps/js/proj4js-compressed.js"></script>
				    <script type="text/javascript" src="../../apps/js/OpenLayers/lib/OpenLayers.js"></script>
				    <script type="text/javascript" src="../../apps/js/GeoExt/lib/overrides/override-ext-ajax.js"></script>
				    <script type="text/javascript" src="../../apps/js/GeoExt/lib/GeoExt.js"></script>
				    <script type="text/javascript" src="../../apps/js/GeoExt-ux/LayerOpacitySliderPlugin/LayerOpacitySliderPlugin.js"></script>
				    
				    <script type="text/javascript" src="../../apps/js/GeoNetwork/lib/GeoNetwork.js"></script>
				    
				    <script type="text/javascript" src="../../apps/metawal/js/Settings.js"></script>
				    <script type="text/javascript" src="../../apps/metawal/js/Shortcuts.js"></script>
				    <script type="text/javascript" src="../../apps/metawal/js/map/Settings.js"></script>
				    <script type="text/javascript" src="../../apps/metawal/js/map/MapApp.js"></script>
				    <script type="text/javascript" src="../../apps/metawal/js/App.js"></script>
				    
				    
		        </xsl:when>
		        <xsl:otherwise>
		        	
				    <script type="text/javascript" src="../../apps/js/ext/adapter/ext/ext-base.js"></script>
				    <script type="text/javascript" src="../../apps/js/ext/ext-all.js"></script>
				    <script type="text/javascript" src="../../apps/metawal/js/App-mini.js"></script>				   
		       	</xsl:otherwise>
		    </xsl:choose>
		  </body>
		</html>

   	</xsl:template>
</xsl:stylesheet>