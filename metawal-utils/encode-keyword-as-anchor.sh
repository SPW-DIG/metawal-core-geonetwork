#!/bin/bash

SERVER=http://localhost:8080/geonetwork
#SERVER=http://172.22.80.1:8080/geonetwork
CATALOGUSER=SPBTIT
CATALOGPASS=<replace>
#AUTH="-u $CATALOGUSER:$CATALOGPASS"
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
#QUERY='+uuid:"d4b09a90-62b9-4e5a-88dd-7733f33063df"'
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

curl $AUTH "$SERVER/srv/api/search/records/_search?bucket=s101" \
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

curl -X POST $AUTH "$SERVER/srv/api/processes/encode-keyword-as-anchor?uuids="+uuid+"&applyUpdateFixedInfo=true&index=true" \
      -H 'accept: application/json, text/plain, */*' \
      -H 'accept-language: eng' \
      -H "X-XSRF-TOKEN: $TOKEN" \
      -H "Cookie: XSRF-TOKEN=$TOKEN; JSESSIONID=$JSESSIONID" \
      -H 'content-type: application/json;charset=UTF-8' \
      -o results-replace-keyword.json

echo "Processing executed for $uuid"
((current++));

done

