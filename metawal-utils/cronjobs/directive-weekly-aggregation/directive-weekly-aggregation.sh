#!/usr/bin/env bash
source /home/sites/metawal/sources/cronjobs/es-credentials
set -euo pipefail

ES="http://localhost:9200"
SRC="gn-records"
DEST="directive_weekly_snapshot"

WEEK_ID=$(TZ="Europe/Brussels" date -d "today 00:00" +"%Y%m%d")
SNAP_TS_UTC=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Execute Query request
RESP=$(curl \
  -H "Authorization: ApiKey ${ES_API_KEY}" \
  -H 'Content-Type: application/json' \
  -X POST "$ES/${SRC}/_search/template" \
  -d '{"id":"directive_weekly_counts"}')

# Parse response
BULK_FILE=$(mktemp)
#echo "$RESP" | jq .
echo "$RESP" | jq -c '.aggregations.filtered.buckets[]' | while read -r bucket; do
  TOTAL=$(echo "$bucket" | jq '.doc_count')
  INSPIRE=$(echo "$bucket" | jq '.inspire_values.doc_count')
  HVD=$(echo "$bucket" | jq '.hvd_values.doc_count')

# generate document identifier (per week)
  DOC_ID="directive_data_snapshot_${WEEK_ID}"

# Put parsed response in document
  cat >> "$BULK_FILE" <<EOF
{ "index": { "_index": "${DEST}", "_id": "${DOC_ID}" } }
{ "snapshot_timestamp": "${SNAP_TS_UTC}", "total_count": ${TOTAL}, "inspire_count": ${INSPIRE}, "hvd_count": ${HVD} }
EOF
done

# Import document in Elastic Index.
curl \
  -H "Authorization: ApiKey ${ES_API_KEY}" \
  -H 'Content-Type: application/x-ndjson' \
  -X POST "$ES/_bulk" \
  --data-binary @"$BULK_FILE"

# Delete local temp file.
rm -f "$BULK_FILE"
