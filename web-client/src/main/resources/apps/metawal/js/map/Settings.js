//OpenLayers.DOTS_PER_INCH = 90.71;
//OpenLayers.ImgPath = '../js/OpenLayers/theme/default/img/';
OpenLayers.ImgPath = '../js/OpenLayers/img/';

OpenLayers.IMAGE_RELOAD_ATTEMPTS = 3;

OpenLayers.DOTS_PER_INCH = 25.4 / 0.28;
OpenLayers.Util.onImageLoadErrorColor = "transparent";
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
Proj4js.defs["EPSG:3812"] = "+proj=lcc +lat_1=49.83333333333334 +lat_2=51.16666666666666 +lat_0=50.797815 +lon_0=4.359215833333333 +x_0=649328 +y_0=665262 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs";

//new OpenLayers.Projection("EPSG:900913")


GeoNetwork.map.printCapabilities = "../../pdf";

// Config for WGS84 based maps
GeoNetwork.map.PROJECTION = "EPSG:31370";
GeoNetwork.map.EXTENT = new OpenLayers.Bounds(42000, 20000, 296000, 168000);
GeoNetwork.map.MAXEXTENT = new OpenLayers.Bounds(42000, 20000, 296000, 168000);
// new OpenLayers.Bounds(1, 45, 9, 57);
//GeoNetwork.map.EXTENT = new OpenLayers.Bounds(-180, -90, 180, 90);
//GeoNetwork.map.EXTENT = new OpenLayers.Bounds(-5.1,41,9.7,51);

//GeoNetwork.map.PROJECTION = "EPSG:31370";
//GeoNetwork.map.EXTENT = new OpenLayers.Bounds('17736.0314', '23697.0977', '297289.9391', '245375.4223');

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

GeoNetwork.map.BACKGROUND_LAYERS = [
//    new OpenLayers.Layer.WMS("Background layer", "/geoserver/wms", {layers: 'gn:world,gn:ne_50m_boundary_da,gn:ne_50m_boundary_lines_land,gn:ne_50m_coastline', format: 'image/jpeg'}, {isBaseLayer: true})
new OpenLayers.Layer.ArcGIS93Rest(
		"Fond de plan",
		"http://geoservices.valid.wallonie.be/arcgis/rest/services/DONNEES_BASE/FOND_PLAN_CARTE_2012_v1_RW/MapServer/export",
		{layers: '0'},
		{'attribution': 'SPW'}
    )
//    	new OpenLayers.Layer.WMS("Background layer", "http://www2.demis.nl/mapserver/wms.asp?", {layers: 'Countries', format: 'image/jpeg'}, {isBaseLayer: true})
];
//GeoNetwork.map.RESOLUTIONS = [];

// Define background map layer from an OGC Context. 
// If a context is defined then GeoNetwork.map.BACKGROUND_LAYERS is ignored.
//* DEMIS country layer
//GeoNetwork.map.OWS = "../../maps/demis.xml";
//* Default GeoServer layers
//GeoNetwork.map.OWS = "../../maps/geoserver_localhost.xml";
//GeoNetwork.map.CONTEXT = "../../maps/metawal.wmc";

GeoNetwork.map.CONTEXT_MAP_OPTIONS = {
 controls: [],
 maxResolution: 'auto',
 projection: GeoNetwork.map.PROJECTION,
 displayProjection: GeoNetwork.map.PROJECTION,
 units: 'm',
 maxExtent: GeoNetwork.map.EXTENT,
 restrictedExtent: GeoNetwork.map.EXTENT,
 theme:null
};

GeoNetwork.map.CONTEXT_MAIN_MAP_OPTIONS = {
 controls: [],
 maxResolution: 'auto',
 projection: GeoNetwork.map.PROJECTION,
 displayProjection: GeoNetwork.map.PROJECTION,
 units: 'm',
 maxExtent: GeoNetwork.map.EXTENT,
 restrictedExtent: GeoNetwork.map.EXTENT,
 theme:null
};

GeoNetwork.map.MAP_OPTIONS = {
 projection: GeoNetwork.map.PROJECTION,
 maxExtent: GeoNetwork.map.EXTENT,
 maxResolution: 'auto',
 projection: GeoNetwork.map.PROJECTION,
 displayProjection: GeoNetwork.map.PROJECTION,
 units: 'm',
 restrictedExtent: GeoNetwork.map.EXTENT,
 resolutions: GeoNetwork.map.RESOLUTIONS,
 controls: [],
 theme:null
};

