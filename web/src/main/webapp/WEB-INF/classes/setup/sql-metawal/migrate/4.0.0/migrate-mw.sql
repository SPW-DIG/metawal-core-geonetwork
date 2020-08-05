UPDATE metadata
    SET data = replace(data,
                       'http://://metawal3.valid.wallonie.be',
                        'http://metawal.wallonie.be')
    WHERE data LIKE '%http://://metawal3.valid.wallonie.be%';
