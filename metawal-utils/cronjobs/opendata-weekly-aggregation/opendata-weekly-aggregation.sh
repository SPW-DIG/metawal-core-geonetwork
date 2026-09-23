#!/usr/bin/env bash
source /home/sites/metawal/sources/cronjobs/es-credentials
set -euo pipefail

ES="http://localhost:9200"
SRC="gn-records"
DEST="opendata_weekly_snapshot"

WEEK_ID=$(TZ="Europe/Brussels" date -d "today 00:00" +"%Y%m%d")
SNAP_TS_UTC=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Execute Query request
RESP=$(curl \
  -H "Authorization: ApiKey ${ES_API_KEY}" \
  -H 'Content-Type: application/json' \
  -X POST "$ES/${SRC}/_search/template" \
  -d '{"id":"opendata_weekly_counts"}')

# Parse response
BULK_FILE=$(mktemp)
#echo "$RESP" | jq .
FILTERED=$(jq -c '.aggregations.filtered' <<< "$RESP")
TOTAL=$(echo "$FILTERED" | jq '.doc_count')
TRUE=$(echo "$FILTERED" | jq '.true_values.doc_count')
FALSE=$(echo "$FILTERED" | jq '.false_values.doc_count')

# generate document identifier (per week)
DOC_ID="opendata_weekly_snapshot_${WEEK_ID}"

# Put parsed response in document
cat >> "$BULK_FILE" <<EOF
{ "index": { "_index": "${DEST}", "_id": "${DOC_ID}" } }
{ "snapshot_timestamp": "${SNAP_TS_UTC}", "total_count": ${TOTAL}, "true_count": ${TRUE}, "false_count": ${FALSE} }
EOF

# Import document in Elastic Index.
curl \
  -H "Authorization: ApiKey ${ES_API_KEY}" \
  -H 'Content-Type: application/x-ndjson' \
  -X POST "$ES/_bulk" \
  --data-binary @"$BULK_FILE"

# Delete local temp file.
rm -f "$BULK_FILE"