GeoNetwork.map.MAIN_MAP_OPTIONS = {
 projection: GeoNetwork.map.PROJECTION,
 maxExtent: GeoNetwork.map.EXTENT,
 maxResolution: 'auto',
 projection: GeoNetwork.map.PROJECTION,
 displayProjection: GeoNetwork.map.PROJECTION,
 units: 'm',
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
                        '<tpl if="thumbnail==\'\'">',
                            '<img src="../../loc/fre/images/nopreview.gif" alt="Thumbnail"/>',
                        '</tpl>', 
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


GeoNetwork.Templates.FULL = new Ext.XTemplate(
        '<ul>',
          '<tpl for=".">',
            '<li class="md md-full" style="{featurecolorCSS}">',
                '<table><tr>',
                '<td class="left">',
                    GeoNetwork.Templates.LOGO,
                '</td>',
                '<td id="{uuid}">',
                    GeoNetwork.Templates.TITLE,
                    '<p class="abstract">{[Ext.util.Format.ellipsis(Ext.util.Format.stripTags(values.abstract), 350, true)]}</p>',    // FIXME : 250 as parameters
                    '<tpl if="subject">',
                        '<p class="subject"><tpl for="subject">',
                            '{value}{[xindex==xcount?"":", "]}',
                        '</tpl></p>',
                    '</tpl>',
                    // Custom links
                    '<tpl for="links">',
                      '<tpl if="values.href.indexOf(\'' + Metawal.config.walOnMap.check + '\') == 0">',
                        '<div style="float:left;line-height: 22px;"><a href="#" class="md-mn addLayer" title="{title}" alt="{title}" onclick="window.open(\'' + Metawal.config.walOnMap.url + 'agsDynUrls={href}&metadataUrl=' + location.origin + location.pathname + '?uuid={parent.uuid}\', \'walOnMap\');">&nbsp;</a></div>',
                      '</tpl>',
                    '</tpl>',
                    
                    '<div class="md-links" id="md-links-{id}">',
                    '</div>',
                '</td><td class="thumb">',
                        GeoNetwork.Templates.RATING_TPL,
                        '<div class="thumbnail">',
                            '<tpl if="thumbnail">',
                                '<a rel="lightbox" href="{overview}"><img src="{thumbnail}" alt="Thumbnail"/></a>', 
                            '</tpl>',
                            '<tpl if="thumbnail==\'\'">',
                              '<img src="../../loc/fre/images/nopreview.gif" alt="Thumbnail"/>',
                            '</tpl>', 
                        '</div>',
//                '</td>',
//                // Validity and category information
//                '<tpl if="catalogue.isIdentified()">',
//                  '<td>',
//                    '<tpl if="catalogue.isIdentified() && valid != \'-1\'">',
//                        '<span class="badge badge-',
//                            '<tpl if="valid == \'1\'">success</tpl>',
//                            '<tpl if="valid == \'0\'">error</tpl>',
//                            '" title="' + OpenLayers.i18n('validityInfo'),
//                            '<tpl for="valid_details">',
//                              '{values.type}: ',
//                                '<tpl if="values.valid == \'1\'">' + OpenLayers.i18n('valid')  + '</tpl>',
//                                '<tpl if="values.valid == \'0\'">' + OpenLayers.i18n('notValid')  + '</tpl>',
//                                '<tpl if="values.valid == \'-1\'">' + OpenLayers.i18n('notDetermined')  + '</tpl>',
//                                '<tpl if="values.ratio != \'\'"> ({values.ratio}) </tpl> - ',
//                            '</tpl>',
//                        '">&nbsp;</span>',
//                    '</tpl>',
//                  '</td>',
//                '</tpl>',
//                '</td><td class="icon" title="' + OpenLayers.i18n('metadataCategories') + '">',
//                '<tpl for="category">',
//                  '<div class="md-mn cat-{value}" title="{value}">&nbsp;</div>',
//                '</tpl>',
                '</td></tr></table>',
                '<div class="relation" title="' + OpenLayers.i18n('relateddatasets') + '"><span></span><ul id="md-relation-{id}"></ul></div>',
                '<div class="md-contact">',
                  '<tpl for="contact">',
                      // metadata contact are not displayed.
                      '<tpl if="applies==\'resource\'">',
                          '<span title="{role} - {applies}"><tpl if="values.logo !== undefined && values.logo !== \'\'">',
                              '<img src="{logo}" class="orgLogo"/>',
                          '</tpl>',
                          '{name}&nbsp;&nbsp;</span>',
                      '</tpl>',
                  '</tpl>',
                  '<tpl if="edit==\'true\' && isharvested!=\'y\'">',
                      '<br/><span class="md-mn md-mn-user" title="' + OpenLayers.i18n('ownerName') + '">{ownername} - ' + OpenLayers.i18n('lastUpdate') + '{[values.changedate.split(\'T\')[0]]}</span>',
                  '</tpl>',
                '</div>',
//                '<tpl if="edit==\'true\' && idxMsg">',
//                    '<div class="label label-warning">{idxMsg}</div>',
//                '</tpl>',
            '</li>',
        '</tpl>',
    '</ul>',
    {
        hasDownloadLinks: function(values) {
            var i;
            for (i = 0; i < values.length; i ++) {
                if (values[i].type === 'application/x-compressed') {
                    return true;
                }
            }
            return false;
        }
    }
);
