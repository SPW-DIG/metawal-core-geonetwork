-- DELETE Sourcesdes WHERE iddes = 'metawal.wallonie.be';
-- INSERT INTO Sourcesdes (iddes, label, langid) VALUES ('metawal.wallonie.be', 'Metawal - Catalogue pour l''information géographique de Wallonie', 'fre');
-- INSERT INTO Sourcesdes (iddes, label, langid) VALUES ('metawal.wallonie.be', 'Metawal - Catalogue pour l''information géographique de Wallonie', 'eng');
-- INSERT INTO Sourcesdes (iddes, label, langid) VALUES ('metawal.wallonie.be', 'Metawal - Catalogue pour l''information géographique de Wallonie', 'dut');
-- INSERT INTO Sourcesdes (iddes, label, langid) VALUES ('metawal.wallonie.be', 'Metawal - Catalogue pour l''information géographique de Wallonie', 'ger');
-- UPDATE Sources SET name = 'Metawal - Catalogue pour l''information géographique de Wallonie' WHERE uuid = 'metawal.wallonie.be';

UPDATE metadata SET data = replace(data, '<mri:associatedResource/>', '') WHERE data LIKE '%<mri:associatedResource/>%';

--- curl 'http://157.164.189.202:8080/geonetwork/inspire/eng/csw' -H 'Content-type: application/xml' --data-binary $'<csw:GetRecordById xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"\n                   service="CSW" version="2.0.2"\n                   outputSchema="http://www.isotc211.org/2005/gmd">\n  <csw:ElementSetName>full</csw:ElementSetName>\n  <csw:Id>b7725746-b5ef-46db-add4-d61a6cc3b8d3</csw:Id>\n</csw:GetRecordById>' --compressed
