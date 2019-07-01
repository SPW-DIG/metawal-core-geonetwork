


UPDATE metadata
  SET data = REPLACE(
      data,
      'http://geoservices.wallonie.be/', 'https://geoservices.wallonie.be/')
  WHERE data LIKE '%http://geoservices.wallonie.be/%';
