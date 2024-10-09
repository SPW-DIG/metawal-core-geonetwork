#!/bin/bash

SERVER=https://metawal.valid.wallonie.be/geonetwork
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


QUERY="+linkUrl:/.*PANIER=.*/"
#QUERY='+uuid:"04401a23-2510-4ea1-a521-eed0778e17f8"'
FROM=0
SIZE=1000
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
#
#read -r -d '' functionXml << EOF
#      <gmd:function xmlns:gmd="http://www.isotc211.org/2005/gmd">
#        <gmd:CI_OnLineFunctionCode codeList="https://standards.iso.org/iso/19139/resources/gmxCodelists.xml#CI_OnLineFunctionCode"
#                                   codeListValue="download" />
#      </gmd:function>
#EOF
#
#  functionXml="${functionXml//$'\n'/}"

  read -r -d '' functionXml << EOF
    {
        "xpath": "/mdb:distributionInfo/*/mrd:transferOptions/*/mrd:onLine/*[starts-with(cit:linkage/*/text(), 'https://geoportail.wallonie.be/walonmap#PANIER')]/cit:protocol/*",
        "value": "<gn_replace>WWW:LINK</gn_replace>",
        "condition": ""
    },
    {
        "xpath": "/mdb:distributionInfo/*/mrd:transferOptions/*/mrd:onLine/*[starts-with(cit:linkage/*/text(), 'https://geoportail.wallonie.be/walonmap#PANIER')]/cit:applicationProfile/*",
        "value": "<gn_replace>WalOnMap</gn_replace>",
        "condition": ""
    },
    {
        "xpath": "/mdb:distributionInfo/*/mrd:transferOptions/*/mrd:onLine/*[starts-with(cit:linkage/*/text(), 'https://geoportail.wallonie.be/walonmap#PANIER')]/cit:function/*/@codeListValue",
        "value": "<gn_replace>browsing</gn_replace>",
        "condition": ""
    },
    {
    "xpath":"/mdb:distributionInfo/*/mrd:transferOptions/*/mrd:onLine/*[starts-with(cit:linkage/*/text(), 'https://geoportail.wallonie.be/walonmap#PANIER') and not(cit:applicationProfile)]",
    "value":"<gn_add><cit:applicationProfile  xmlns:cit=\"http://standards.iso.org/iso/19115/-3/cit/2.0\"  xmlns:gco=\"http://standards.iso.org/iso/19115/-3/gco/1.0\"><gco:CharacterString>WalOnMap</gco:CharacterString></cit:applicationProfile></gn_add>",
    "condition":""
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

