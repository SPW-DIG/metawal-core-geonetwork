#!/usr/bin/env bash
source /home/sites/metawal/sources/cronjobs/es-credentials

set -euo pipefail

ES="http://localhost:9200"
SRC="gn-records"
DEST="theme_weekly_open_data_snapshot"

WEEK_ID=$(TZ="Europe/Brussels" date -d "today 00:00" +"%Y%m%d")
SNAP_TS_UTC=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Execute Query request
RESP=$(curl \
  -H "Authorization: ApiKey ${ES_API_KEY}" \
  -H 'Content-Type: application/json' \
  -X POST "$ES/${SRC}/_search/template" \
  -d '{"id":"theme_open_data_weekly_counts"}')

# Parse response
BULK_FILE=$(mktemp)
#echo "$RESP" | jq .
echo "$RESP" | jq -c '.aggregations.filtered.category.buckets[]' | while read -r bucket; do
  CATEGORY=$(echo "$bucket" | jq -r '.key')
  TOTAL=$(echo "$bucket" | jq '.doc_count')
  TRUE=$(echo "$bucket" | jq '.true_values.doc_count')
  FALSE=$(echo "$bucket" | jq '.false_values.doc_count')

# generate document identifier (per week)
  DOC_ID="open_data_snapshot_${WEEK_ID}_$(echo "$CATEGORY" | tr ' /' '__')"

# Put parsed response in document
  cat >> "$BULK_FILE" <<EOF
{ "index": { "_index": "${DEST}", "_id": "${DOC_ID}" } }
{ "snapshot_timestamp": "${SNAP_TS_UTC}", "category": $(jq -Rn --arg v "$CATEGORY" '$v'), "total_count": ${TOTAL}, "true_count": ${TRUE}, "false_count": ${FALSE} }
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
