<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="#all">
             
  <xsl:template name="metawal-banner">
  	
    <xsl:param name="withLogin" select="false()"/>
          
        <!--start SPW banner-->  
        <div id="top-spw-global">
            <div class="container_16">
                <div class="top-spw-global">
                    <!--start grid_16-->
                    <div class="grid_16">
                        <a class="portail-walloniebe" href="http://www.wallonie.be">Portail WALLONIE.BE</a>
                        <a class="federation-wallonie-bruxelles" target="_blank" href="http://www.federation-wallonie-bruxelles.be/">Fédération Wallonie-Bruxelles</a>
                        <a class="geoportail-de-la-wallonie" target="_blank" href="http://geoportail.wallonie.be/cms/fr/sites/geoportail/home.html">Géoportail de la Wallonie</a>
                        <div class="clear"></div>
                        <div class="clear"></div>
                        <div class="clear"></div>
                    </div>
                    <!--stop grid_16-->
                    <div class="clear"></div>
                </div>
            </div>
        </div>
        <div id="header_spw">
            <div class="container_16">
                <div class="header_spw">
                    <!--start grid_10-->
                    <div class="grid_10">
                        <!--<div id="header_spw-col1" class="header_spw-col1noprint" style="padding-top:0px">-->
                        <div id="header_spw-col1" class="header_spw-col1noprint">
                            
                                <a class="geoLink"  href="../../"><xsl:value-of select="/root/gui/strings/metawalBannerTitlePartim1" />
                                	&#160;<xsl:value-of select="/root/gui/strings/metawalBannerTitlePartim2" /></a>
                            
                            <div class="clear"></div>
                          </div>
						<div class="clear"></div>
				</div>
				
				<!-- -->
				<div class="grid_6">
					<div class="lang">
						<div  id="lang-form"></div>
					</div>
					<div class="clear"></div>
					<div class="grid_login">
						<ul id="menulogin">
                        	<li>
                        		<a href="#"><p id="userinfo"></p></a>
	                        	<ul class="sub-menu">
	                        		<li><input type="button" id="logout_popup" class="btnlogout" value="{/root/gui/strings/metawalBannerLogout}"/></li>
	                        	</ul>
                        	</li>
                        </ul>
						<!--<p id="userinfo"></p>-->
						<input type="button" id="login_popup" class="btn" 
							value="{/root/gui/strings/metawalBannerLogin}"/>
	        		</div>
	        		<a href="#x" class="overlay" id="login_form"></a>
			        <div class="popup" id="login_form_div">
			            <h2><xsl:value-of select="/root/gui/strings/metawalLoginTitle" /></h2>
			            <p><xsl:value-of select="/root/gui/strings/metawalLoginIntro" /></p>
			            <div>
			                <label for="login"><xsl:value-of select="/root/gui/strings/metawalLoginLogin" /></label>
			                <input type="text" id="login" value=""/>
		            	</div>
			        	<div>
			                <label for="password"><xsl:value-of select="/root/gui/strings/metawalLoginPwd" /></label>
			                <input type="password" id="password" name="password" value="" onkeypress="enterFunction()"/>
			            </div>
			            <input type="submit" id="submitbutton" name="submitbutton" class="btn" value="{/root/gui/strings/metawalLoginConnection}"  onclick="catalogue.login(document.getElementById('login').value,document.getElementById('password').value);location.href='#close';"/>
			        	&#160;
			        	<input type="button" class="btn" value="{/root/gui/strings/metawalLoginCancel}" onclick="location.href='#close';"/>
			        </div>
			        <div class="clear"></div>
            		<div class="noprint">
                            <xsl:if test="$withLogin">
		    					<div class="topQuickHeaderbottom">
		    						<div  id="login-form"></div>
		    					</div>
                            </xsl:if>
                    </div>
                    </div>
                    <div class="grid_menu" id="grid_menu">
                        <ul id="menu">
                        	<li id="gn-menu-search">
                        		<a href="#"><xsl:value-of select="/root/gui/strings/metawalMenuSearch"/></a>
	                        	<ul>
	                        		<li><a href="search"><xsl:value-of select="/root/gui/strings/metawalMenuSearch"/></a></li>
	                        		<li><a href="search?s_E__owner={/root/gui/session/userId}&amp;s_search"><xsl:value-of select="/root/gui/strings/metawalMenuMyMetadata"/></a></li>
	                        	</ul>
                        	</li>
                        	<li id="gn-menu-encoding">
                        		<a href="#"><xsl:value-of select="/root/gui/strings/metawalMenuEncoding"/></a>  
	                        	<ul>
	                        		<li><a>
	                        			<xsl:choose>
	                        				<xsl:when test="/root/gui/reqService='search'">
	                        					<xsl:attribute name="onclick">
	                        						<xsl:text>newmetadata();</xsl:text>
	                        					</xsl:attribute>
	                        				</xsl:when>
	                        				<xsl:otherwise>
	                        					<xsl:attribute name="href">
	                        						<xsl:text>search?#create</xsl:text>
	                        					</xsl:attribute>
	                        				</xsl:otherwise>
	                        			</xsl:choose>
	                        			<xsl:value-of select="/root/gui/strings/metawalMenuNewMetadata"/></a></li>
	                        		<li><a>
	                        			<xsl:choose>
	                        			<xsl:when test="/root/gui/reqService='search'">
	                        				<xsl:attribute name="onclick">
	                        					<xsl:text>importmetadata();</xsl:text>
	                        				</xsl:attribute>
	                        			</xsl:when>
	                        			<xsl:otherwise>
	                        				<xsl:attribute name="href">
	                        					<xsl:text>search?#insert</xsl:text>
	                        				</xsl:attribute>
	                        			</xsl:otherwise>
	                        			</xsl:choose>
	                        			<xsl:value-of select="/root/gui/strings/metawalMenuImportMetadata"/></a></li>
	                        		<li><a href="admin.console#/harvest"><xsl:value-of select="/root/gui/strings/metawalMenuHarvesting"/></a></li>
	                        	</ul>
                        	</li>
                        	<li id="gn-menu-administration">
                        		<li><a href="admin.console"> <xsl:value-of select="/root/gui/strings/metawalMenuAdmin"/></a></li>
                        	</li>
                        	<li id="gn-menu-csw">
                        		<a href="admin.console#/settings/csw-test"><xsl:value-of select="/root/gui/strings/metawalMenuCSW"/></a>
                        	</li>
                        </ul>
					</div>
                </div>
            </div>
        </div>
        
	<script type="text/javascript" src="../../apps/metawal/js/metawal.js"></script>
		    
		    
    </xsl:template>
    
</xsl:stylesheet>
