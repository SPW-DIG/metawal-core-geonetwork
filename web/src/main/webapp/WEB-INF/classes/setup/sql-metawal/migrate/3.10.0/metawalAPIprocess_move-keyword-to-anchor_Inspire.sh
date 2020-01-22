#!/bin/bash

unset http_proxy

export CATALOG=http://157.164.189.202:8080/geonetwork
export CATALOGUSER=SPBTIT
export CATALOGPASS=tgTdzu8

curl -s -c /tmp/cookie -o /dev/null -X POST "$CATALOG/srv/eng/info?type=me";

export TOKEN=`grep XSRF-TOKEN /tmp/cookie | cut -f 7`;

curl -X POST -H "X-XSRF-TOKEN: $TOKEN" --user $CATALOGUSER:$CATALOGPASS -b /tmp/cookie "$CATALOG/srv/eng/info?type=me"

# MUST return @authenticated = true

curl -X GET "$CATALOG/srv/fre/q?_schema=iso19115-3.2018&_isTemplate=y+or+n&summaryOnly=true&bucket=111" -H "X-XSRF-TOKEN: $TOKEN" -c /tmp/cookie -b /tmp/cookie --user $CATALOGUSER:$CATALOGPASS

#It works

curl -X PUT "$CATALOG/srv/api/0.1/selections/111" -H "accept: application/json" -H "X-XSRF-TOKEN: $TOKEN" -c /tmp/cookie -b /tmp/cookie --user $CATALOGUSER:$CATALOGPASS

#Return the number of selected MTD (~1002)

curl -X POST "$CATALOG/srv/api/0.1/processes/move-keyword-to-anchor?bucket=111&updateDateStamp=false&index=true" -H "accept: application/json" -H "X-XSRF-TOKEN: $TOKEN" -c /tmp/cookie -b /tmp/cookie --user $CATALOGUSER:$CATALOGPASS

#Return the process information