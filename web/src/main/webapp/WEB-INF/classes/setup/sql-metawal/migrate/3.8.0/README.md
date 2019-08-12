# Migration to 3.8.0

## SQL migration

First and before starting the application, run the SQL migration as described in [migrate-default.sql](migrate-default.sql).


## Application deployment


* Remove wro4j-cache*
* ouThen start the application.


## ISO19115-3:2014 to ISO19115-3:2018 migration

* Before migrating, check the current schema available in the database

```SQL
SELECT distinct(schemaid), count(*) FROM metadata GROUP BY schemaId
```

Return iso19139 and a majority of iso19115-3.


* Sign in as admin.
* Go to editor board and select all records in ISO19115-3 schema using the facets

![](filteronschema.png)


* Go to the API page 
 http://localhost:8080/geonetwork/doc/api/index.html#/processes/processRecordsUsingXslt
 * Click on `try it out` button
 * Configure parameters
  * process=iso19115-3.2018-schemaupgrade
  * bucket=e101
 * Set `response content type` to `application/json` 
 * Click on `execute` button
  
  
After a while, the response is:

```json
{
  "errors": [],
  "infos": [],
  "uuid": "00c18f16-2ef6-45b8-b5cc-2de5e95c104c",
  "metadata": [],
  "metadataErrors": {
    "!!check for any errors ?!!": true
  },
  "metadataInfos": {},
  "processId": "iso19115-3.2018-schemaupgrade",
  "noProcessFoundCount": 0,
  "numberOfNullRecords": 0,
  "numberOfRecords": 1031,
  "numberOfRecordsProcessed": 1031,
  "numberOfRecordsWithErrors": 1,
  "numberOfRecordNotFound": 0,
  "numberOfRecordsNotEditable": 0,
  "totalTimeInSeconds": 2281,
  "endIsoDateTime": "2019-08-01T11:39:43",
  "ellapsedTimeInSeconds": 2281,
  "startIsoDateTime": "2019-08-01T11:01:42",
  "running": false,
  "type": "XsltMetadataProcessingReport"
}
```


* Post migration, check the current schema available in the database

```SQL
SELECT distinct(schemaid), count(*) FROM metadata GROUP BY schemaId
```

Return a majority of iso19115-3.2018.



## ISO19115-3:2018 / Improve INSPIRE TG2 compliancy


Same procedure as previous step but with process `inspire-tg2`.
