OpenLayers.DOTS_PER_INCH = 90.71;
//OpenLayers.ImgPath = '../js/OpenLayers/theme/default/img/';
OpenLayers.ImgPath = '../js/OpenLayers/img/';

OpenLayers.IMAGE_RELOAD_ATTEMPTS = 3;

// Define a constant with the base url to the MapFish web service.
//mapfish.SERVER_BASE_URL = '../../../../../'; // '../../';

// Remove pink background when a tile fails to load
OpenLayers.Util.onImageLoadErrorColor = "transparent";

// Lang
OpenLayers.Lang.setCode(GeoNetwork.defaultLocale);

OpenLayers.Util.onImageLoadError = function () {
	this._attempts = (this._attempts) ? (this._attempts + 1) : 1;
	if (this._attempts <= OpenLayers.IMAGE_RELOAD_ATTEMPTS) {
		this.src = this.src;
	} else {
		this.style.backgroundColor = OpenLayers.Util.onImageLoadErrorColor;
		this.style.display = "none";
	}
};

// add Proj4js.defs here
// Proj4js.defs["EPSG:27572"] = "+proj=lcc +lat_1=46.8 +lat_0=46.8 +lon_0=0 +k_0=0.99987742 +x_0=600000 +y_0=2200000 +a=6378249.2 +b=6356515 +towgs84=-168,-60,320,0,0,0,0 +pm=paris +units=m +no_defs";
//Proj4js.defs["EPSG:2154"] = "+proj=lcc +lat_1=49 +lat_2=44 +lat_0=46.5 +lon_0=3 +x_0=700000 +y_0=6600000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs";
Proj4js.defs["EPSG:31370"] = "+proj=lcc +lat_1=51.16666723333333 +lat_2=49.8333339 +lat_0=90 +lon_0=4.367486666666666 +x_0=150000.013 +y_0=5400088.438 +ellps=intl +towgs84=106.869,-52.2978,103.724,-0.33657,0.456955,-1.84218,1 +units=m +no_defs";

//new OpenLayers.Projection("EPSG:900913")


GeoNetwork.map.printCapabilities = "../../pdf";

// Config for WGS84 based maps
GeoNetwork.map.PROJECTION = "EPSG:4326";
GeoNetwork.map.EXTENT = new OpenLayers.Bounds(3, 49.5, 6.5, 51.5);
//GeoNetwork.map.EXTENT = new OpenLayers.Bounds(-180, -90, 180, 90);
//GeoNetwork.map.EXTENT = new OpenLayers.Bounds(-5.1,41,9.7,51);

//GeoNetwork.map.BACKGROUND_LAYERS = [
//    new OpenLayers.Layer.WMS("Background layer", "/geoserver/wms", {layers: 'gn:world,gn:ne_50m_boundary_da,gn:ne_50m_boundary_lines_land,gn:ne_50m_coastline', format: 'image/jpeg'}, {isBaseLayer: true})
//    //new OpenLayers.Layer.WMS("Background layer", "http://www2.demis.nl/mapserver/wms.asp?", {layers: 'Countries', format: 'image/jpeg'}, {isBaseLayer: true})
//];

//// Config for OSM based maps
//GeoNetwork.map.PROJECTION = "EPSG:900913";
////GeoNetwork.map.EXTENT = new OpenLayers.Bounds(-550000, 5000000, 1200000, 7000000);
//GeoNetwork.map.EXTENT = new OpenLayers.Bounds(-20037508, -20037508, 20037508, 20037508.34);
//GeoNetwork.map.BACKGROUND_LAYERS = [
//    new OpenLayers.Layer.OSM()
//    //new OpenLayers.Layer.Google("Google Streets");
//];

//GeoNetwork.map.RESOLUTIONS = [];

// Define background map layer from an OGC Context. 
// If a context is defined then GeoNetwork.map.BACKGROUND_LAYERS is ignored.
//* DEMIS country layer
//GeoNetwork.map.OWS = "../../maps/demis.xml";
//* Default GeoServer layers
//GeoNetwork.map.OWS = "../../maps/geoserver_localhost.xml";
GeoNetwork.map.CONTEXT = "../../maps/metawal.wmc";

GeoNetwork.map.CONTEXT_MAP_OPTIONS = {
 controls: [],
 maxExtent: GeoNetwork.map.EXTENT,
 restrictedExtent: GeoNetwork.map.EXTENT,
 theme:null
};

GeoNetwork.map.CONTEXT_MAIN_MAP_OPTIONS = {
 controls: [],
 maxExtent: GeoNetwork.map.EXTENT,
 restrictedExtent: GeoNetwork.map.EXTENT,
 theme:null
};

GeoNetwork.map.MAP_OPTIONS = {
 projection: GeoNetwork.map.PROJECTION,
 maxExtent: GeoNetwork.map.EXTENT,
 restrictedExtent: GeoNetwork.map.EXTENT,
 resolutions: GeoNetwork.map.RESOLUTIONS,
 controls: [],
 theme:null
};

GeoNetwork.map.MAIN_MAP_OPTIONS = {
 projection: GeoNetwork.map.PROJECTION,
 maxExtent: GeoNetwork.map.EXTENT,
 restrictedExtent: GeoNetwork.map.EXTENT,
 resolutions: GeoNetwork.map.RESOLUTIONS,
 controls: [],
 theme:null
};

Metawal = {
  config : {
    walOnMap: {
      url: 'http://geoportail.wallonie.be/walonmap/?',
      check: 'http://geoservices.wallonie.be/arcgis/rest'
    }
  }
};


GeoNetwork.Templates.THUMBNAIL = new Ext.XTemplate(
        '<ul>',
            '<tpl for=".">',
                '<li class="md md-thumbnail" style="{featurecolorCSS}">',
                '<div class="md-wrap" id="{uuid}" title="{abstract}">',
                    GeoNetwork.Templates.SHORT_TITLE,
                    '<div class="thumbnail">',
                        '<tpl if="thumbnail">',
                            '<a rel="lightbox" href="{overview}"><img src="{thumbnail}" alt="Thumbnail"/></a>', 
                        '</tpl>',
                        '<tpl if="thumbnail==\'\'"></tpl>',
                    '</div>',
                    '<tpl for="links">',
                    '<tpl if="values.href.indexOf(\'' + Metawal.config.walOnMap.check + '\') == 0">',
                        '<a href="#" class="md-mn addLayer" title="{title}" alt="{title}" onclick="window.open(\'' + Metawal.config.walOnMap.url + 'agsDynUrls={href}&metadataUrl=' + location.origin + location.pathname + '?uuid={parent.uuid}\', \'walOnMap\');">&nbsp;</a>',
                    '</tpl>',
//                    '<tpl if="values.type == \'application/vnd.ogc.wms_xml\'">',
//                    // FIXME : ref to app
//                        '<a href="#" class="md-mn addLayer" title="{title}" alt="{title}" onclick="app.switchMode(\'1\', true);app.getIMap().addWMSLayer([[\'{title}\', \'{href}\', \'{name}\', \'{parent.uuid}\']]);">&nbsp;</a>',
//                    '</tpl>',
                    '</tpl>',
                '</div>',
                '</li>',
            '</tpl>',
        '</ul>'
    );