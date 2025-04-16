-- UPDATE x-las mediatype
SELECT count(id) FROM metadata WHERE data LIKE '%http://inspire.ec.europa.eu/media-types/application/x-las%';
UPDATE metadata SET data = replace(data,'http://inspire.ec.europa.eu/media-types/application/x-las','https://www.iana.org/assignments/media-types/application/vnd.las') WHERE data LIKE '%http://inspire.ec.europa.eu/media-types/application/x-las%';
SELECT count(id) FROM metadata WHERE data LIKE '%http://inspire.ec.europa.eu/media-types/application/x-las%';

-- UPDATE x-shapefile mediatype
SELECT count(id) FROM metadata WHERE data LIKE '%http://inspire.ec.europa.eu/media-types/application/x-shapefile%';
UPDATE metadata SET data = replace(data,'http://inspire.ec.europa.eu/media-types/application/x-shapefile','https://www.iana.org/assignments/media-types/application/vnd.shp') WHERE data LIKE '%http://inspire.ec.europa.eu/media-types/application/x-shapefile%';
SELECT count(id) FROM metadata WHERE data LIKE '%http://inspire.ec.europa.eu/media-types/application/x-shapefile%';
