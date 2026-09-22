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
TOTAL=$(echo "$RESP" | jq '.aggregations.filtered.doc_count')

for FIELD in inspire_values hvd_values; do
  DOC_COUNT=$(echo "$RESP" | jq ".aggregations.filtered.${FIELD}.doc_count")
  TRUE_COUNT=$(echo "$RESP" | jq ".aggregations.filtered.${FIELD}.true_values.doc_count")
  FALSE_COUNT=$(echo "$RESP" | jq ".aggregations.filtered.${FIELD}.false_values.doc_count")

# generate document identifier (per week, per aggregation)
  DOC_ID="directive_data_snapshot_${WEEK_ID}_${FIELD}"

# Put parsed response in document
  cat >> "$BULK_FILE" <<EOF
{ "index": { "_index": "${DEST}", "_id": "${DOC_ID}" } }
{ "snapshot_timestamp": "${SNAP_TS_UTC}", "category": "${FIELD}", "total_count": ${DOC_COUNT}, "true_count": ${TRUE_COUNT}, "false_count": ${FALSE_COUNT} }
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
