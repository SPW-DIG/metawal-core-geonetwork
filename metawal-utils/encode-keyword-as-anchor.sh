#!/bin/bash

SERVER=https://metawal.test.wallonie.be/geonetwork
#SERVER=http://localhost:8080/geonetwork
CATALOGUSER=SPBTIT
CATALOGPASS=<replace>
#AUTH="-u $CATALOGUSER:$CATALOGPASS"
AUTH=""


rm -f cookie.txt;

curl -v --insecure -s -c cookie.txt -o /dev/null \
  -X GET  \
  --user $CATALOGUSER:$CATALOGPASS \
  -H "Accept: application/json" \
  "$SERVER/srv/api/me";

# Convert file to LF line endings
sed -i 's/\r$//' cookie.txt

export TOKEN=`grep XSRF-TOKEN cookie.txt | cut -f 7`;
export JSESSIONID=`grep JSESSIONID cookie.txt | cut -f 7`;

echo "Token: $TOKEN";
echo "Session: $JSESSIONID";

curl "$SERVER/srv/api/me" \
  -H 'accept: application/json, text/plain, */*' \
  -H 'accept-language: eng' \
  -H "X-XSRF-TOKEN: $TOKEN" \
  -H "Cookie: XSRF-TOKEN=$TOKEN; JSESSIONID=$JSESSIONID"

#QUERY='+uuid:"b5b34ee9-9513-4298-8cd0-2968a5ce4003"'
QUERY='*:*'
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
echo "RAWQUERY: $RAWQUERY"

curl --insecure --verbose $AUTH "$SERVER/srv/api/search/records/_search" \
  -H 'accept: application/json, text/plain, */*' \
  -H 'accept-language: eng' \
  -H "X-XSRF-TOKEN: $TOKEN" \
  -H "Cookie: XSRF-TOKEN=$TOKEN; JSESSIONID=$JSESSIONID" \
  -H 'content-type: application/json;charset=UTF-8' \
  --data-raw "$RAWQUERY" \
  --compressed \
  -o results.json

current=1;
total=$(jq -r '.hits.total.value' results.json)

for hit in $(jq -r '.hits.hits[] | @base64' results.json); do
   _jq() {
     echo "${hit}" | base64 --decode | jq -r "${1}"
    }

  title=$(_jq '._source.resourceTitleObject.default')
  uuid=$(_jq '._id')
  echo "$uuid / $title\n"
  functionXml=""

echo "progress: $current/$total"
echo "executing processing for $uuid"


curl --insecure $AUTH "$SERVER/srv/api/processes/encode-keyword-as-anchor?uuids=$uuid&applyUpdateFixedInfo=true&index=true" \
      -X 'POST' \
      -H 'accept: application/json' \
      -H 'accept-language: eng' \
      -H "X-XSRF-TOKEN: $TOKEN" \
      -H "Cookie: XSRF-TOKEN=$TOKEN; JSESSIONID=$JSESSIONID" \
      -H 'content-type: application/json;charset=UTF-8' \
      -o "logs/$uuid-results-replace-keyword.json"

echo "Processing executed for $uuid"
((current++));

done

