#!/bin/bash

SERVER=https://metawal.valid.wallonie.be/geonetwork
CATALOGUSER=SPBTIT
CATALOGPASS=<replace>
AUTH=""


rm -f /tmp/cookie;

curl -s -c /tmp/cookie -o /dev/null \
  -X GET  \
  --user $CATALOGUSER:$CATALOGPASS \
  -H "Accept: application/json" \
  "$SERVER/srv/api/me";

export TOKEN=`grep XSRF-TOKEN /tmp/cookie | cut -f 7`;
export JSESSIONID=`grep JSESSIONID /tmp/cookie | cut -f 7`;

curl "$SERVER/srv/api/me" \
  -H 'accept: application/json, text/plain, */*' \
  -H 'accept-language: eng' \
  -H "X-XSRF-TOKEN: $TOKEN" \
  -H "Cookie: XSRF-TOKEN=$TOKEN; JSESSIONID=$JSESSIONID"


#QUERY="+linkUrl:/.*PANIER=.*/"
QUERY='+uuid:"c34743fa-7c50-4bfe-b587-e1253ff68eae"'
FROM=0
SIZE=5000
read -r -d '' ESQUERY << EOF
{
  "from":${FROM},
  "size":${SIZE},
  "query":{"query_string":{"query":"${QUERY//\"/\\\"}"}},
  "_source":{"includes":["uuid", "resourceTitleObject*"]}
}
EOF

RAWQUERY=`echo ${ESQUERY}`

curl $AUTH "$SERVER/srv/api/search/records/_search?bucket=s101" \
  -H 'accept: application/json, text/plain, */*' \
  -H 'accept-language: eng' \
  -H "X-XSRF-TOKEN: $TOKEN" \
  -H "Cookie: XSRF-TOKEN=$TOKEN; JSESSIONID=$JSESSIONID" \
  -H 'content-type: application/json;charset=UTF-8' \
  --data-raw "$RAWQUERY" \
  --compressed \
  -o results.json

for hit in $(jq -r '.hits.hits[] | @base64' results.json); do
   _jq() {
     echo "${hit}" | base64 --decode | jq -r "${1}"
    }

  title=$(_jq '._source.resourceTitleObject.default')
  uuid=$(_jq '._id')
  echo "$uuid / $title\n"
  functionXml=""

  read -r -d '' functionXml << EOF
    {
        "xpath": "/mdb:distributionInfo/*/mrd:transferOptions/*/mrd:onLine/*[starts-with(cit:linkage/*/text(), 'https://geoportail.wallonie.be/walonmap#PANIER')]/cit:linkage/*",
        "value": "<gn_replace>https://geoportail.wallonie.be/carte#ADD|METADATAID=$uuid</gn_replace>",
        "condition": ""
    }
EOF

  echo $functionXml

  curl $AUTH "$SERVER/srv/api/records/batchediting?uuids=$uuid" \
    -X 'PUT' \
    -H 'Accept: application/json, text/plain, */*' \
    -H 'Content-Type: application/json;charset=UTF-8' \
    -H "X-XSRF-TOKEN: $TOKEN" \
    -H "Cookie: XSRF-TOKEN=$TOKEN; JSESSIONID=$JSESSIONID" \
    --data-raw "[$functionXml]" \
    --compressed
done

