


UPDATE metadata
  SET data = REPLACE(
      data,
      'http://geoservices.wallonie.be/', 'https://geoservices.wallonie.be/')
  WHERE data LIKE '%http://geoservices.wallonie.be/%';

UPDATE metadata
  SET data = REPLACE(
      data,
      'http://geoportail.wallonie.be', 'https://geoportail.wallonie.be')
  WHERE data LIKE '%http://geoportail.wallonie.be%';

UPDATE metadata
  SET data = REPLACE(
      data,
      'http://geoportail.wallonie.be/ressources/id/', 'http://geodata.wallonie.be/id/')
  WHERE data LIKE '%http://geoportail.wallonie.be/ressources/id/%';
